import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../structures/result.dart';
import '../../util/state.dart';

class RegisterPage extends StatefulWidget {
  final Function toggleView;

  const RegisterPage({Key? key, required this.toggleView}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _loading = false;
  FirebaseAuthException? _error;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    Result<void, dynamic> r = await StateInheritedWidget.of(context)
        .registerWithEmailAndPassword(_emailController.text,
            _passwordController.text, _usernameController.text);

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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Fehler beim Registrieren: ${_error!.code}")));
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
                    'Registrieren',
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
                      return 'Bitte gib einen Benutzernamen ein';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Benutzername',
                    border: OutlineInputBorder(),
                  ),
                  controller: _usernameController,
                ),
                const SizedBox(height: 12),
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
                    if (value.length < 8) {
                      return 'Bitte gib ein Passwort mit mindestens 8 Zeichen ein';
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
                const SizedBox(height: 12),
                TextFormField(
                  validator: (value) {
                    if (value == null || value != _passwordController.text) {
                      return "Die Passwörter müssen übereinstimmen";
                    }
                    return null;
                  },
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Passwort wiederholen',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),
                ButtonBar(
                  children: [
                    ElevatedButton(
                      child: const Text('Registrieren'),
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }
                        _register();
                      },
                    ),
                    TextButton(
                      child: const Text('Bereits einen Account? Hier Anmelden'),
                      onPressed: () => widget.toggleView(),
                    ),
                  ],
                ),
              ],
            ),
          );
  }
}
