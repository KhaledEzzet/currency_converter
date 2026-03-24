import 'package:currency_converter/feature/web_accessibility/extension_settings_bridge.dart';
import 'package:currency_converter/feature/web_accessibility/extension_settings_bridge_stub.dart'
    if (dart.library.html) 'package:currency_converter/feature/web_accessibility/extension_settings_bridge_web.dart';

ExtensionSettingsBridge createExtensionSettingsBridge() {
  return createExtensionSettingsBridgeImpl();
}
