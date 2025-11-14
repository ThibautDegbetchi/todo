import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist/constants/colors.dart';
import 'package:todolist/database/notes_database.dart';
import 'package:todolist/screen/login_screen.dart';
import 'package:todolist/screen/todo_detail_screen.dart';
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
    super.initState();
    isLoading = true;
    refreshTodo();

  }

  Future<void> _navigateToDetail({ToDo? todo}) async {
    // On attend le résultat de l'écran de détail
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ToDoDetailScreen(todo: todo),
      ),
    );

    // Si l'écran de détail a renvoyé 'actu', on rafraîchit
    if (result == 'actu') {
      print("Message reçu de l'écran de détail : il faut actualiser !");
      refreshTodo(); // C'est ici que le rafraîchissement a lieu !
    }
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
                          onEditItem: (todoToEdit) {
                            _navigateToDetail(todo: todoToEdit);
                          },
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
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0,right: 2,bottom: 14),
                    child: TextField(
                      controller: addtaskcontroller,
                      decoration: InputDecoration(
                        hintText: 'Ajouter une nouvelle tâche',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: tdBlue), // Met en évidence avec la couleur de l'app
                        ),
                        // Couleur de fond du champ
                        fillColor: Colors.white,
                        filled: true,
                        // Padding interne géré par le TextField lui-même
                        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 5), // Espace entre le champ et le bouton
                Padding(
                  padding: const EdgeInsets.only(right: 14.0,bottom: 14),
                  child: IconButton.filled(
                    padding: const EdgeInsets.all(10),
                    icon: const Icon(Icons.add),
                    iconSize: 30,
                    color: Colors.white,
                    style: IconButton.styleFrom(
                      backgroundColor: tdBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      if (addtaskcontroller.text.isNotEmpty) {
                        _addTodoItem(addtaskcontroller.text);
                      }
                    },
                  ),
                ),
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

  Future<void> _addTodoItem(String task) async {
    setState(() {
      _foundToDo.add(ToDo(
          id: DateTime.now().millisecondsSinceEpoch,
          todoText: task));
      NotesDatabase.instance.create(ToDo(
          id: DateTime.now().millisecondsSinceEpoch,
          todoText: task));
    });
    addtaskcontroller.clear();
    await refreshTodo();

  }

  Future<void> _handleToDoChange(ToDo todo) async {
    setState(() {
      todo.isDone = !todo.isDone;
      NotesDatabase.instance.update(todo);
    });
    await refreshTodo();
  }

  Future<void> _deleteToDoItem(int id) async {
    setState(() {
      _foundToDo.removeWhere((item) => item.id == id);
      NotesDatabase.instance.delete(id);
      refreshTodo();
    });
    await refreshTodo();

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

  Future<void> refreshTodo() async {
    setState(() {
      isLoading = true;
    });

    final allNotes = await NotesDatabase.instance.readAllNote();
    if (mounted) {
      setState(() {
        _foundToDo = allNotes;
        isLoading = false;
      });
    }
    print('Database actualization complete. Found ${_foundToDo.length} items.');
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
        final prefs = await SharedPreferences.getInstance();
        prefs.clear();
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context)=>const LoginScreen()),
        );
       },
     )
   ],
 );
}
