import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist/onbordingPage/onbordingpage.dart';
import 'package:todolist/screen/home.dart';
import 'package:todolist/screen/login_screen.dart';

class StartupScreen extends StatefulWidget {
  const StartupScreen({super.key});

  @override
  State<StartupScreen> createState() => _StartupScreenState();
}

class _StartupScreenState extends State<StartupScreen> {
  @override
  void initState() {
    super.initState();
    _navigate(); // On lance la navigation dès le début
  }

  Future<void> _navigate() async {
    final prefs = await SharedPreferences.getInstance();
    final showOnboarding = prefs.getBool('showHome') ?? false;
    final isAuthenticated = prefs.getBool('auth') ?? false;

    // On attend une frame pour éviter les erreurs de navigation pendant le build
    await Future.delayed(Duration.zero);

    if (mounted) { // On vérifie que le widget est toujours là
      if (!showOnboarding) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const OnbordingPageState()));
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => isAuthenticated ? const HomePage() : const LoginScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // On affiche un écran de chargement pendant que _navigate travaille
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
