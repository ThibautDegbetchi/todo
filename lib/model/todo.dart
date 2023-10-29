final String tableNotes= 'notes';

class TodoFields{
  static final List<String> values=[
    id,todoText,isDone
  ];
  static final String id='_id';
  static final String todoText='_todoText';
  static final String isDone='isDone';
}

class ToDo{
  String? id;
  String? todoText;
  bool isDone;
  
  ToDo({
    required this.id,
    required this.todoText,
    this.isDone= false,
});
  
  static List<ToDo> todoList()
  {
    return[
      ToDo(id: '01', todoText: 'Sport du matin',isDone: true),
      ToDo(id: '02', todoText: 'Acheter une belle voiture',isDone: true),
      ToDo(id: '03', todoText: 'Game day'),
      ToDo(id: '04', todoText: 'Aller à la plage',),
      ToDo(id: '05', todoText: 'Reunion de boulot'),
      ToDo(id: '06', todoText: 'Dinner avec ...',isDone: true),

    ];
  }
  Map<String, Object?>toJson()=>{
    TodoFields.id:id,
    TodoFields.todoText:todoText,
    TodoFields.isDone:isDone? 1:0
};
  static ToDo fromJson(Map<String,Object?> json)=>ToDo(
    id: json[TodoFields.id]as String,
    todoText: json[TodoFields.todoText] as String,
    isDone: json[TodoFields.isDone]==1
  );
  ToDo copy({
    int? id,
    String? todoText,
    bool? isDone,
  })=>ToDo(id: id.toString(), todoText: todoText);
}