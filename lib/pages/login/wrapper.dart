import 'package:flutter/material.dart';
import 'package:summaries/pages/login/login.dart';
import 'package:summaries/pages/login/register.dart';

class AuthWrapperPage extends StatefulWidget {
  const AuthWrapperPage({Key? key}) : super(key: key);

  @override
  State<AuthWrapperPage> createState() => _AuthWrapperPageState();
}

class _AuthWrapperPageState extends State<AuthWrapperPage> {
  bool _showRegister = false;

  void _toggleView() {
    setState(() {
      _showRegister = !_showRegister;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _showRegister
            ? RegisterPage(toggleView: _toggleView)
            : LoginPage(toggleView: _toggleView));
  }
}
