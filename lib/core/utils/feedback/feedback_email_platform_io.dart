import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

bool get supportsNativeEmailComposer => Platform.isAndroid || Platform.isIOS;

Future<String> writeScreenshotToTempFile(Uint8List bytes) async {
  final tempDirectory = await getTemporaryDirectory();
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final file = File('${tempDirectory.path}/feedback-$timestamp.png');
  await file.writeAsBytes(bytes, flush: true);
  return file.path;
}
