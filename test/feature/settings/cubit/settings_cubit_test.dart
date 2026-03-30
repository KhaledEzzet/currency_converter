import 'package:currency_converter/feature/convert/domain/entities/latest_rates.dart';
import 'package:currency_converter/feature/convert/domain/repositories/convert_repository.dart';
import 'package:currency_converter/feature/convert/domain/usecases/get_currencies_usecase.dart';
import 'package:currency_converter/feature/settings/cubit/settings_cubit.dart';
import 'package:currency_converter/feature/web_accessibility/extension_settings_bridge.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class _FakeConvertRepository implements ConvertRepository {
  const _FakeConvertRepository();

  @override
  Future<Map<String, String>> fetchCurrencies() async => const {
        'EUR': 'Euro',
        'USD': 'United States Dollar',
      };

  @override
  Future<LatestRates> fetchLatestRates({
    required String from,
    required List<String> to,
    double amount = 1,
  }) {
    throw UnimplementedError();
  }
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

class _FakeExtensionSettingsBridge implements ExtensionSettingsBridge {
  @override
  bool get isExtensionContext => true;

  final List<ExtensionSettingsPayload> syncedPayloads =
      <ExtensionSettingsPayload>[];

  @override
  Future<void> syncSettings(ExtensionSettingsPayload payload) async {
    syncedPayloads.add(payload);
  }
}

void main() {
  late _TestStorage storage;
  late SettingsCubit cubit;
  late _FakeExtensionSettingsBridge extensionSettingsBridge;

  setUp(() {
    storage = _TestStorage();
    HydratedBloc.storage = storage;
    extensionSettingsBridge = _FakeExtensionSettingsBridge();
    cubit = SettingsCubit(
      getCurrenciesUseCase: const GetCurrenciesUseCase(
        repository: _FakeConvertRepository(),
      ),
      extensionSettingsBridge: extensionSettingsBridge,
    );
  });

  tearDown(() async {
    await cubit.close();
  });

  test('starts with convert showcase unseen', () {
    expect(cubit.state.convertShowcaseSeen, isFalse);
    expect(cubit.state.chartsShowcaseSeen, isFalse);
    expect(cubit.state.settingsShowcaseSeen, isFalse);
  });

  test('starts with webpage price accessibility enabled', () {
    expect(cubit.state.webPriceAccessibilityEnabled, isTrue);
  });

  test('marks the convert showcase as seen and persists it', () async {
    cubit.markConvertShowcaseSeen();
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state.convertShowcaseSeen, isTrue);
    expect(storage.values, hasLength(1));
    expect(
      Map<String, dynamic>.from(storage.values.values.single as Map),
      allOf(
        containsPair('convertShowcaseSeen', true),
        containsPair('convertShowcaseSeenVersion', 2),
      ),
    );
  });

  test('defaults convert showcase flag to false when restoring old state', () {
    final restoredState = cubit.fromJson(const <String, dynamic>{});

    expect(restoredState?.convertShowcaseSeen, isFalse);
  });

  test('ignores saved showcase flags from the previous storage version', () {
    final restoredState = cubit.fromJson(
      const <String, dynamic>{
        'convertShowcaseSeen': true,
      },
    );

    expect(restoredState?.convertShowcaseSeen, isFalse);
  });

  test('restores the showcase flag for the current storage version', () {
    final restoredState = cubit.fromJson(
      const <String, dynamic>{
        'convertShowcaseSeen': true,
        'convertShowcaseSeenVersion': 2,
      },
    );

    expect(restoredState?.convertShowcaseSeen, isTrue);
  });

  test('persists the webpage price accessibility setting', () async {
    cubit.updateWebPriceAccessibility(value: false);
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state.webPriceAccessibilityEnabled, isFalse);
    expect(storage.values, hasLength(1));
    expect(
      Map<String, dynamic>.from(storage.values.values.single as Map),
      containsPair('webPriceAccessibilityEnabled', false),
    );
    expect(extensionSettingsBridge.syncedPayloads, isNotEmpty);
    expect(
      extensionSettingsBridge.syncedPayloads.last.webPriceAccessibilityEnabled,
      isFalse,
    );
  });

  test('restores webpage price accessibility from saved state', () {
    final restoredState = cubit.fromJson(
      const <String, dynamic>{
        'webPriceAccessibilityEnabled': true,
      },
    );

    expect(restoredState?.webPriceAccessibilityEnabled, isTrue);
  });

  test(
    'defaults webpage price accessibility to true when restoring old state',
    () {
      final restoredState = cubit.fromJson(const <String, dynamic>{});

      expect(restoredState?.webPriceAccessibilityEnabled, isTrue);
    },
  );

  test('restores disabled webpage price accessibility from saved state', () {
    final restoredState = cubit.fromJson(
      const <String, dynamic>{
        'webPriceAccessibilityEnabled': false,
      },
    );

    expect(restoredState?.webPriceAccessibilityEnabled, isFalse);
  });

  test('marks the charts showcase as seen and persists it', () async {
    cubit.markChartsShowcaseSeen();
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state.chartsShowcaseSeen, isTrue);
    expect(storage.values, hasLength(1));
    expect(
      Map<String, dynamic>.from(storage.values.values.single as Map),
      containsPair('chartsShowcaseSeen', true),
    );
  });

  test('marks the settings showcase as seen and persists it', () async {
    cubit.markSettingsShowcaseSeen();
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state.settingsShowcaseSeen, isTrue);
    expect(storage.values, hasLength(1));
    expect(
      Map<String, dynamic>.from(storage.values.values.single as Map),
      containsPair('settingsShowcaseSeen', true),
    );
  });
}
