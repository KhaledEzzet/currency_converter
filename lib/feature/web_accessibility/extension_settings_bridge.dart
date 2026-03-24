const extensionSettingsStorageKey = 'currencyConverterExtensionSettings';

class ExtensionSettingsPayload {
  const ExtensionSettingsPayload({
    required this.baseCurrency,
    required this.webPriceAccessibilityEnabled,
  });

  final String baseCurrency;
  final bool webPriceAccessibilityEnabled;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'baseCurrency': baseCurrency,
      'webPriceAccessibilityEnabled': webPriceAccessibilityEnabled,
    };
  }
}

typedef ExtensionStorageWrite = Future<void> Function({
  required String key,
  required Map<String, dynamic> value,
});

abstract interface class ExtensionSettingsBridge {
  bool get isExtensionContext;

  Future<void> syncSettings(ExtensionSettingsPayload payload);
}

class BrowserExtensionSettingsBridge implements ExtensionSettingsBridge {
  const BrowserExtensionSettingsBridge({
    required this.isExtensionContext,
    required ExtensionStorageWrite storageWriter,
  }) : _storageWriter = storageWriter;

  @override
  final bool isExtensionContext;

  final ExtensionStorageWrite _storageWriter;

  @override
  Future<void> syncSettings(ExtensionSettingsPayload payload) async {
    if (!isExtensionContext) {
      return;
    }

    await _storageWriter(
      key: extensionSettingsStorageKey,
      value: payload.toJson(),
    );
  }
}

Future<void> noopExtensionStorageWrite({
  required String key,
  required Map<String, dynamic> value,
}) async {}
