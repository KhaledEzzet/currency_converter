// ignore_for_file: avoid_web_libraries_in_flutter, cascade_invocations

import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:currency_converter/feature/web_accessibility/extension_settings_bridge.dart';
import 'package:web/web.dart' as web;

@JS('window')
external JSObject get _window;

ExtensionSettingsBridge createExtensionSettingsBridgeImpl() {
  return BrowserExtensionSettingsBridge(
    isExtensionContext: _isChromeExtensionContext(),
    storageWriter: _writeExtensionSettings,
  );
}

bool _isChromeExtensionContext() {
  if (web.window.location.protocol != 'chrome-extension:') {
    return false;
  }

  if (!_window.has('chrome')) {
    return false;
  }

  final chrome = _window.getProperty<JSObject>('chrome'.toJS);
  return chrome.has('runtime');
}

Future<void> _writeExtensionSettings({
  required String key,
  required Map<String, dynamic> value,
}) async {
  if (!_window.has('chrome')) {
    return;
  }

  final chrome = _window.getProperty<JSObject>('chrome'.toJS);
  if (!chrome.has('storage')) {
    return;
  }

  final storage = chrome.getProperty<JSObject>('storage'.toJS);
  if (!storage.has('local')) {
    return;
  }

  final localStorage = storage.getProperty<JSObject>('local'.toJS);
  localStorage.callMethodVarArgs<JSAny?>(
    'set'.toJS,
    [
      <String, Object?>{key: value}.jsify(),
    ],
  );
}
