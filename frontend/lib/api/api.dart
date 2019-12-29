import 'package:journal_app/helpers/flutter_persistor.dart';
import 'package:http/http.dart' as http;
import 'package:journal_app/protobufs/journal.pbserver.dart';
import 'package:journal_app/protobufs/user.pb.dart';

const String HOST = 'http://localhost:4001';
const String COOKIE_KEY = "COOKIE";

class HttpApi {
  String _cookie;

  FlutterPersistor get _persistance {
    return FlutterPersistor.getInstance();
  }

  Map<String,String> get headers {
    Map<String,String> headers = new Map<String,String>();
    if(this._cookie == null) {
      this._cookie = _persistance.loadString(COOKIE_KEY);
    }
    headers['cookie'] = this._cookie;
    return headers;
  }
  // Returns error if any, or null if succesfull
  Future<String> login(String email, String password) async {
    var url = '$HOST/login?api=true';
    var response = await http.post(url, body: {'email': email, 'password': password});
    if(response.headers.containsKey('set-cookie')) {
      this._cookie = response.headers['set-cookie'];
      if (_persistance != null) {
        _persistance.setString(COOKIE_KEY, this._cookie);
      }
      return null;
    }
    return response.body;
  }

  Future<User> getUser() async {
    var url = '$HOST/user';
    var response = await http.get(url, headers: this.headers);
    if(response.statusCode != 200) {
      _persistance.clearString(COOKIE_KEY);
      return null;
    } else {
      return User.fromBuffer(response.bodyBytes);
    }
  }

  Future<JournalResponse> getJournal() async {
    var url = '$HOST/journal';
    var response = await http.get(url, headers: this.headers);
    return JournalResponse.fromBuffer(response.bodyBytes);
  }
}