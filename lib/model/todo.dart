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
}