import 'dart:async';

import 'package:currency_converter/feature/convert/view/widgets/currency_flag.dart';
import 'package:currency_converter/feature/onboarding/cubit/onboarding_cubit.dart';
import 'package:currency_converter/feature/onboarding/cubit/onboarding_state.dart';
import 'package:currency_converter/feature/settings/cubit/settings_cubit.dart';
import 'package:currency_converter/feature/settings/cubit/settings_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ─── Gate ──────────────────────────────────────────────────────────────────

class OnboardingGate extends StatelessWidget {
  const OnboardingGate({
    required this.child,
    super.key,
  });

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        if (state.hasCompletedOnboarding) {
          return child ?? const SizedBox.shrink();
        }

        if (child == null) {
          return const OnboardingView();
        }

        return Stack(
          fit: StackFit.expand,
          children: [
            child!,
            const OnboardingView(),
          ],
        );
      },
    );
  }
}

// ─── Data ──────────────────────────────────────────────────────────────────

class _Goal {
  const _Goal(this.emoji, this.title, this.subtitle);
  final String emoji;
  final String title;
  final String subtitle;
}

class _Testimonial {
  const _Testimonial(this.quote, this.name, this.tag, this.emoji);
  final String quote;
  final String name;
  final String tag;
  final String emoji;
}

// ─── Onboarding View ───────────────────────────────────────────────────────

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView>
    with SingleTickerProviderStateMixin {
  static const int _totalPages = 8;

  late final PageController _pageController;
  late final AnimationController _pulseController;
  int _currentPage = 0;

  String? _selectedGoal;
  final Set<int> _selectedPains = {};
  late String _selectedBase;
  final Set<String> _selectedDisplay = {};

  static const _goals = [
    _Goal('✈️', 'Frequent traveler', 'I need rates on the go'),
    _Goal('🏠', 'Living abroad', 'I track my home currency daily'),
    _Goal('🛒', 'Online shopper', 'I buy from foreign sites'),
    _Goal('📈', 'Rate watcher', 'I follow FX trends'),
    _Goal('🎓', 'Student abroad', 'Managing a tight budget overseas'),
    _Goal('💼', 'Business', 'I deal with international payments'),
  ];

  static const _painLabels = [
    ('🧮', 'Doing the math in my head at shops'),
    ('🔄', 'Checking one currency at a time'),
    ('📱', 'Switching between multiple apps'),
    ('📉', 'Not knowing if the rate is good or bad today'),
    ('⚙️', 'Re-entering my settings every time'),
    ('🕒', "Rates that aren't up to date"),
  ];

  static const _testimonials = [
    _Testimonial(
      'Finally an app that shows all my currencies at once. I use it every day in Tokyo.',
      'Sarah K.',
      '✈️ Frequent Traveler',
      '✈️',
    ),
    _Testimonial(
      'I send money home every month. This tells me exactly when the rate is worth it.',
      'Marcos L.',
      '🏠 Expat in London',
      '🏠',
    ),
    _Testimonial(
      'I shop on European sites constantly. Seeing the EUR price in USD instantly saves me so much back-and-forth.',
      'Priya M.',
      '🛒 Online Shopper',
      '🛒',
    ),
  ];

  static const _popularCurrencies = [
    'AED', 'AUD', 'BRL', 'CAD', 'CHF', 'CNY', 'CZK', 'DKK',
    'EUR', 'GBP', 'HKD', 'HUF', 'IDR', 'ILS', 'INR', 'JPY',
    'KRW', 'MXN', 'MYR', 'NOK', 'NZD', 'PHP', 'PLN', 'RON',
    'RUB', 'SAR', 'SEK', 'SGD', 'THB', 'TRY', 'TWD', 'USD', 'ZAR',
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    final settingsBase = context.read<SettingsCubit>().state.baseCurrency;
    _selectedBase = settingsBase.isNotEmpty ? settingsBase : 'USD';
  }

  @override
  void dispose() {
    _pageController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  List<String> _resolvedCurrencies(SettingsState state) {
    if (state.status == SettingsStatus.success && state.currencies.isNotEmpty) {
      return state.currencies;
    }
    return _popularCurrencies;
  }

  void _goNext() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  void _goBack() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  void _onPageChanged(int page) {
    setState(() => _currentPage = page);
    if (page == 7) _beginProcessing();
  }

  void _beginProcessing() {
    context.read<SettingsCubit>().updateBaseCurrency(_selectedBase);
    if (_selectedDisplay.isNotEmpty) {
      context
          .read<SettingsCubit>()
          .updateDisplayCurrencies(_selectedDisplay.toList());
    }
    _pulseController.repeat(reverse: true);
    Timer(const Duration(milliseconds: 1800), () {
      if (mounted) context.read<OnboardingCubit>().completeOnboarding();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xff000000) : const Color(0xfff5f5f7);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            _ProgressHeader(
              currentPage: _currentPage,
              totalPages: _totalPages,
              isDark: isDark,
              onBack: _goBack,
            ),
            Expanded(
              child: BlocBuilder<SettingsCubit, SettingsState>(
                builder: (context, settingsState) {
                  final currencies = _resolvedCurrencies(settingsState);
                  return PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: _onPageChanged,
                    children: [
                      _WelcomePage(isDark: isDark, onNext: _goNext),
                      _GoalPage(
                        isDark: isDark,
                        goals: _goals,
                        selected: _selectedGoal,
                        onSelect: (g) => setState(() => _selectedGoal = g),
                        onNext: _goNext,
                      ),
                      _PainPage(
                        isDark: isDark,
                        pains: _painLabels,
                        selected: _selectedPains,
                        onToggle: (i) => setState(() {
                          _selectedPains.contains(i)
                              ? _selectedPains.remove(i)
                              : _selectedPains.add(i);
                        }),
                        onNext: _goNext,
                      ),
                      _SocialProofPage(
                        isDark: isDark,
                        testimonials: _testimonials,
                        onNext: _goNext,
                      ),
                      _SolutionPage(isDark: isDark, onNext: _goNext),
                      _BaseCurrencyPage(
                        isDark: isDark,
                        currencies: currencies,
                        selected: _selectedBase,
                        onSelect: (c) => setState(() => _selectedBase = c),
                        onNext: _goNext,
                      ),
                      _DisplayCurrenciesPage(
                        isDark: isDark,
                        currencies: currencies,
                        base: _selectedBase,
                        selected: _selectedDisplay,
                        onToggle: (c) => setState(() {
                          _selectedDisplay.contains(c)
                              ? _selectedDisplay.remove(c)
                              : _selectedDisplay.add(c);
                        }),
                        onNext: _goNext,
                      ),
                      _ProcessingPage(
                        isDark: isDark,
                        pulseController: _pulseController,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Progress Header ───────────────────────────────────────────────────────

class _ProgressHeader extends StatelessWidget {
  const _ProgressHeader({
    required this.currentPage,
    required this.totalPages,
    required this.isDark,
    required this.onBack,
  });

  final int currentPage;
  final int totalPages;
  final bool isDark;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final progress = currentPage == 0 ? 0.01 : currentPage / (totalPages - 1);
    final showBack = currentPage > 0 && currentPage < totalPages - 1;
    final barBg = isDark ? const Color(0xff2c2c2e) : const Color(0xffe5e5ea);
    final barFill = isDark ? const Color(0xff0a84ff) : const Color(0xff007aff);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            child: showBack
                ? GestureDetector(
                    onTap: onBack,
                    behavior: HitTestBehavior.opaque,
                    child: Icon(
                      CupertinoIcons.chevron_left,
                      color: isDark ? Colors.white : const Color(0xff111111),
                      size: 20,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 4,
                backgroundColor: barBg,
                valueColor: AlwaysStoppedAnimation<Color>(barFill),
              ),
            ),
          ),
          const SizedBox(width: 36),
        ],
      ),
    );
  }
}

// ─── Shared helpers ────────────────────────────────────────────────────────

String _flagCode(String currency) {
  if (currency == 'EUR') return 'eu';
  if (currency.length < 2) return '';
  return currency.substring(0, 2).toLowerCase();
}

class _PagePadding extends StatelessWidget {
  const _PagePadding({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      child: child,
    );
  }
}

class _PageTitle extends StatelessWidget {
  const _PageTitle(this.text, {required this.isDark, this.subtitle});
  final String text;
  final bool isDark;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final primary = isDark ? Colors.white : const Color(0xff111111);
    final secondary =
        isDark ? const Color(0xff98989f) : const Color(0xff6e6e73);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: TextStyle(
            color: primary,
            fontSize: 26,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
            height: 1.2,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(
            subtitle!,
            style: TextStyle(color: secondary, fontSize: 15, height: 1.4),
          ),
        ],
      ],
    );
  }
}

Widget _buildPrimaryButton({
  required String label,
  required VoidCallback? onPressed,
  required bool isDark,
}) {
  final color = isDark ? const Color(0xff0a84ff) : const Color(0xff007aff);
  return SizedBox(
    width: double.infinity,
    child: FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: color,
        disabledBackgroundColor: color.withValues(alpha: 0.35),
        foregroundColor: Colors.white,
        disabledForegroundColor: Colors.white.withValues(alpha: 0.5),
        minimumSize: const Size.fromHeight(54),
        textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Text(label),
    ),
  );
}

// ─── Screen 0: Welcome ─────────────────────────────────────────────────────

class _WelcomePage extends StatelessWidget {
  const _WelcomePage({required this.isDark, required this.onNext});
  final bool isDark;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final primary = isDark ? Colors.white : const Color(0xff111111);
    final secondary =
        isDark ? const Color(0xff98989f) : const Color(0xff6e6e73);
    final cardBg = isDark ? const Color(0xff1c1c1e) : Colors.white;
    final border = isDark ? const Color(0xff2c2c2e) : const Color(0xffe5e5ea);

    return _PagePadding(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          DecoratedBox(
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: border),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: const Color(0xff007aff).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      CupertinoIcons.arrow_2_circlepath_circle_fill,
                      color: Color(0xff007aff),
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Currency Converter',
                          style: TextStyle(
                            color: primary,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Live rates · Multi-currency · Charts',
                          style: TextStyle(color: secondary, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 28),
          Text(
            'Know exactly what\neverything costs,\nwherever you go.',
            style: TextStyle(
              color: primary,
              fontSize: 34,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.8,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Stop doing mental math. See every currency you care about — instantly.',
            style: TextStyle(color: secondary, fontSize: 16, height: 1.4),
          ),
          const Spacer(),
          _buildPrimaryButton(
            label: 'Get Started',
            onPressed: onNext,
            isDark: isDark,
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              'Takes about 1 minute to set up',
              style: TextStyle(color: secondary, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Screen 1: Goal ────────────────────────────────────────────────────────

class _GoalPage extends StatelessWidget {
  const _GoalPage({
    required this.isDark,
    required this.goals,
    required this.selected,
    required this.onSelect,
    required this.onNext,
  });

  final bool isDark;
  final List<_Goal> goals;
  final String? selected;
  final ValueChanged<String> onSelect;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return _PagePadding(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PageTitle(
            'What best describes you?',
            isDark: isDark,
            subtitle: "We'll set things up to match how you use it.",
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.separated(
              itemCount: goals.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final goal = goals[i];
                final isSelected = selected == goal.title;
                return _GoalOption(
                  goal: goal,
                  isSelected: isSelected,
                  isDark: isDark,
                  onTap: () {
                    onSelect(goal.title);
                    Future.delayed(const Duration(milliseconds: 180), onNext);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _GoalOption extends StatelessWidget {
  const _GoalOption({
    required this.goal,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  final _Goal goal;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primary = isDark ? Colors.white : const Color(0xff111111);
    final secondary =
        isDark ? const Color(0xff98989f) : const Color(0xff6e6e73);
    final cardBg = isDark ? const Color(0xff1c1c1e) : Colors.white;
    final accent =
        isDark ? const Color(0xff0a84ff) : const Color(0xff007aff);
    final selectedBg = accent.withValues(alpha: 0.08);
    final border = isSelected
        ? accent
        : (isDark ? const Color(0xff2c2c2e) : const Color(0xffe5e5ea));

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? selectedBg : cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border, width: isSelected ? 1.5 : 1),
        ),
        child: Row(
          children: [
            Text(goal.emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    goal.title,
                    style: TextStyle(
                      color: isSelected ? accent : primary,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    goal.subtitle,
                    style: TextStyle(color: secondary, fontSize: 13),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                CupertinoIcons.checkmark_circle_fill,
                color: accent,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}

// ─── Screen 2: Pain Points ─────────────────────────────────────────────────

class _PainPage extends StatelessWidget {
  const _PainPage({
    required this.isDark,
    required this.pains,
    required this.selected,
    required this.onToggle,
    required this.onNext,
  });

  final bool isDark;
  final List<(String, String)> pains;
  final Set<int> selected;
  final ValueChanged<int> onToggle;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final cardBg = isDark ? const Color(0xff1c1c1e) : Colors.white;
    final border = isDark ? const Color(0xff2c2c2e) : const Color(0xffe5e5ea);

    return _PagePadding(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PageTitle(
            'What makes currency conversion annoying?',
            isDark: isDark,
            subtitle: 'Pick everything that applies.',
          ),
          const SizedBox(height: 20),
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: border),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: pains.length,
                  separatorBuilder: (_, __) => Divider(
                    height: 1,
                    color: border,
                    indent: 16,
                    endIndent: 16,
                  ),
                  itemBuilder: (context, i) {
                    final (emoji, label) = pains[i];
                    return _PainRow(
                      emoji: emoji,
                      label: label,
                      isSelected: selected.contains(i),
                      isDark: isDark,
                      onTap: () => onToggle(i),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildPrimaryButton(
            label: 'Continue',
            onPressed: onNext,
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}

class _PainRow extends StatelessWidget {
  const _PainRow({
    required this.emoji,
    required this.label,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  final String emoji;
  final String label;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primary = isDark ? Colors.white : const Color(0xff111111);
    final accent = isDark ? const Color(0xff0a84ff) : const Color(0xff007aff);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: primary,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: isSelected ? accent : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: isSelected
                      ? accent
                      : (isDark
                          ? const Color(0xff48484a)
                          : const Color(0xffc7c7cc)),
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 14)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Screen 3: Social Proof ────────────────────────────────────────────────

class _SocialProofPage extends StatelessWidget {
  const _SocialProofPage({
    required this.isDark,
    required this.testimonials,
    required this.onNext,
  });

  final bool isDark;
  final List<_Testimonial> testimonials;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return _PagePadding(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PageTitle(
            'Travelers and expats love it',
            isDark: isDark,
            subtitle: 'See what people are saying.',
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.separated(
              itemCount: testimonials.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) => _TestimonialCard(
                t: testimonials[i],
                isDark: isDark,
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildPrimaryButton(
            label: 'Continue',
            onPressed: onNext,
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}

class _TestimonialCard extends StatelessWidget {
  const _TestimonialCard({required this.t, required this.isDark});
  final _Testimonial t;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final cardBg = isDark ? const Color(0xff1c1c1e) : Colors.white;
    final border = isDark ? const Color(0xff2c2c2e) : const Color(0xffe5e5ea);
    final primary = isDark ? Colors.white : const Color(0xff111111);
    final secondary =
        isDark ? const Color(0xff98989f) : const Color(0xff6e6e73);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: List.generate(
                5,
                (_) => const Icon(
                  CupertinoIcons.star_fill,
                  color: Color(0xFFFF9500),
                  size: 13,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '"${t.quote}"',
              style: TextStyle(color: primary, fontSize: 14, height: 1.4),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor:
                      const Color(0xff007aff).withValues(alpha: 0.12),
                  child: Text(t.emoji, style: const TextStyle(fontSize: 13)),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.name,
                      style: TextStyle(
                        color: primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      t.tag,
                      style: TextStyle(color: secondary, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Screen 4: Personalised Solution ──────────────────────────────────────

class _SolutionPage extends StatelessWidget {
  const _SolutionPage({required this.isDark, required this.onNext});
  final bool isDark;
  final VoidCallback onNext;

  static const _rows = [
    (
      CupertinoIcons.number_circle_fill,
      Color(0xfff24882),
      'Mental math at shops',
      'Type once, see every currency instantly',
    ),
    (
      CupertinoIcons.square_stack_3d_up_fill,
      Color(0xffff6b00),
      'Checking one currency at a time',
      'Track up to 30 currencies simultaneously',
    ),
    (
      CupertinoIcons.chart_bar_alt_fill,
      Color(0xff3478f6),
      'No idea if the rate is good today',
      '10 years of history so you know when to exchange',
    ),
    (
      CupertinoIcons.gear_alt_fill,
      Color(0xff34c759),
      'Re-entering settings every time',
      'Your preferences are saved permanently',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final cardBg = isDark ? const Color(0xff1c1c1e) : Colors.white;
    final border = isDark ? const Color(0xff2c2c2e) : const Color(0xffe5e5ea);

    return _PagePadding(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PageTitle("Here's how it fixes that", isDark: isDark),
          const SizedBox(height: 20),
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: border),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: _rows
                      .map(
                        (r) => Expanded(
                          child: _SolutionRow(
                            icon: r.$1,
                            iconColor: r.$2,
                            pain: r.$3,
                            solution: r.$4,
                            isDark: isDark,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildPrimaryButton(
            label: 'That sounds right →',
            onPressed: onNext,
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}

class _SolutionRow extends StatelessWidget {
  const _SolutionRow({
    required this.icon,
    required this.iconColor,
    required this.pain,
    required this.solution,
    required this.isDark,
  });

  final IconData icon;
  final Color iconColor;
  final String pain;
  final String solution;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final primary = isDark ? Colors.white : const Color(0xff111111);
    final secondary =
        isDark ? const Color(0xff98989f) : const Color(0xff6e6e73);

    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                pain,
                style: TextStyle(color: secondary, fontSize: 12),
              ),
              Text(
                solution,
                style: TextStyle(
                  color: primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Screen 5: Base Currency ───────────────────────────────────────────────

class _BaseCurrencyPage extends StatefulWidget {
  const _BaseCurrencyPage({
    required this.isDark,
    required this.currencies,
    required this.selected,
    required this.onSelect,
    required this.onNext,
  });

  final bool isDark;
  final List<String> currencies;
  final String selected;
  final ValueChanged<String> onSelect;
  final VoidCallback onNext;

  @override
  State<_BaseCurrencyPage> createState() => _BaseCurrencyPageState();
}

class _BaseCurrencyPageState extends State<_BaseCurrencyPage> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final filtered = widget.currencies
        .where((c) => c.toLowerCase().contains(_search.toLowerCase()))
        .toList();
    final primary = widget.isDark ? Colors.white : const Color(0xff111111);
    final secondary = widget.isDark
        ? const Color(0xff98989f)
        : const Color(0xff6e6e73);
    final cardBg = widget.isDark ? const Color(0xff1c1c1e) : Colors.white;
    final border = widget.isDark
        ? const Color(0xff2c2c2e)
        : const Color(0xffe5e5ea);
    final accent = widget.isDark
        ? const Color(0xff0a84ff)
        : const Color(0xff007aff);

    return _PagePadding(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PageTitle(
            "What's your home currency?",
            isDark: widget.isDark,
            subtitle: "This is what you'll convert from.",
          ),
          const SizedBox(height: 16),
          DecoratedBox(
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: border),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Icon(CupertinoIcons.search, color: secondary, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      onChanged: (v) => setState(() => _search = v),
                      style: TextStyle(color: primary, fontSize: 15),
                      decoration: InputDecoration(
                        hintText: 'Search currency',
                        hintStyle: TextStyle(color: secondary),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: border),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => Divider(
                    height: 1,
                    color: border,
                    indent: 16,
                    endIndent: 16,
                  ),
                  itemBuilder: (context, i) {
                    final code = filtered[i];
                    final isSelected = code == widget.selected;
                    return GestureDetector(
                      onTap: () {
                        widget.onSelect(code);
                        Future.delayed(
                          const Duration(milliseconds: 150),
                          widget.onNext,
                        );
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            CurrencyFlag(code: _flagCode(code)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                code,
                                style: TextStyle(
                                  color: isSelected ? accent : primary,
                                  fontSize: 15,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                ),
                              ),
                            ),
                            if (isSelected)
                              Icon(
                                CupertinoIcons.checkmark,
                                color: accent,
                                size: 16,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Screen 6: Display Currencies ─────────────────────────────────────────

class _DisplayCurrenciesPage extends StatefulWidget {
  const _DisplayCurrenciesPage({
    required this.isDark,
    required this.currencies,
    required this.base,
    required this.selected,
    required this.onToggle,
    required this.onNext,
  });

  final bool isDark;
  final List<String> currencies;
  final String base;
  final Set<String> selected;
  final ValueChanged<String> onToggle;
  final VoidCallback onNext;

  @override
  State<_DisplayCurrenciesPage> createState() =>
      _DisplayCurrenciesPageState();
}

class _DisplayCurrenciesPageState extends State<_DisplayCurrenciesPage> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final others =
        widget.currencies.where((c) => c != widget.base).toList();
    final filtered = others
        .where((c) => c.toLowerCase().contains(_search.toLowerCase()))
        .toList();
    final primary = widget.isDark ? Colors.white : const Color(0xff111111);
    final secondary = widget.isDark
        ? const Color(0xff98989f)
        : const Color(0xff6e6e73);
    final cardBg = widget.isDark ? const Color(0xff1c1c1e) : Colors.white;
    final border = widget.isDark
        ? const Color(0xff2c2c2e)
        : const Color(0xffe5e5ea);
    final accent = widget.isDark
        ? const Color(0xff0a84ff)
        : const Color(0xff007aff);
    final selectedCount = widget.selected.length;

    return _PagePadding(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PageTitle(
            'Which currencies do you want to track?',
            isDark: widget.isDark,
            subtitle:
                'Add the ones you care about most. You can change this later.',
          ),
          const SizedBox(height: 16),
          DecoratedBox(
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: border),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Icon(CupertinoIcons.search, color: secondary, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      onChanged: (v) => setState(() => _search = v),
                      style: TextStyle(color: primary, fontSize: 15),
                      decoration: InputDecoration(
                        hintText: 'Search currencies',
                        hintStyle: TextStyle(color: secondary),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: border),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => Divider(
                    height: 1,
                    color: border,
                    indent: 16,
                    endIndent: 16,
                  ),
                  itemBuilder: (context, i) {
                    final code = filtered[i];
                    final isSelected = widget.selected.contains(code);
                    return GestureDetector(
                      onTap: () => widget.onToggle(code),
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            CurrencyFlag(code: _flagCode(code)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                code,
                                style: TextStyle(
                                  color: primary,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                color:
                                    isSelected ? accent : Colors.transparent,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: isSelected
                                      ? accent
                                      : (widget.isDark
                                          ? const Color(0xff48484a)
                                          : const Color(0xffc7c7cc)),
                                  width: 1.5,
                                ),
                              ),
                              child: isSelected
                                  ? const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 14,
                                    )
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildPrimaryButton(
            label: selectedCount == 0
                ? 'Done'
                : 'Done  ($selectedCount selected)',
            onPressed: widget.onNext,
            isDark: widget.isDark,
          ),
        ],
      ),
    );
  }
}

// ─── Screen 7: Processing ──────────────────────────────────────────────────

class _ProcessingPage extends StatelessWidget {
  const _ProcessingPage({
    required this.isDark,
    required this.pulseController,
  });

  final bool isDark;
  final AnimationController pulseController;

  @override
  Widget build(BuildContext context) {
    final primary = isDark ? Colors.white : const Color(0xff111111);
    final secondary =
        isDark ? const Color(0xff98989f) : const Color(0xff6e6e73);
    final accent = isDark ? const Color(0xff0a84ff) : const Color(0xff007aff);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: pulseController,
              builder: (context, _) {
                final scale = 0.85 + pulseController.value * 0.3;
                final opacity = 0.5 + pulseController.value * 0.5;
                return Transform.scale(
                  scale: scale,
                  child: Opacity(
                    opacity: opacity,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        CupertinoIcons.arrow_2_circlepath_circle_fill,
                        color: accent,
                        size: 40,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 28),
            Text(
              'Building your exchange\ndashboard…',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: primary,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.4,
                height: 1.25,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Setting up your currencies',
              style: TextStyle(color: secondary, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
