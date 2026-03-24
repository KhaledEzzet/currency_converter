import 'package:currency_converter/feature/web_accessibility/extension_settings_bridge.dart';

ExtensionSettingsBridge createExtensionSettingsBridgeImpl() {
  return const BrowserExtensionSettingsBridge(
    isExtensionContext: false,
    storageWriter: noopExtensionStorageWrite,
  );
}
