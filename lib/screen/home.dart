import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist/constants/colors.dart';
import 'package:todolist/onbordingPage/onbordingpage.dart';
import 'package:todolist/widget/todo_item.dart';

import '../model/todo.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final todoList=ToDo.todoList();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: buildAppBar(),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          children: [
            searchBox(),
            Expanded(
              child: ListView(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 50,bottom: 20),
                    child: Text('Toutes les Taches',style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500
                    ),),
                  ),
                  for(ToDo todo in todoList)
                      ToDoItem(todo: todo,),

                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: tdBGColor,
      leading: Icon(Icons.menu,color: tdBlack,),
      title: Text('Home',style: TextStyle(color: tdBlack),),
      centerTitle: true,
      actions: [
        Container(
          height:40,
          width:40,
          child:  ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset('assets/logo1.png'),
          ),
        )
      ],
    );
  }

 Widget searchBox() {
   return Container(
     padding: EdgeInsets.symmetric(horizontal: 15),
     decoration: BoxDecoration(
         color: Colors.white,
         borderRadius: BorderRadius.circular(20)
     ),
     child: TextFormField(
       decoration: InputDecoration(
         contentPadding: EdgeInsets.all(0),
         prefix: Icon(Icons.search,color: tdBlack,size: 20,),
         prefixIconConstraints: BoxConstraints(
             maxHeight: 20, maxWidth: 25
         ),
         border: InputBorder.none,
         hintText: 'Search',
         hintStyle: TextStyle(color: tdGrey),

       ),
     ),
   );
 }
}
