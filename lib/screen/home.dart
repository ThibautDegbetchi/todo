
import 'package:flutter/material.dart';
import 'package:todolist/constants/colors.dart';
import 'package:todolist/database/notes_database.dart';
import 'package:todolist/widget/todo_item.dart';

import '../model/todo.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //final todoList = ToDo.todoList();
  final addtaskcontroller = TextEditingController();
   List<ToDo> _foundToDo =[];
  late  bool isLoading;
  @override
   initState()  {
    refreshTodo();
    /*if(_foundToDo.isEmpty)
      {
        print('Liste vide');
        _foundToDo=todoList;
      }*/

    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: buildAppBar(),
      drawer:  NavigationDrawerCustum(),
      body: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 25),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              children: [
                searchBox(),
                Expanded(
                  flex: 1,
                  child: ListView(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 50, bottom: 20),
                        child: const Text(
                          'Toutes les Taches',
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w500),
                        ),
                      ),
                      for (ToDo todo in _foundToDo.reversed)
                        ToDoItem(
                          todo: todo,
                          onTodDoChanged: _handleToDoChange,
                          onDeletItem: _deleteToDoItem,
                        ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 10),
                      margin: const EdgeInsets.only(bottom: 5, right: 20, left: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0.0, 0.0),
                              blurRadius: 10.0,
                              spreadRadius: 0.0)
                        ],
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                    controller: addtaskcontroller,
                    decoration: const InputDecoration(
                        hintText: 'Ajouter une nouvelle tache',
                        border: InputBorder.none),
                  ),
                )),
                Container(
                    margin: const EdgeInsets.only(bottom: 5, right: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        if(addtaskcontroller.text.isNotEmpty){
                          _addTodoItem(addtaskcontroller.text);
                          print('Tache ajoutée avec sucess');
                        }

                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: tdBlue,
                          minimumSize: const Size(60, 60),
                          elevation: 10),
                      child: const Text(
                        '+',
                        style: TextStyle(
                          fontSize: 40,
                        ),
                      ),
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: tdBGColor,
      title: const Text(
        'Home',
        style: TextStyle(color: tdBlack),
      ),
      centerTitle: true,
      actions: [
        SizedBox(
          height: 40,
          width: 40,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset('assets/logo1.png'),
          ),
        )
      ],
    );
  }

  void _runfilter(String enteredKeyword) {
    List<ToDo>? result = [];
    if (enteredKeyword.isEmpty) {
      result = _foundToDo;
    } else {
      result = _foundToDo
          .where((element) => element.todoText!
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      _foundToDo = result!;
    });
  }

  void _addTodoItem(String task) {
    setState(() {
      _foundToDo.add(ToDo(
          id: DateTime.now().millisecondsSinceEpoch,
          todoText: task));
      NotesDatabase.instance.create(ToDo(
          id: DateTime.now().millisecondsSinceEpoch,
          todoText: task));
    });
    addtaskcontroller.clear();
  }

  void _handleToDoChange(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
      NotesDatabase.instance.update(todo);
    });
  }

  void _deleteToDoItem(int id) {
    setState(() {
      _foundToDo.removeWhere((item) => item.id == id);
      NotesDatabase.instance.delete(id);
      refreshTodo();
    });
  }

  Widget searchBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          color: Colors.grey[50], borderRadius: BorderRadius.circular(20)),
      child: TextFormField(
        onChanged: (value) {
          _runfilter(value);
        },
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(0),
          prefix: Icon(
            Icons.search,
            color: tdBlack,
            size: 20,
          ),
          prefixIconConstraints: BoxConstraints(maxHeight: 20, maxWidth: 25),
          border: InputBorder.none,
          hintText: 'Search',
          hintStyle: TextStyle(color: tdGrey),
        ),
      ),
    );
  }

  Future refreshTodo() async {
    if((await NotesDatabase.instance.readAllNote())!.isNotEmpty) {
      _foundToDo = (await NotesDatabase.instance.readAllNote())!;
      print('database actualization okay');
      setState(()  {
        isLoading = true;
        _foundToDo;
      });
    }
  }

}

// ignore: must_be_immutable
class NavigationDrawerCustum extends StatelessWidget {
  NavigationDrawerCustum({Key? key}):super(key: key);
 DateTime? lastPressed;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Drawer(
      elevation: 1,
      child: SingleChildScrollView(
        child: Column(
          children:<Widget> [
            buildHeader(context),
            buildMenuItems(context),
          ],
        ),
      ),
    );
  }

 Widget buildHeader(BuildContext context) =>Container(
   padding: EdgeInsets.only(
     top: MediaQuery.of(context).padding.top
   ),
 ) ;

 Widget buildMenuItems(BuildContext context) => Column(
   children: [
     ListTile(
       leading: const Icon(Icons.person),
       title: const Text('Profil',
       style: TextStyle(
         fontSize: 15
       ),),
       onTap: (){

       },
     ),
     ListTile(
       leading: const Icon(Icons.settings),
       title: const Text('Setting',
         style: TextStyle(
             fontSize: 15
         ),),
       onTap: (){

       },
     ),
     ListTile(
       leading: const Icon(Icons.logout),
       title: const Text('LogOut',
         style: TextStyle(
             fontSize: 15
         ),),
       onTap: () async{
         NotesDatabase.instance.close();
         //todo It's for mobile app not for web
         /*if(Platform.isAndroid){
           print('Android');

         SystemNavigator.pop();
         }else {
           print('none');
         }*/

       },
     )
   ],
 );
}
