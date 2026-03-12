import 'package:currency_converter/feature/onboarding/cubit/onboarding_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

void main() {
  late _TestStorage storage;

  setUp(() {
    storage = _TestStorage();
    HydratedBloc.storage = storage;
  });

  test('starts with onboarding visible when no saved state exists', () async {
    final cubit = OnboardingCubit();

    expect(cubit.state.hasCompletedOnboarding, isFalse);

    await cubit.close();
  });

  test('marks onboarding as completed and persists the state', () async {
    final cubit = OnboardingCubit()..completeOnboarding();
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state.hasCompletedOnboarding, isTrue);
    expect(storage.values, hasLength(1));
    expect(
      Map<String, dynamic>.from(storage.values.values.single as Map),
      <String, dynamic>{'hasCompletedOnboarding': true},
    );

    await cubit.close();
  });
}

class _TestStorage implements Storage {
  final Map<String, dynamic> values = <String, dynamic>{};

  @override
  dynamic read(String key) => values[key];

  @override
  Future<void> write(String key, dynamic value) async {
    values[key] = value;
  }

  @override
  Future<void> delete(String key) async {
    values.remove(key);
  }

  @override
  Future<void> clear() async {
    values.clear();
  }

  @override
  Future<void> close() async {}
}
