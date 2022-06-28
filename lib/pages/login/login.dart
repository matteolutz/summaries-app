import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:summaries/structures/user.dart';
import 'package:summaries/util/state.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../structures/result.dart';

class LoginPage extends StatefulWidget {
  final Function toggleView;

  const LoginPage({Key? key, required this.toggleView}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _loading = false;
  FirebaseAuthException? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    Result<void, FirebaseAuthException> r =
        await StateInheritedWidget.of(context).loginWithEmailAndPassword(
            _emailController.text, _passwordController.text);

    if (r.isError) {
      setState(() {
        _error = r.error;
        _loading = false;
      });
    } else {
      setState(() {
        _error = null;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if(_error!.code == "user-disabled") {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: TextButton(
                  onPressed: () async {
                    await launchUrlString("https://youtu.be/dQw4w9WgXcQ?t=43");
                  },
                    child: const Text("Du wurdest vom Bannhammer (🔨) getroffen!")
                ),
                duration: const Duration(seconds: 20),
            ));
        } else {
              ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Fehler beim Anmelden: ${_error!.code}")));
          }
      });
    }

    return _loading
        ? const Center(child: CircularProgressIndicator())
        : Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              children: [
                const SizedBox(height: 100),
                const Center(
                  child: Text(
                    'Anmelden',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bitte gib eine E-Mail Addresse ein';
                    }
                    if (!_emailRegex.hasMatch(value)) {
                      return 'Bitte gib eine gültige E-Mail Addresse ein';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'E-Mail',
                    border: OutlineInputBorder(),
                  ),
                  controller: _emailController,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bitte gib ein Passwort ein';
                    }
                    return null;
                  },
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Passwort',
                    border: OutlineInputBorder(),
                  ),
                  controller: _passwordController,
                ),
                const SizedBox(height: 24),
                ButtonBar(
                  children: [
                    ElevatedButton(
                      child: const Text('Anmelden'),
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }
                        _login();
                      },
                    ),
                    TextButton(
                      child:
                          const Text('Noch keinen Account? Hier Registrieren'),
                      onPressed: () => widget.toggleView(),
                    ),
                  ],
                ),
              ],
            ),
          );
  }
}
