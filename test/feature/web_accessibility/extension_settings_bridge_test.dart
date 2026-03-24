import 'package:currency_converter/feature/web_accessibility/extension_settings_bridge.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('syncs base currency and toggle into extension storage', () async {
    String? lastKey;
    Map<String, dynamic>? lastValue;
    final bridge = BrowserExtensionSettingsBridge(
      isExtensionContext: true,
      storageWriter: ({
        required String key,
        required Map<String, dynamic> value,
      }) async {
        lastKey = key;
        lastValue = value;
      },
    );

    await bridge.syncSettings(
      const ExtensionSettingsPayload(
        baseCurrency: 'EUR',
        webPriceAccessibilityEnabled: true,
      ),
    );

    expect(lastKey, extensionSettingsStorageKey);
    expect(
      lastValue,
      equals(
        const <String, dynamic>{
          'baseCurrency': 'EUR',
          'webPriceAccessibilityEnabled': true,
        },
      ),
    );
  });

  test('skips syncing outside the extension context', () async {
    String? lastKey;
    Map<String, dynamic>? lastValue;
    final bridge = BrowserExtensionSettingsBridge(
      isExtensionContext: false,
      storageWriter: ({
        required String key,
        required Map<String, dynamic> value,
      }) async {
        lastKey = key;
        lastValue = value;
      },
    );

    await bridge.syncSettings(
      const ExtensionSettingsPayload(
        baseCurrency: 'USD',
        webPriceAccessibilityEnabled: true,
      ),
    );

    expect(lastKey, isNull);
    expect(lastValue, isNull);
  });
}
