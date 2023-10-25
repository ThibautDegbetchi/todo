import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todolist/constants/colors.dart';
import 'package:todolist/model/todo.dart';

class ToDoItem extends StatelessWidget {
   final ToDo todo;
   ToDoItem({Key? key, required this.todo}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: ListTile(
        onTap: (){
          print('Vous avez cliquer sur unr tache');
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
        tileColor: Colors.white,
        leading: Icon(todo.isDone?
          Icons.check_box:Icons.check_box_outline_blank,
          color: tdBlue,
        ),
        title: Text(todo.todoText!,style: TextStyle(
          fontSize: 16,
          color: tdBlack,
          decoration:todo.isDone? TextDecoration.lineThrough:TextDecoration.none
        ),),
        trailing: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(0),
          margin: EdgeInsets.symmetric(vertical: 10 ),
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            color: tdRed,
            borderRadius: BorderRadius.circular(5)
          ),
          child: IconButton(onPressed: (){
            print('Vous avez apuyer sur l\'icon supprimer');
          }, icon: Icon(Icons.delete,
          size: 15,
          color: Colors.white,) ),
        ),
      ),
    );
  }
}
