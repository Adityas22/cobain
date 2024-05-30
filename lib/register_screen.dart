import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

import 'login_screen.dart';
import 'user.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  // Tambahkan fungsi untuk membuka kotak Hive
  Future<void> _openBox() async {
    await Hive.openBox<User>('users');
  }

  @override
  void initState() {
    super.initState();
    _openBox(); // Panggil fungsi untuk membuka kotak Hive saat initState()
  }

  void _register() async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    final box = Hive.box<User>('users');

    if (box.containsKey(username)) {
      _showError('Username already exists');
      return;
    }

    final hashedPassword = sha256.convert(utf8.encode(password)).toString();
    final user = User(username: username, password: hashedPassword);
    await box.put(username, user);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _register,
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
