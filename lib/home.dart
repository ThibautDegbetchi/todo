import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist/onbordingPage/onbordingpage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(onPressed: ()  async {
            final pref = await SharedPreferences.getInstance();
            pref.setBool('showHome', false);
            Navigator.push(context, MaterialPageRoute(builder: (context){
              return  OnbordingPageState();
            }));
          }, icon: Icon(Icons.logout_outlined))
        ],
      ),
      body: Container(

      ),
    );
  }
}
