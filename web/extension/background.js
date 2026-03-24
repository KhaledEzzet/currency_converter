const SETTINGS_KEY = 'currencyConverterExtensionSettings';
const DEFAULT_SETTINGS = {
  baseCurrency: 'USD',
  webPriceAccessibilityEnabled: false,
};
const RATE_CACHE_TTL_MS = 15 * 60 * 1000;

const rateCache = new Map();

function normalizeCurrencyCode(value) {
  if (typeof value !== 'string') {
    return null;
  }

  const normalized = value.trim().toUpperCase();
  return /^[A-Z]{3}$/.test(normalized) ? normalized : null;
}

async function getStoredSettings() {
  const stored = await chrome.storage.local.get(SETTINGS_KEY);
  const rawSettings = stored?.[SETTINGS_KEY];

  return {
    baseCurrency:
      normalizeCurrencyCode(rawSettings?.baseCurrency) ??
      DEFAULT_SETTINGS.baseCurrency,
    webPriceAccessibilityEnabled:
      rawSettings?.webPriceAccessibilityEnabled === true,
  };
}

function buildRateCacheKey(targetCurrency, sourceCurrencies) {
  return [targetCurrency, ...sourceCurrencies].join(':');
}

function normalizeSourceCurrencies(sourceCurrencies, targetCurrency) {
  return [...new Set(sourceCurrencies.map(normalizeCurrencyCode).filter(Boolean))]
    .filter((currency) => currency !== targetCurrency)
    .sort();
}

async function getPageConversionRates({ targetCurrency, sourceCurrencies }) {
  const normalizedTargetCurrency =
    normalizeCurrencyCode(targetCurrency) ?? DEFAULT_SETTINGS.baseCurrency;
  const normalizedSourceCurrencies = normalizeSourceCurrencies(
    Array.isArray(sourceCurrencies) ? sourceCurrencies : [],
    normalizedTargetCurrency,
  );

  if (normalizedSourceCurrencies.length === 0) {
    return {
      targetCurrency: normalizedTargetCurrency,
      rates: {},
    };
  }

  const cacheKey = buildRateCacheKey(
    normalizedTargetCurrency,
    normalizedSourceCurrencies,
  );
  const cachedEntry = rateCache.get(cacheKey);

  if (cachedEntry && cachedEntry.expiresAt > Date.now()) {
    return cachedEntry.payload;
  }

  const url = new URL('https://api.frankfurter.app/latest');
  url.searchParams.set('from', normalizedTargetCurrency);
  url.searchParams.set('to', normalizedSourceCurrencies.join(','));

  const response = await fetch(url.toString());
  if (!response.ok) {
    throw new Error(`Rate request failed with status ${response.status}.`);
  }

  const data = await response.json();
  const rates = {};

  for (const sourceCurrency of normalizedSourceCurrencies) {
    const quotedRate = Number(data?.rates?.[sourceCurrency]);
    if (!Number.isFinite(quotedRate) || quotedRate <= 0) {
      continue;
    }

    rates[sourceCurrency] = 1 / quotedRate;
  }

  const payload = {
    targetCurrency: normalizedTargetCurrency,
    rates,
  };

  rateCache.set(cacheKey, {
    expiresAt: Date.now() + RATE_CACHE_TTL_MS,
    payload,
  });

  return payload;
}

chrome.runtime.onMessage.addListener((message, _sender, sendResponse) => {
  (async () => {
    switch (message?.type) {
      case 'GET_EXTENSION_SETTINGS': {
        sendResponse({
          ok: true,
          settings: await getStoredSettings(),
        });
        return;
      }
      case 'GET_PAGE_CONVERSION_RATES': {
        const settings = await getStoredSettings();
        sendResponse({
          ok: true,
          ...(await getPageConversionRates({
            targetCurrency: message?.targetCurrency ?? settings.baseCurrency,
            sourceCurrencies: message?.sourceCurrencies,
          })),
        });
        return;
      }
      default: {
        sendResponse({
          ok: false,
          error: 'Unsupported message type.',
        });
      }
    }
  })().catch((error) => {
    sendResponse({
      ok: false,
      error: error instanceof Error ? error.message : String(error),
    });
  });

  return true;
});
