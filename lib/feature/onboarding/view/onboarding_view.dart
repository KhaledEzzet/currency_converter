import 'package:currency_converter/app/l10n/l10n.dart';
import 'package:currency_converter/feature/onboarding/cubit/onboarding_cubit.dart';
import 'package:currency_converter/feature/onboarding/cubit/onboarding_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  static const _lightBackground = Color(0xfff5f5f7);
  static const _darkBackground = Color(0xff000000);
  static const _lightCard = Colors.white;
  static const _darkCard = Color(0xff1c1c1e);
  static const _lightSecondaryText = Color(0xff6e6e73);
  static const _darkSecondaryText = Color(0xff98989f);
  static const _lightBorder = Color(0xffe5e5ea);
  static const _darkBorder = Color(0xff2c2c2e);
  static const _lightPrimaryText = Color(0xff111111);
  static const _darkPrimaryText = Colors.white;
  static const _lightButton = Color(0xff007aff);
  static const _darkButton = Color(0xff0a84ff);

  List<_OnboardingFeature> _features(BuildContext context) {
    final l10n = context.l10n;
    return <_OnboardingFeature>[
      _OnboardingFeature(
        icon: CupertinoIcons.arrow_2_circlepath_circle_fill,
        iconColor: const Color(0xfff24882),
        title: l10n.onboardingFeatureRatesTitle,
        description: l10n.onboardingFeatureRatesBody,
      ),
      _OnboardingFeature(
        icon: CupertinoIcons.square_stack_3d_up_fill,
        iconColor: const Color(0xffff6b00),
        title: l10n.onboardingFeatureTrackingTitle,
        description: l10n.onboardingFeatureTrackingBody,
      ),
      _OnboardingFeature(
        icon: CupertinoIcons.chart_bar_alt_fill,
        iconColor: const Color(0xff3478f6),
        title: l10n.onboardingFeatureChartsTitle,
        description: l10n.onboardingFeatureChartsBody,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDarkMode = brightness == Brightness.dark;
    final features = _features(context);
    final primaryTextColor =
        isDarkMode ? _darkPrimaryText : _lightPrimaryText;
    final secondaryTextColor =
        isDarkMode ? _darkSecondaryText : _lightSecondaryText;
    final backgroundColor = isDarkMode ? _darkBackground : _lightBackground;
    final cardColor = isDarkMode ? _darkCard : _lightCard;
    final borderColor = isDarkMode ? _darkBorder : _lightBorder;
    final buttonColor = isDarkMode ? _darkButton : _lightButton;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          context.l10n.onboardingTitle,
                          style: TextStyle(
                            color: primaryTextColor,
                            fontSize: 34,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.8,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          context.l10n.onboardingSubtitle,
                          style: TextStyle(
                            color: secondaryTextColor,
                            fontSize: 16,
                            height: 1.35,
                          ),
                        ),
                        const SizedBox(height: 32),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(color: borderColor),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: features
                                  .map(
                                    (feature) => _OnboardingFeatureRow(
                                      feature: feature,
                                      isDarkMode: isDarkMode,
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 20,
                          ),
                          child: Text(
                            context.l10n.onboardingFooter,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: secondaryTextColor,
                              fontSize: 13,
                              height: 1.35,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: () {
                              context
                                  .read<OnboardingCubit>()
                                  .completeOnboarding();
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: buttonColor,
                              foregroundColor: Colors.white,
                              minimumSize: const Size.fromHeight(54),
                              textStyle: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              context.l10n.onboardingContinue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _OnboardingFeatureRow extends StatelessWidget {
  const _OnboardingFeatureRow({
    required this.feature,
    required this.isDarkMode,
  });

  final _OnboardingFeature feature;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    final primaryTextColor = isDarkMode
        ? OnboardingView._darkPrimaryText
        : OnboardingView._lightPrimaryText;
    final secondaryTextColor = isDarkMode
        ? OnboardingView._darkSecondaryText
        : OnboardingView._lightSecondaryText;
    final iconBackground = feature.iconColor.withValues(alpha: 0.14);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(14),
            ),
            child: SizedBox(
              width: 42,
              height: 42,
              child: Icon(
                feature.icon,
                color: feature.iconColor,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feature.title,
                  style: TextStyle(
                    color: primaryTextColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  feature.description,
                  style: TextStyle(
                    color: secondaryTextColor,
                    fontSize: 14,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingFeature {
  const _OnboardingFeature({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
}
