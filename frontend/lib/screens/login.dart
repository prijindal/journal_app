import 'package:flutter/material.dart';
import 'package:journal_app/api/api.dart';
import 'package:pedantic/pedantic.dart';

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
      var _isConnected = await HttpApi.getInstance().isConnected();
      if (_isConnected) {
        unawaited(_instance.getUser());
      }
      unawaited(Navigator.of(context).pushReplacementNamed("/journal"));
    } else {
      setState(() {
        _error = err;
      });
    }
  }

  void _registerPage() {
    unawaited(Navigator.of(context).pushReplacementNamed("/register"));
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
                ),
                Text("Or"),
                InkWell(
                  child: Text(
                    'Register',
                    style: TextStyle(color: Colors.blue),
                  ),
                  onTap: _registerPage,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String _error;

  _register() async {
    final _instance = HttpApi.getInstance();
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _error = "Passwords must match";
      });
      return;
    }
    var err = await _instance.register(_emailController.text,
        _passwordController.text, _confirmPasswordController.text);
    if (err == null) {
      var _isConnected = await HttpApi.getInstance().isConnected();
      if (_isConnected) {
        unawaited(_instance.getUser());
      }
      unawaited(Navigator.of(context).pushReplacementNamed("/journal"));
    } else {
      setState(() {
        _error = err;
      });
    }
  }

  void _loginPage() {
    unawaited(Navigator.of(context).pushReplacementNamed("/register"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
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
                TextFormField(
                  controller: _confirmPasswordController,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: InputDecoration(labelText: "Confirm Password"),
                ),
                _error != null ? Text(_error) : Container(),
                RaisedButton(
                  onPressed: _register,
                  child: Text("Register"),
                ),
                Text("Or"),
                InkWell(
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.blue),
                  ),
                  onTap: _loginPage,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
