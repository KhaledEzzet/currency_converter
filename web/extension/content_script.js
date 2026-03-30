(function () {
  const SKIPPED_TAGS = new Set([
    'A',
    'BUTTON',
    'CODE',
    'INPUT',
    'NOSCRIPT',
    'OPTION',
    'PRE',
    'SCRIPT',
    'SELECT',
    'STYLE',
    'SUMMARY',
    'TEXTAREA',
  ]);
  const PRICE_SPAN_ATTRIBUTE = 'data-currency-converter-price';
  const TOOLTIP_ID = 'currency-converter-page-tooltip';
  const PRICE_CANDIDATE_PATTERN =
    /\b[A-Z]{3}\s*[0-9]|[0-9]\s*[A-Z]{3}\b|[$€£¥₹₽]\s*[0-9]|[0-9]\s*(?:zł|€|£|¥|₹|₽)\b/;
  const ISO_PREFIX_PATTERN =
    /\b([A-Z]{3})\s*([0-9]+(?:[ ,][0-9]{3})*(?:[.,][0-9]+)?)\b/g;
  const ISO_SUFFIX_PATTERN =
    /\b([0-9]+(?:[ ,][0-9]{3})*(?:[.,][0-9]+)?)\s*([A-Z]{3})\b/g;
  const SYMBOL_PREFIX_PATTERN =
    /(?<!\w)([$€£¥₹₽])\s*([0-9]+(?:[ ,][0-9]{3})*(?:[.,][0-9]+)?)/g;
  const SYMBOL_SUFFIX_PATTERN =
    /\b([0-9]+(?:[ ,][0-9]{3})*(?:[.,][0-9]+)?)\s*(zł|€|£|¥|₹|₽)\b/g;
  const PREFIX_SYMBOL_CURRENCIES = {
    $: 'USD',
    '€': 'EUR',
    '£': 'GBP',
    '¥': 'JPY',
    '₹': 'INR',
    '₽': 'RUB',
  };
  const SUFFIX_SYMBOL_CURRENCIES = {
    '€': 'EUR',
    '£': 'GBP',
    '¥': 'JPY',
    '₹': 'INR',
    '₽': 'RUB',
    'zł': 'PLN',
  };

  let extensionSettings = {
    baseCurrency: 'USD',
    webPriceAccessibilityEnabled: true,
  };
  let tooltipElement = null;
  let mutationObserver = null;
  let ratePrefetchQueued = false;
  const detectedSourceCurrencies = new Set();
  const conversionRates = new Map();

  init().catch(() => {});

  async function init() {
    const response = await sendMessage({ type: 'GET_EXTENSION_SETTINGS' });
    if (!response?.ok) {
      return;
    }

    extensionSettings = normalizeSettings(response.settings);
    if (!extensionSettings.webPriceAccessibilityEnabled || !document.body) {
      return;
    }

    bindGlobalTooltipEvents();
    scanNode(document.body);
    scheduleRatePrefetch();
    observeMutations();
  }

  function normalizeSettings(settings) {
    const baseCurrency =
      typeof settings?.baseCurrency === 'string' &&
      /^[A-Z]{3}$/.test(settings.baseCurrency.toUpperCase())
        ? settings.baseCurrency.toUpperCase()
        : 'USD';

    return {
      baseCurrency,
      webPriceAccessibilityEnabled:
        typeof settings?.webPriceAccessibilityEnabled === 'boolean'
          ? settings.webPriceAccessibilityEnabled
          : true,
    };
  }

  function observeMutations() {
    mutationObserver = new MutationObserver((mutations) => {
      for (const mutation of mutations) {
        if (mutation.type === 'childList') {
          for (const addedNode of mutation.addedNodes) {
            scanNode(addedNode);
          }
          continue;
        }

        if (mutation.type === 'characterData') {
          scanNode(mutation.target);
        }
      }
    });

    mutationObserver.observe(document.body, {
      childList: true,
      subtree: true,
      characterData: true,
    });
  }

  function scanNode(node) {
    if (!extensionSettings.webPriceAccessibilityEnabled || !node) {
      return;
    }

    if (node.nodeType === Node.TEXT_NODE) {
      processTextNode(node);
      return;
    }

    if (node.nodeType !== Node.ELEMENT_NODE) {
      return;
    }

    const element = node;
    if (element.closest(`[${PRICE_SPAN_ATTRIBUTE}="true"]`)) {
      return;
    }

    const walker = document.createTreeWalker(
      element,
      NodeFilter.SHOW_TEXT,
      {
        acceptNode(currentNode) {
          return isCandidateTextNode(currentNode)
            ? NodeFilter.FILTER_ACCEPT
            : NodeFilter.FILTER_REJECT;
        },
      },
    );

    const textNodes = [];
    let currentNode = walker.nextNode();
    while (currentNode) {
      textNodes.push(currentNode);
      currentNode = walker.nextNode();
    }

    for (const textNode of textNodes) {
      processTextNode(textNode);
    }
  }

  function isCandidateTextNode(node) {
    if (!(node instanceof Text)) {
      return false;
    }

    const text = node.textContent;
    if (!text || !PRICE_CANDIDATE_PATTERN.test(text)) {
      return false;
    }

    const parent = node.parentElement;
    if (!parent || parent.closest(`[${PRICE_SPAN_ATTRIBUTE}="true"]`)) {
      return false;
    }

    if (hasBlockedAncestor(parent) || !isElementVisible(parent)) {
      return false;
    }

    return true;
  }

  function hasBlockedAncestor(element) {
    let current = element;
    while (current) {
      if (SKIPPED_TAGS.has(current.tagName)) {
        return true;
      }

      if (
        current.hasAttribute('contenteditable') &&
        current.getAttribute('contenteditable') !== 'false'
      ) {
        return true;
      }

      current = current.parentElement;
    }

    return false;
  }

  function isElementVisible(element) {
    let current = element;
    while (current) {
      if (current.hidden || current.getAttribute('aria-hidden') === 'true') {
        return false;
      }

      const style = window.getComputedStyle(current);
      if (
        style.display === 'none' ||
        style.visibility === 'hidden' ||
        style.opacity === '0'
      ) {
        return false;
      }

      current = current.parentElement;
    }

    return element.getClientRects().length > 0;
  }

  function processTextNode(textNode) {
    if (!isCandidateTextNode(textNode)) {
      return;
    }

    const text = textNode.textContent;
    const matches = detectPrices(text);
    if (matches.length === 0) {
      return;
    }

    const fragment = document.createDocumentFragment();
    let cursor = 0;
    let replacedMatch = false;

    for (const match of matches) {
      const start = match.index;
      const end = match.index + match.rawText.length;

      if (start > cursor) {
        fragment.append(text.slice(cursor, start));
      }

      if (match.sourceCurrency === extensionSettings.baseCurrency) {
        fragment.append(match.rawText);
      } else {
        fragment.append(createPriceNode(match));
        detectedSourceCurrencies.add(match.sourceCurrency);
        replacedMatch = true;
      }

      cursor = end;
    }

    if (cursor < text.length) {
      fragment.append(text.slice(cursor));
    }

    if (!replacedMatch) {
      return;
    }

    textNode.parentNode.replaceChild(fragment, textNode);
    scheduleRatePrefetch();
  }

  function detectPrices(text) {
    const matches = [];

    collectPatternMatches(matches, text, ISO_PREFIX_PATTERN, (match) => ({
      rawText: match[0],
      sourceCurrency: match[1].toUpperCase(),
      amount: parseAmount(match[2]),
      index: match.index,
    }));
    collectPatternMatches(matches, text, ISO_SUFFIX_PATTERN, (match) => ({
      rawText: match[0],
      sourceCurrency: match[2].toUpperCase(),
      amount: parseAmount(match[1]),
      index: match.index,
    }));
    collectPatternMatches(matches, text, SYMBOL_PREFIX_PATTERN, (match) => ({
      rawText: match[0],
      sourceCurrency: PREFIX_SYMBOL_CURRENCIES[match[1]],
      amount: parseAmount(match[2]),
      index: match.index,
    }));
    collectPatternMatches(matches, text, SYMBOL_SUFFIX_PATTERN, (match) => ({
      rawText: match[0],
      sourceCurrency: SUFFIX_SYMBOL_CURRENCIES[match[2]],
      amount: parseAmount(match[1]),
      index: match.index,
    }));

    matches.sort((left, right) => {
      if (left.index !== right.index) {
        return left.index - right.index;
      }
      return right.rawText.length - left.rawText.length;
    });

    const acceptedMatches = [];
    let lastEnd = -1;

    for (const match of matches) {
      if (
        !match.sourceCurrency ||
        !Number.isFinite(match.amount) ||
        match.index < lastEnd
      ) {
        continue;
      }

      acceptedMatches.push(match);
      lastEnd = match.index + match.rawText.length;
    }

    return acceptedMatches;
  }

  function collectPatternMatches(collection, text, pattern, mapper) {
    pattern.lastIndex = 0;
    let match = pattern.exec(text);

    while (match) {
      collection.push(mapper(match));
      match = pattern.exec(text);
    }
  }

  function parseAmount(rawAmount) {
    const compact = rawAmount.replaceAll(' ', '');
    const hasComma = compact.includes(',');
    const hasDot = compact.includes('.');

    if (hasComma && hasDot) {
      return compact.lastIndexOf(',') > compact.lastIndexOf('.')
        ? Number(compact.replaceAll('.', '').replace(',', '.'))
        : Number(compact.replaceAll(',', ''));
    }

    if (hasComma) {
      const parts = compact.split(',');
      return parts.length === 2 && parts[1].length <= 2
        ? Number(compact.replace(',', '.'))
        : Number(compact.replaceAll(',', ''));
    }

    if (hasDot) {
      const parts = compact.split('.');
      return parts.length === 2 && parts[1].length <= 2
        ? Number(compact)
        : Number(compact.replaceAll('.', ''));
    }

    return Number(compact);
  }

  function createPriceNode(match) {
    const priceNode = document.createElement('span');
    priceNode.textContent = match.rawText;
    priceNode.setAttribute(PRICE_SPAN_ATTRIBUTE, 'true');
    priceNode.setAttribute('tabindex', '0');
    priceNode.dataset.amount = String(match.amount);
    priceNode.dataset.sourceCurrency = match.sourceCurrency;
    priceNode.style.cursor = 'help';
    priceNode.style.textDecoration = 'underline dotted';
    priceNode.style.textUnderlineOffset = '0.18em';

    priceNode.addEventListener('mouseenter', () => showTooltip(priceNode));
    priceNode.addEventListener('focus', () => showTooltip(priceNode));
    priceNode.addEventListener('mouseleave', hideTooltip);
    priceNode.addEventListener('blur', hideTooltip);
    priceNode.addEventListener('keydown', (event) => {
      if (event.key === 'Escape') {
        hideTooltip();
      }
    });

    return priceNode;
  }

  function bindGlobalTooltipEvents() {
    window.addEventListener('scroll', hideTooltip, true);
    window.addEventListener('resize', hideTooltip, true);
    document.addEventListener(
      'keydown',
      (event) => {
        if (event.key === 'Escape') {
          hideTooltip();
        }
      },
      true,
    );
  }

  function ensureTooltip() {
    if (tooltipElement) {
      return tooltipElement;
    }

    tooltipElement = document.createElement('div');
    tooltipElement.id = TOOLTIP_ID;
    tooltipElement.style.position = 'fixed';
    tooltipElement.style.zIndex = '2147483647';
    tooltipElement.style.display = 'none';
    tooltipElement.style.maxWidth = '240px';
    tooltipElement.style.padding = '10px 12px';
    tooltipElement.style.borderRadius = '10px';
    tooltipElement.style.background = '#111827';
    tooltipElement.style.color = '#F9FAFB';
    tooltipElement.style.boxShadow = '0 18px 40px rgba(15, 23, 42, 0.22)';
    tooltipElement.style.pointerEvents = 'none';
    tooltipElement.style.fontFamily =
      'system-ui, -apple-system, BlinkMacSystemFont, sans-serif';
    tooltipElement.style.fontSize = '12px';
    tooltipElement.style.lineHeight = '1.4';
    tooltipElement.style.whiteSpace = 'normal';
    document.body.append(tooltipElement);
    return tooltipElement;
  }

  function showTooltip(priceNode) {
    const amount = Number(priceNode.dataset.amount);
    const sourceCurrency = priceNode.dataset.sourceCurrency;
    const tooltip = ensureTooltip();
    const conversionRate = conversionRates.get(sourceCurrency);

    tooltip.innerHTML = '';

    if (!Number.isFinite(amount) || !sourceCurrency) {
      tooltip.textContent = 'Conversion unavailable';
    } else if (!Number.isFinite(conversionRate)) {
      tooltip.textContent = 'Conversion unavailable';
    } else {
      const label = document.createElement('div');
      label.textContent = `Converted to ${extensionSettings.baseCurrency}`;
      label.style.opacity = '0.8';
      label.style.marginBottom = '4px';

      const value = document.createElement('div');
      value.textContent = formatCurrency(
        amount * conversionRate,
        extensionSettings.baseCurrency,
      );
      value.style.fontSize = '14px';
      value.style.fontWeight = '700';

      tooltip.append(label, value);
    }

    tooltip.style.display = 'block';
    positionTooltip(priceNode, tooltip);
  }

  function positionTooltip(anchorNode, tooltip) {
    const anchorRect = anchorNode.getBoundingClientRect();
    const tooltipRect = tooltip.getBoundingClientRect();
    const spacing = 10;
    const maxLeft = window.innerWidth - tooltipRect.width - spacing;
    const centeredLeft =
      anchorRect.left + anchorRect.width / 2 - tooltipRect.width / 2;
    const left = Math.min(Math.max(spacing, centeredLeft), maxLeft);

    let top = anchorRect.top - tooltipRect.height - spacing;
    if (top < spacing) {
      top = anchorRect.bottom + spacing;
    }

    tooltip.style.left = `${left}px`;
    tooltip.style.top = `${top}px`;
  }

  function hideTooltip() {
    if (tooltipElement) {
      tooltipElement.style.display = 'none';
    }
  }

  function scheduleRatePrefetch() {
    if (ratePrefetchQueued) {
      return;
    }

    ratePrefetchQueued = true;
    queueMicrotask(async () => {
      ratePrefetchQueued = false;
      const sourceCurrencies = [...detectedSourceCurrencies].filter(
        (currency) => currency !== extensionSettings.baseCurrency,
      );

      if (sourceCurrencies.length === 0) {
        return;
      }

      const response = await sendMessage({
        type: 'GET_PAGE_CONVERSION_RATES',
        targetCurrency: extensionSettings.baseCurrency,
        sourceCurrencies,
      });

      if (!response?.ok || typeof response.rates !== 'object') {
        return;
      }

      for (const [currency, rate] of Object.entries(response.rates)) {
        if (Number.isFinite(rate)) {
          conversionRates.set(currency, rate);
        }
      }
    });
  }

  function formatCurrency(value, currency) {
    try {
      return new Intl.NumberFormat(undefined, {
        style: 'currency',
        currency,
        maximumFractionDigits: 2,
      }).format(value);
    } catch (_error) {
      return `${currency} ${value.toFixed(2)}`;
    }
  }

  function sendMessage(message) {
    return new Promise((resolve) => {
      try {
        chrome.runtime.sendMessage(message, (response) => {
          if (chrome.runtime.lastError) {
            resolve({
              ok: false,
              error: chrome.runtime.lastError.message,
            });
            return;
          }

          resolve(response);
        });
      } catch (error) {
        resolve({
          ok: false,
          error: error instanceof Error ? error.message : String(error),
        });
      }
    });
  }
})();
