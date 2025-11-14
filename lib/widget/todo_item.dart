import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todolist/constants/colors.dart';
import 'package:todolist/model/todo.dart';
import 'package:todolist/screen/todo_detail_screen.dart';

class ToDoItem extends StatelessWidget {
  final ToDo todo;
  final onTodDoChanged;
  final onDeletItem;
  final Function(ToDo) onEditItem;
  ToDoItem(
      {Key? key,
      required this.todo,
      required this.onDeletItem,
      required this.onTodDoChanged,
      required this.onEditItem,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: ListTile(
        onTap: () {
          print('Vous avez cliquer sur unr tache');
          onTodDoChanged(todo);
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        tileColor: Colors.white,
        leading: Icon(
          todo.isDone ? Icons.check_box : Icons.check_box_outline_blank,
          color: tdBlue,
        ),
        title: Text(
          todo.todoText!,
          style: TextStyle(
              fontSize: 16,
              color: tdBlack,
              decoration: todo.isDone
                  ? TextDecoration.lineThrough
                  : TextDecoration.none),
        ),
        trailing: SizedBox(
          // On utilise un SizedBox pour contraindre la largeur
          width: 100, // Assez large pour deux boutons
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.end, // Aligne les boutons à la fin
            children: [
              // Bouton Modifier
              IconButton(
                icon: const Icon(Icons.edit),
                color: tdBlue, // Donnons-lui une couleur
                onPressed: () {
                  onEditItem(todo);
                },
              ),
              // Bouton Supprimer
              IconButton(
                icon: const Icon(Icons.delete),
                color: tdRed, // Utilisons votre couleur rouge
                onPressed: () {
                  print('Vous avez appuyé sur l\'icône supprimer');
                  onDeletItem(todo.id);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
