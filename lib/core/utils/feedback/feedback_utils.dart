import 'package:currency_converter/app/constants/string_constants.dart';
import 'package:currency_converter/core/utils/device_info/device_info_utils.dart';
import 'package:currency_converter/core/utils/feedback/feedback_email_platform_stub.dart'
    if (dart.library.io) 'package:currency_converter/core/utils/feedback/feedback_email_platform_io.dart';
import 'package:currency_converter/core/utils/package_info/package_info_utils.dart';
import 'package:feedback/feedback.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:url_launcher/url_launcher.dart';

final class FeedbackUtils {
  FeedbackUtils._();

  static Future<bool> composeFeedbackEmail({
    required UserFeedback feedback,
    String? localeTag,
  }) async {
    final subject = '${PackageInfoUtils.getAppName()} Feedback';
    final body = await _buildEmailBody(
      feedback: feedback,
      localeTag: localeTag,
    );

    if (supportsNativeEmailComposer) {
      final attachmentPath = await writeScreenshotToTempFile(
        feedback.screenshot,
      );
      final email = Email(
        subject: subject,
        recipients: const [StringConstants.feedbackEmail],
        body: body,
        attachmentPaths: [attachmentPath],
      );

      await FlutterEmailSender.send(email);
      return true;
    }

    return launchUrl(_buildMailtoUri(subject: subject, body: body));
  }

  static Uri _buildMailtoUri({
    required String subject,
    required String body,
  }) {
    final encodedSubject = Uri.encodeComponent(subject);
    final encodedBody = Uri.encodeComponent(body);
    return Uri.parse(
      'mailto:${StringConstants.feedbackEmail}'
      '?subject=$encodedSubject'
      '&body=$encodedBody',
    );
  }

  static Future<String> _buildEmailBody({
    required UserFeedback feedback,
    String? localeTag,
  }) async {
    final writtenFeedback = feedback.text.trim();
    final deviceInfo = await DeviceInfoUtils.getDeviceInfo();
    final buffer = StringBuffer()
      ..writeln(
        writtenFeedback.isEmpty
            ? 'No written feedback provided.'
            : writtenFeedback,
      )
      ..writeln()
      ..writeln('---')
      ..writeln('App: ${PackageInfoUtils.getAppName()}')
      ..writeln('Version: ${PackageInfoUtils.getAppVersion()}')
      ..writeln('Platform: ${DeviceInfoUtils.getPlatformName()}');

    if (deviceInfo != null && deviceInfo.isNotEmpty) {
      buffer.writeln('Device: $deviceInfo');
    }

    if (localeTag != null && localeTag.isNotEmpty) {
      buffer.writeln('Locale: $localeTag');
    }

    if (feedback.extra case final extra? when extra.isNotEmpty) {
      buffer.writeln('Extra: $extra');
    }

    if (!supportsNativeEmailComposer) {
      buffer
        ..writeln()
        ..writeln(
          'Screenshot attachment is only included when the native email '
          'composer is available on this platform.',
        );
    }

    return buffer.toString().trimRight();
  }
}
