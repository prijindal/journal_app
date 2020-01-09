import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:fixnum/fixnum.dart';
import 'package:http/http.dart' as http;

import 'package:journal_app/helpers/flutter_persistor.dart';
import 'package:journal_app/protobufs/journal.pb.dart';
import 'package:journal_app/protobufs/user.pb.dart';
import 'package:journal_app/protobufs/httpqueue.pb.dart';

const JOURNALS_KEY = "JOURNALS_KEY";
const HTTP_API_QUEUE_KEY = "HTTP_API_QUEUE_KEY";

// const String HOST = 'http://localhost:4001';
const String HOST = 'https://journal.easycode.club';
const String COOKIE_KEY = "COOKIE";

class HttpApi {
  String _cookie;
  static HttpApi _instance;
  User _user;
  JournalResponse _journalResponse;
  HttpApiQueuePersistor _httpApiQueue = HttpApiQueuePersistor();

  static HttpApi getInstance() {
    if (_instance == null) {
      _instance = HttpApi();
    }
    return _instance;
  }

  User get user => _user;
  JournalResponse get journalResponse => _journalResponse;

  Future<void> initHttpApi() async {
    this._cookie = _persistance.loadString(COOKIE_KEY);
    try {
      var _journalsBuffer = _persistance.loadBuffer(JOURNALS_KEY);
      this._journalResponse = JournalResponse.fromBuffer(_journalsBuffer);
    } catch (e) {
      print(e);
    }
    try {
      var _httpApiQueueBuffer = _persistance.loadBuffer(HTTP_API_QUEUE_KEY);
      _httpApiQueue.init(HttpApiQueue.fromBuffer(_httpApiQueueBuffer));
      if ((await isConnected()) == true) {
        _httpApiQueue.httpApiQueue.queue.forEach((item) {
          if (item.type == HttpApiQueueItem_HttpApiQueueItemType.NEW_JOURNAL) {
            this.newJournal(item.params["content"],
                saveType: Journal_JournalSaveType.values
                    .where((a) => a.toString() == item.params["save_type"])
                    .toList()[0]);
          } else if (item.type ==
              HttpApiQueueItem_HttpApiQueueItemType.SAVE_JOURNAL) {
            this.saveJournal(
                Int64.parseInt(item.params["id"]), item.params["content"],
                saveType: Journal_JournalSaveType.values
                    .where((a) => a.toString() == item.params["save_type"])
                    .toList()[0]);
          } else if (item.type ==
              HttpApiQueueItem_HttpApiQueueItemType.DELETE_JOURNAL) {
            this.deleteJournal(Int64.parseInt(item.params["id"]));
          }
          _httpApiQueue.delete(item);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  bool get cookieExists {
    if (headers.containsKey('cookie') &&
        headers['cookie'] != null &&
        headers['cookie'].isNotEmpty) {
      return true;
    }
    return false;
  }

  FlutterPersistor get _persistance {
    return FlutterPersistor.getInstance();
  }

  Map<String, String> get headers {
    Map<String, String> headers = Map<String, String>();
    if (this._cookie == null) {
      this._cookie = _persistance.loadString(COOKIE_KEY);
    }
    headers['cookie'] = this._cookie;
    return headers;
  }

  Future<bool> isConnected() async {
    try {
      final result = await InternetAddress.lookup("journal.easycode.club");
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (Platform.isAndroid || Platform.isIOS) {
          var connectivityResult = await (Connectivity().checkConnectivity());
          if (connectivityResult != ConnectivityResult.none) {
            return true;
          }
        } else {
          return true;
        }
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  // Returns error if any, or null if succesfull
  Future<String> login(String email, String password) async {
    var url = '$HOST/login?api=true';
    var response =
        await http.post(url, body: {'email': email, 'password': password});
    if (response.headers.containsKey('set-cookie')) {
      this._cookie = response.headers['set-cookie'];
      if (_persistance != null) {
        await _persistance.setString(COOKIE_KEY, this._cookie);
      }
      return null;
    } else {
      return response.body;
    }
  }

  Future<void> logout() async {
    await _persistance.clearString(COOKIE_KEY);
    this._cookie = null;
    var url = '$HOST/logout';
    try {
      await http.get(url, headers: this.headers);
    } catch (e) {}
  }

  Future<User> getUser() async {
    var url = '$HOST/user';
    var response = await http.get(url, headers: this.headers);
    if (response.statusCode != 200) {
      await _persistance.clearString(COOKIE_KEY);
      return null;
    } else {
      _user = User.fromBuffer(response.bodyBytes);
      return _user;
    }
  }

  Future<JournalResponse> getJournal() async {
    var url = '$HOST/journal';
    var response = await http.get(url, headers: this.headers);
    if (response.statusCode != 200) {
      throw Error();
    }
    _journalResponse = JournalResponse.fromBuffer(response.bodyBytes);
    FlutterPersistor.getInstance()
        .setBuffer(JOURNALS_KEY, _journalResponse.writeToBuffer());
    return _journalResponse;
  }

  Future<Journal> newJournal(String content,
      {Journal_JournalSaveType saveType}) async {
    var url = '$HOST/journal';
    var params = {'content': content};
    if (saveType != null) {
      params['save_type'] = saveType.toString();
    }
    if ((await isConnected()) == false) {
      _httpApiQueue.add(
          HttpApiQueueItem_HttpApiQueueItemType.NEW_JOURNAL, params);
    }
    var response = await http.post(url, headers: this.headers, body: params);
    final Journal journal = Journal.fromBuffer(response.bodyBytes);
    _journalResponse.journals.insert(0, journal);
    _journalResponse.total++;
    return journal;
  }

  Future<Journal> saveJournal(Int64 id, String content,
      {Journal_JournalSaveType saveType}) async {
    var url = '$HOST/journal';
    var params = {'id': id.toString(), 'content': content};
    if (saveType != null) {
      params['save_type'] = saveType.toString();
    }
    if ((await isConnected()) == false) {
      _httpApiQueue.add(
          HttpApiQueueItem_HttpApiQueueItemType.SAVE_JOURNAL, params);
    }
    var response = await http.put(url, headers: this.headers, body: params);
    final Journal journal = Journal.fromBuffer(response.bodyBytes);
    final index =
        _journalResponse.journals.indexWhere((j) => j.id == journal.id);
    _journalResponse.journals.elementAt(index).content = journal.content;
    _journalResponse.journals.elementAt(index).updatedAt = journal.updatedAt;
    return journal;
  }

  Future<Journal> deleteJournal(Int64 id) async {
    var url = '$HOST/journal?id=$id';
    if ((await isConnected()) == false) {
      _httpApiQueue.add(HttpApiQueueItem_HttpApiQueueItemType.SAVE_JOURNAL,
          {"id": id.toString()});
    }
    var response = await http.delete(url, headers: this.headers);
    final Journal journal = Journal.fromBuffer(response.bodyBytes);
    _journalResponse.journals.removeWhere((j) => j.id == journal.id);
    _journalResponse.total--;
    return journal;
  }
}

class HttpApiQueuePersistor {
  HttpApiQueue httpApiQueue = HttpApiQueue();

  init(HttpApiQueue _httpApiQueue) {
    this.httpApiQueue = _httpApiQueue;
  }

  delete(HttpApiQueueItem item) {
    httpApiQueue.queue.remove(item);
    _save();
  }

  add(HttpApiQueueItem_HttpApiQueueItemType type, Map<String, String> params) {
    var _item = HttpApiQueueItem.create();
    _item.type = type;
    _item.params.addAll(params);
    httpApiQueue.queue.add(_item);
    _save();
  }

  _save() {
    FlutterPersistor.getInstance()
        .setBuffer(HTTP_API_QUEUE_KEY, httpApiQueue.writeToBuffer());
  }

  clear() {
    httpApiQueue.queue.removeWhere((a) => true);
    FlutterPersistor.getInstance().clearString(HTTP_API_QUEUE_KEY);
  }
}
