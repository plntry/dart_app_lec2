import 'dart:io';

class Task {
  final String title;
  final String? description;
  bool completed;

  Task(this.title, {this.description, this.completed = false});

  factory Task.fromString(String str) {
    String title = '';
    String description = '';

    if (str.contains(',')) {
      final parts = str.split(',');

      title = parts[0].trim();
      description = parts[1].trim();

      return Task(title, description: description);
    } else {
      title = str;

      return Task(title);
    }
  }

  void markCompleted() {
    completed = true;
  }

  @override
  String toString() {
    return '$title${description != null ? ': $description' : ''}${completed ? ' [completed]' : ' [uncompleted]'}';
  }
}

mixin TimestampMixin {
  DateTime created = DateTime.now();
  DateTime? updated;

  void markUpdated() {
    updated = DateTime.now();
  }

  String get createdDate => '${created.year}-${created.month}-${created.day}';
}

class TaskManager with TimestampMixin {
  final List<Task> _tasks = [];

  void addTask(Task task) {
    _tasks.add(task);
  }

  void markCompleted(int index) {
    _tasks[index].markCompleted();
    markUpdated();
  }

  void removeTask(int index) {
    assert(() {
      index >= 0 && index < _tasks.length;
      print(
          'Index cannot be less than zero or greater than tasks number - 1, try again');

      return true;
    }());

    if (index >= 0 && index < _tasks.length) {
      _tasks.removeAt(index);

      print('Task removed.');
    }
  }

  void listTasks() {
    if (_tasks.isEmpty) {
      print('No tasks found.');
    } else {
      _tasks.asMap().forEach((index, task) => print(
          '$index. $task (created on $createdDate${task.completed ? ', completed on ${updated!.year}-${updated!.month}-${updated!.day}' : ''})'));
    }
  }
}

void main() {
  final manager = TaskManager();

  while (true) {
    print('Enter a command (add, list, complete, remove, exit):');
    final command = stdin.readLineSync();

    switch (command) {
      case 'add':
        print(
            'Enter task title and description(is optional) in format "title, description":');
        final data = stdin.readLineSync();

        final task = Task.fromString(data!);

        manager.addTask(task);

        print('Task added.');

        break;

      case 'list':
        manager.listTasks();

        break;

      case 'complete':
        print('Enter task index:');

        final index = int.parse(stdin.readLineSync()!);

        manager.markCompleted(index);

        print('Task completed!');

        break;

      case 'remove':
        print('Enter task index:');

        final index = int.parse(stdin.readLineSync()!);

        manager.removeTask(index);

        break;

      case 'exit':
        print('Goodbye!');
        exit(0);

      default:
        print('Invalid command.');
    }
  }
}
