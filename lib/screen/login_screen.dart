import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist/constants/colors.dart';
import 'package:todolist/database/notes_database.dart';
import 'package:todolist/screen/home.dart';
import 'package:todolist/screen/register_screen.dart';
import 'package:todolist/widget/password_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  Future<void> _login() async {
    final preferences = await SharedPreferences.getInstance();
    final username = _usernameController.text;
    final password = _passwordController.text;

    // Lire l'utilisateur depuis la base de données
    final user = await NotesDatabase.instance.readUser(username);

    if (user != null && user.password == password) {
      // Connexion réussie
      await preferences.setBool('auth', true);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      // Échec de la connexion
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nom d\'utilisateur ou mot de passe incorrect.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _navigateToSignUp() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const SignUpScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Le code du build est identique à la version précédente
    // (Formulaire avec 2 champs, bouton de connexion et lien d'inscription)
    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDo App - Connexion'),
        backgroundColor: tdBlue,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Nom d\'utilisateur', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            PasswordTextField(controller: _passwordController),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: tdBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Connexion'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: _navigateToSignUp,
              child: const Text('Pas de compte ? Inscrivez-vous'),
            ),
          ],
        ),
      ),
    );
  }
}
