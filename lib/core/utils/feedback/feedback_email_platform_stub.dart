import 'dart:typed_data';

bool get supportsNativeEmailComposer => false;

Future<String> writeScreenshotToTempFile(Uint8List bytes) {
  throw UnsupportedError(
    'Native email attachments are not supported on this platform.',
  );
}
