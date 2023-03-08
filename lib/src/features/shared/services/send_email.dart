import 'package:flutter_email_sender/flutter_email_sender.dart';

Future sendEmail(String name, String email, String message) async {
  final Email email = Email(
    body: 'Email body',
    subject: 'Email subject',
    recipients: ['example@example.com'],
    cc: ['cc@example.com'],
    bcc: ['bcc@example.com'],
    attachmentPaths: ['/path/to/attachment.zip'],
    isHTML: false,
  );

  await FlutterEmailSender.send(email);
}
