import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:uni_links/uni_links.dart';

import 'package:journal_app/api/api.dart';
import 'package:journal_app/helpers/flutter_persistor.dart';

class LoadingScreen extends StatefulWidget {
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    _checkUser();
  }

  Future<Null> initUniLinks() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      String initialLink = await getInitialLink();
      if (initialLink != null) {
        print(initialLink);
      }
      // Parse the link and warn the user, if it is not correct,
      // but keep in mind it could be `null`.
    } on PlatformException {
      // Handle exception by warning the user their action did not succeed
      // return?
    }
  }

  _checkUser() async {
    final _instance = HttpApi.getInstance();
    await FlutterPersistor.getInstance().initSharedPreferences();
    final user = await _instance.getUser();
    if (user == null) {
      _instance.logout();
      Navigator.of(context).pushReplacementNamed("/login");
    } else {
      Navigator.of(context).pushReplacementNamed("/journal");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Loading"),
      ),
    );
  }
}
