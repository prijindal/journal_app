import 'package:flutter/material.dart';
import 'package:journal_app/api/api.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _error;

  _login() async {
    final _instance = HttpApi.getInstance();
    var err =
        await _instance.login(_emailController.text, _passwordController.text);
    if (err == null) {
      _instance.getUser();
      Navigator.of(context).pushReplacementNamed("/journal");
    } else {
      setState(() {
        _error = err;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          constraints: BoxConstraints(
            maxWidth: 500.0,
          ),
          child: Form(
            autovalidate: true,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: "Email"),
                ),
                TextFormField(
                  controller: _passwordController,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: InputDecoration(labelText: "Password"),
                ),
                _error != null ? Text(_error) : Container(),
                RaisedButton(
                  onPressed: _login,
                  child: Text("Login"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
