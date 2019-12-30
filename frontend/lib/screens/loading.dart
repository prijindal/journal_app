import 'package:flutter/material.dart';
import 'package:journal_app/api/api.dart';

class LoadingScreen extends StatefulWidget {
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    _checkUser();
  }

  _checkUser() async {
    final _instance = HttpApi.getInstance();
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
