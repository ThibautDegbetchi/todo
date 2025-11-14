import 'package:flutter/material.dart';
import 'package:todolist/constants/colors.dart';
import 'package:todolist/database/notes_database.dart';
import 'package:todolist/model/todo.dart';

class ToDoDetailScreen extends StatefulWidget {
  final ToDo? todo;
  const ToDoDetailScreen({super.key, this.todo});

  @override
  State<ToDoDetailScreen> createState() => _ToDoDetailScreenState();
}

class _ToDoDetailScreenState extends State<ToDoDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _textController;

  bool get _isEditing => widget.todo != null;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.todo?.todoText ?? '');
  }

  Future<void> _saveToDo() async {
    if (_formKey.currentState!.validate()) {
      final taskText = _textController.text;

      if (_isEditing) {
        final updatedToDo = widget.todo!.copy(todoText: taskText);
        await NotesDatabase.instance.update(updatedToDo);
      } else {
        final newToDo = ToDo(
          id: DateTime.now().millisecondsSinceEpoch,
          todoText: taskText,
        );
        await NotesDatabase.instance.create(newToDo);
      }

      if (mounted) {
        Navigator.of(context).pop('actu');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Modifier la tâche' : 'Ajouter une tâche'),
        backgroundColor: tdBGColor,
        foregroundColor: tdBlack,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _textController,
                maxLines: 5,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Que voulez-vous faire ?',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Le contenu de la tâche ne peut pas être vide.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveToDo,
                style: IconButton.styleFrom(
                  backgroundColor: tdBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text("Enregistrer",style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
