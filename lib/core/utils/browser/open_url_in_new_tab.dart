import 'package:currency_converter/core/utils/browser/open_url_in_new_tab_stub.dart'
    if (dart.library.html) 'package:currency_converter/core/utils/browser/open_url_in_new_tab_web.dart';

Future<bool> openUrlInNewTab(String url) => openUrlInNewTabImpl(url);
