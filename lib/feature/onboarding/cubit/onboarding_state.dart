class OnboardingState {
  const OnboardingState({
    required this.hasCompletedOnboarding,
  });

  factory OnboardingState.initial() {
    return const OnboardingState(
      hasCompletedOnboarding: false,
    );
  }

  final bool hasCompletedOnboarding;

  OnboardingState copyWith({
    bool? hasCompletedOnboarding,
  }) {
    return OnboardingState(
      hasCompletedOnboarding:
          hasCompletedOnboarding ?? this.hasCompletedOnboarding,
    );
  }
}
