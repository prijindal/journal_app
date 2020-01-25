import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:journal_app/api/api.dart';
import 'package:journal_app/helpers/flutter_persistor.dart';
import 'package:journal_app/protobufs/journal.pb.dart';

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
    if (this._encryptionKey == null || this._encryptionKey.isEmpty) {
      return null;
    }
    return this._encryptionKey;
  }

  setEncryptionKey(String encryptionKey, bool shouldSave) {
    this._encryptionKey = md5.convert(utf8.encode(encryptionKey)).toString();
    _cacheDecrypted = {};
    _cacheEncrypted = {};
    if (shouldSave) {
      FlutterPersistor.getInstance()
          .setString(ENCRYPTION_KEY, this._encryptionKey);
    }
  }

  deleteEncryptionKey() {
    this._encryptionKey = null;
    FlutterPersistor.getInstance().clearString(ENCRYPTION_KEY);
  }

  Encrypter getEncryptor() {
    if (encryptionKey == null) {
      return null;
    }
    final key = Key.fromUtf8(encryptionKey);
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    return encrypter;
  }

  String encrypt(String decryptedText) {
    if (_cacheEncrypted.containsKey(decryptedText)) {
      return _cacheDecrypted[decryptedText];
    }
    final iv = IV.fromLength(16);
    final encryptedText = getEncryptor().encrypt(decryptedText, iv: iv).base64;
    final transitmessage = iv.base64 + encryptedText;
    _cacheDecrypted[decryptedText] = transitmessage;
    return encryptedText;
  }

  String decrypt(String transitmessage) {
    final iv = IV.fromBase64(transitmessage.substring(0, 24));
    final encryptedText = transitmessage.substring(24);
    if (_cacheDecrypted.containsKey(encryptedText)) {
      return _cacheDecrypted[encryptedText];
    }
    final encryptedContent = Encrypted.fromBase64(encryptedText);
    final encryptor = getEncryptor();
    if (encryptor == null) {
      return "";
    }
    try {
      final decryptedText = encryptor.decrypt(encryptedContent, iv: iv);
      _cacheDecrypted[encryptedText] = decryptedText;
      return decryptedText;
    } catch (error) {
      rethrow;
    }
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
