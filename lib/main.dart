import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist/screen/home.dart';
import 'package:todolist/onbordingPage/onbordingpage.dart';

Future<void> main() async {
  final pref = await SharedPreferences.getInstance();
  final showHome =pref.getBool('showHome')?? false;
  runApp( MyApp(showHome: showHome,));
}

class MyApp extends StatelessWidget {
  final bool showHome;
   const MyApp({Key? key,required this.showHome}):super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'todolistapp',
      home: showHome? const HomePage():const OnbordingPageState(),
    );
  }
}
