import 'package:encrypt/encrypt.dart';
import 'package:journal_app/api/api.dart';
import 'package:journal_app/helpers/flutter_persistor.dart';
import 'package:journal_app/protobufs/journal.pbserver.dart';

const String ENCRYPTION_KEY = "ENCRYPTION_KEY";
const String SAVE_TYPE = "SAVE_TYPE";

class EncryptionService {
  String _encryptionKey;
  Map<String, String> _cacheEncrypted = {};
  Map<String, String> _cacheDecrypted = {};

  static EncryptionService _instance;

  static EncryptionService getInstance() {
    if (_instance == null) {
      _instance = EncryptionService();
    }
    return _instance;
  }

  String get encryptionKey {
    if (_encryptionKey == null) {
      this._encryptionKey =
          FlutterPersistor.getInstance().loadString(ENCRYPTION_KEY);
    }
    return this._encryptionKey;
  }

  setEncryptionKey(String encryptionKey, bool shouldSave) {
    this._encryptionKey = encryptionKey;
    _cacheDecrypted = {};
    _cacheEncrypted = {};
    if (shouldSave) {
      FlutterPersistor.getInstance()
          .setString(ENCRYPTION_KEY, this._encryptionKey);
    }
  }

  Encrypter getEncryptor() {
    if (encryptionKey == null) {
      return null;
    }
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

  String encrypt(String decryptedText) {
    if (_cacheEncrypted.containsKey(decryptedText)) {
      return _cacheDecrypted[decryptedText];
    }
    final encryptedText = getEncryptor().encrypt(decryptedText).base64;
    _cacheDecrypted[decryptedText] = encryptedText;
    return encryptedText;
  }

  String decrypt(String encryptedText) {
    if (_cacheDecrypted.containsKey(encryptedText)) {
      return _cacheDecrypted[encryptedText];
    }
    final encryptedContent = Encrypted.fromBase64(encryptedText);
    final encryptor = getEncryptor();
    if (encryptor == null) {
      return "";
    }
    final decryptedText = encryptor.decrypt(encryptedContent);
    _cacheDecrypted[encryptedText] = decryptedText;
    return decryptedText;
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
}

Journal_JournalSaveType getSaveType() {
  try {
    final saveType = FlutterPersistor.getInstance().loadString(SAVE_TYPE);
    return Journal_JournalSaveType.valueOf(int.parse(saveType));
  } catch (Exception) {
    return Journal_JournalSaveType.PLAINTEXT;
  }
}
