import 'package:encrypt/encrypt.dart';
import 'package:journal_app/api/api.dart';
import 'package:journal_app/helpers/flutter_persistor.dart';
import 'package:journal_app/protobufs/journal.pbserver.dart';

const String ENCRYPTION_KEY = "ENCRYPTION_KEY";
const String SAVE_TYPE = "SAVE_TYPE";

Journal_JournalSaveType getSaveType() {
  try {
    final saveType = FlutterPersistor.getInstance().loadString(SAVE_TYPE);
    return Journal_JournalSaveType.valueOf(int.parse(saveType));
  } catch (Exception) {
    return Journal_JournalSaveType.PLAINTEXT;
  }
}

Encrypter getEncryptor() {
  final encryptionKey =
      FlutterPersistor.getInstance().loadString(ENCRYPTION_KEY);
  var modifiedKey = encryptionKey;
  if (encryptionKey.length < 32) {
    for (var i = encryptionKey.length; i < 32; i += 1) {
      modifiedKey += ".";
    }
  }
  final key = Key.fromUtf8(modifiedKey);
  final encrypter = Encrypter(AES(key, mode: AESMode.ecb));
  return encrypter;
}

encryptJournals() async {
  final _instance = HttpApi.getInstance();
  final journalResponse = await _instance.getJournal();
  journalResponse.journals.forEach((journal) {
    if (journal.saveType != Journal_JournalSaveType.ENCRYPTED) {
      final encrypted = getEncryptor().encrypt(journal.content);
      _instance.saveJournal(
        journal.id,
        encrypted.base64,
        saveType: Journal_JournalSaveType.ENCRYPTED,
      );
    }
  });
}

decryptJournals() async {
  final _instance = HttpApi.getInstance();
  final journalResponse = await _instance.getJournal();
  journalResponse.journals.forEach((journal) {
    if (journal.saveType == Journal_JournalSaveType.ENCRYPTED) {
      final encrypted = Encrypted.fromBase64(journal.content);
      final decrypted = getEncryptor().decrypt(encrypted);
      _instance.saveJournal(
        journal.id,
        decrypted,
        saveType: Journal_JournalSaveType.PLAINTEXT,
      );
    }
  });
}
