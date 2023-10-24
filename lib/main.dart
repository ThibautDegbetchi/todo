import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist/home.dart';
import 'package:todolist/onbordingPage/onbordingpage.dart';

Future<void> main() async {
  final pref = await SharedPreferences.getInstance();
  final showHome =pref.getBool('showHome')?? false;
  runApp( MyApp(showHome: showHome,));
}

class MyApp extends StatelessWidget {
  final bool showHome;
   MyApp({Key? key,required this.showHome}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'todolistapp',
      home: showHome? HomePage():OnbordingPageState(),
    );
  }
}
