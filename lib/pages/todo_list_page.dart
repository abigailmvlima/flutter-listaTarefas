import 'package:flutter/material.dart';
import 'package:flutter_todo_list/models/todo.dart';
import 'package:flutter_todo_list/repositories/todo_repository.dart';
import '../widgets/todo_list_item.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController todoController = TextEditingController();
  final TodoRepository todoRepository = TodoRepository();

  List<Todo> todos = [];
  Todo? deletedTodo;
  int? deletedTodoPos;

  @override
    void initState() {
      super.initState();

      todoRepository.getTodoList().then((value) => {
        setState(() {
          todos = value;
        }),
      });

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: todoController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Adicione uma tarefa',
                            hintText: 'Ex. Estudar Flutter'),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        String text = todoController.text;
                        setState(() {
                          Todo newTodo = Todo(
                            title: text,
                            dateTime: DateTime.now(),
                          );
                          todos.add(newTodo);
                        });
                        todoController.clear();
                        todoRepository.saveTodoList(todos);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        padding: const EdgeInsets.all(14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6)),
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (Todo todo in todos)
                        TodoListItem(
                          todo: todo,
                          onDelete: onDelete,
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child:
                          Text('Você possui ${todos.length} tarefas pendentes'),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    ElevatedButton(
                      onPressed: showDeleteTodosConfirmationDialog,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink,
                          padding: const EdgeInsets.all(14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          )),
                      child: const Text(
                        'Limpar Tudo',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void onDelete (Todo todo) {
    deletedTodo = todo;
    deletedTodoPos = todos.indexOf(todo);
    setState(() {
      todos.remove(todo);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Tarefa ${todo.title} foi removida', style: const TextStyle(color: Colors.blueGrey),
            ),
          backgroundColor: Colors.white,
          action: SnackBarAction(
            label: 'Desfazer',
            textColor: Colors.pink,
            onPressed: () {
              setState(() {
                todos.insert(deletedTodoPos!, deletedTodo!);
              });
            },
          ),
          duration: const Duration(seconds: 4),
        ),
    );
  }
  void showDeleteTodosConfirmationDialog() {
    showDialog(context: context, builder: (context) => AlertDialog(
      title: const Text('Limpar Tudo?'),
      content: const Text('Você tem certeza que deseja apagar todas as terefas?'),
      actions: [
        TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text('Cancelar', style: TextStyle(color: Colors.pink),),),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            deletedAllTodos();
          },
          child: const Text('Limpar Tudo', style: TextStyle(color: Colors.red),),),
      ],
    ));
  }
  void deletedAllTodos() {
    setState(() {
      todos.clear();
    });
  }
}
