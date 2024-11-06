import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'constants.dart';
import 'logger.dart';
import 'sync.dart';

void downloadContent(BuildContext context) async {
  // TODO: Better universal ways to download file, make sure it works on all platforms
  if (kIsWeb) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Not Supported"),
        ),
      );
    }
  } else {
    final encoded = await extractDbJson();
    String? downloadDirectory;
    if (Platform.isAndroid) {
      final params = SaveFileDialogParams(
        data: Uint8List.fromList(encoded.codeUnits),
        fileName: dbExportName,
      );
      final filePath = await FlutterFileDialog.saveFile(params: params);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Content saved at $filePath"),
          ),
        );
      }
    } else {
      final downloadFolder = await getDownloadsDirectory();
      if (downloadFolder != null) {
        downloadDirectory = downloadFolder.path;
      }
      if (downloadDirectory != null) {
        final path = p.join(downloadDirectory, dbExportName);
        final file = File(path);
        await file.writeAsString(encoded);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Content saved at $path"),
            ),
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Can't find download directory"),
            ),
          );
        }
      }
    }
  }
}

void uploadContent(BuildContext context) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles();
  if (result != null) {
    String? jsonEncoded;
    if (result.files.single.bytes != null) {
      jsonEncoded = utf8.decode(result.files.single.bytes!);
    } else if (result.files.single.path != null) {
      jsonEncoded = await File(result.files.single.path!).readAsString();
    }
    if (jsonEncoded != null) {
      try {
        await jsonToDb(jsonEncoded);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Successfully imported"),
            ),
          );
        }
      } catch (e, stack) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                parseErrorToString(e, stack, "Error while syncing"),
              ),
            ),
          );
        }
      }
    }
  } else {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Cancelled file upload"),
        ),
      );
    }
  }
}
