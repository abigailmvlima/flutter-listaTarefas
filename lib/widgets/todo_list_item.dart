import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import '../models/todo.dart';

class TodoListItem extends StatelessWidget {
  const TodoListItem({super.key, required this.todo});

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Slidable(
          // Specify a key if the Slidable is dismissible.
          key: const ValueKey(0),
      // The end action pane is the one at the right or the bottom side.
      endActionPane: const ActionPane(
      motion: ScrollMotion(),
      children: [
      SlidableAction(
      // An action can be bigger than the others.
        onPressed: null,
        backgroundColor: Color(0xFFFE4A49),
        foregroundColor: Colors.white,
        icon: Icons.delete,
        label: 'Delete',
      ),
      ],
      ),
      // The child of the Slidable is what the user sees when the
      child: Container(
      decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      color: Colors.grey[300],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
      Text(
      DateFormat('dd/MM/yyyy - HH:mm').format(todo.dateTime),
      style: const TextStyle(
      fontSize: (12),
      ),
      ),
      Text(
      todo.title,
      style: const TextStyle(
      fontSize: (16),
      fontWeight: FontWeight.w600,
      ),
      ),
      ],
      ),
      ), ),
    );
  }
}

