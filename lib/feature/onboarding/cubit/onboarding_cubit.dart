import 'package:currency_converter/feature/onboarding/cubit/onboarding_state.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class OnboardingCubit extends HydratedCubit<OnboardingState> {
  OnboardingCubit() : super(OnboardingState.initial());

  void completeOnboarding() {
    if (state.hasCompletedOnboarding) {
      return;
    }
    emit(
      state.copyWith(hasCompletedOnboarding: true),
    );
  }

  @override
  OnboardingState? fromJson(Map<String, dynamic> json) {
    final rawHasCompletedOnboarding = json['hasCompletedOnboarding'];
    final hasCompletedOnboarding =
        rawHasCompletedOnboarding is bool && rawHasCompletedOnboarding;

    return OnboardingState.initial().copyWith(
      hasCompletedOnboarding: hasCompletedOnboarding,
    );
  }

  @override
  Map<String, dynamic>? toJson(OnboardingState state) {
    return <String, dynamic>{
      'hasCompletedOnboarding': state.hasCompletedOnboarding,
    };
  }
}
