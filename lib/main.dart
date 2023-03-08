import 'dart:io';

class Task {
  final String title;
  final String? description;
  final String? category;
  bool completed;

  Task(this.title, {this.description, this.category, this.completed = false});

  factory Task.fromString(String str) {
    String title = '';
    String description = '';
    String? category;

    if (str.contains(',')) {
      final parts = str.split(',');

      title = parts[0].trim();

      if (str.contains(':')) {
        description = parts[1].split(':')[0].trim();
        category = parts[1].split(':')[1].trim();
      } else {
        description = parts[1].trim();
        category = 'uncategorized';
      }

      return Task(title, description: description, category: category);
    } else {
      if (str.contains(':')) {
        final parts = str.split(':');

        title = parts[0].trim();
        category = parts[1].trim();
      } else {
        title = str;
        category = 'uncategorized';
      }

      return Task(title, category: category);
    }
  }

  void markCompleted() {
    completed = true;
  }

  @override
  String toString() {
    return '$title${description != null ? ': $description' : ''}, category: $category${completed ? ' [completed]' : ' [uncompleted]'}';
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

  final Set<String> _categories = {};

  void addTask(Task task) {
    _tasks.add(task);

    String categoryToAdd = task.category ?? 'uncategorized';

    if (!(_categories.contains(categoryToAdd)) &&
        categoryToAdd != 'uncategorized') {
      _categories.add(categoryToAdd);

      print('Added new category $categoryToAdd.');
    }
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

  void listCategories() {
    if (_categories.isEmpty) {
      print('There are no categories yet.');
    } else {
      for (var category in _categories) {
        print('- $category');
      }
    }
  }
}

void main() {
  final manager = TaskManager();

  while (true) {
    print('Enter a command (add, list, complete, categories, remove, exit):');
    final command = stdin.readLineSync();

    switch (command) {
      case 'add':
        print(
            'Enter task title, description(optional) and category(optional) in format "title, description: category":');
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

        final index = int.tryParse(stdin.readLineSync() ?? '');

        manager.markCompleted(index!);

        print('Task completed!');

        break;

      case 'categories':
        manager.listCategories();

        break;

      case 'remove':
        print('Enter task index:');

        final index = int.tryParse(stdin.readLineSync() ?? '');

        manager.removeTask(index!);

        break;

      case 'exit':
        print('Goodbye!');
        exit(0);

      default:
        print('Invalid command.');
    }
  }
}
