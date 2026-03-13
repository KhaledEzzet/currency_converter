import 'package:web/web.dart' as web;

Future<bool> openUrlInNewTabImpl(String url) async {
  final newWindow = web.window.open(url, '_blank', 'noopener,noreferrer');
  return newWindow != null;
}
