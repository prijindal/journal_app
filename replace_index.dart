import 'dart:io';

import 'package:journal_app/helpers/constants.dart';

Future<void> main() async {
  final filePath = 'web/index.html'; // Replace with your file path

  try {
    final file = File(filePath);
    final contents = await file.readAsString();

    if (recaptchaSiteKey != null) {
      // Replace the text (adjust the pattern and replacement as needed)
      final newContents =
          contents.replaceAll('RECAPTCHA_SITE_KEY', recaptchaSiteKey!);

      // Write the modified content back to the file
      await file.writeAsString(newContents);
    }
  } catch (e) {
    rethrow;
  }
}
