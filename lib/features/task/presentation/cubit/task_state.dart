import '../../domain/task.dart';

enum TaskFilter { all, incomplete, completed }

sealed class TaskState {
  const TaskState();
}

final class TaskInitial extends TaskState {
  const TaskInitial();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is TaskInitial;

  @override
  int get hashCode => runtimeType.hashCode;
}

final class TaskLoading extends TaskState {
  const TaskLoading();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is TaskLoading;

  @override
  int get hashCode => runtimeType.hashCode;
}

final class TaskLoaded extends TaskState {
  final List<Task> tasks;
  final TaskFilter filter;

  const TaskLoaded({required this.tasks, this.filter = TaskFilter.all});

  List<Task> get filteredTasks {
    switch (filter) {
      case TaskFilter.all:
        return tasks;
      case TaskFilter.incomplete:
        return tasks.where((task) => !task.isCompleted).toList();
      case TaskFilter.completed:
        return tasks.where((task) => task.isCompleted).toList();
    }
  }

  TaskLoaded copyWith({List<Task>? tasks, TaskFilter? filter}) {
    return TaskLoaded(
      tasks: tasks ?? this.tasks,
      filter: filter ?? this.filter,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! TaskLoaded ||
        other.filter != filter ||
        other.tasks.length != tasks.length) {
      return false;
    }
    for (var i = 0; i < tasks.length; i++) {
      final t1 = tasks[i];
      final t2 = other.tasks[i];
      if (t1.id != t2.id ||
          t1.title != t2.title ||
          t1.description != t2.description ||
          t1.isCompleted != t2.isCompleted ||
          t1.createdAt != t2.createdAt) {
        return false;
      }
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(
    filter,
    Object.hashAll(
      tasks.map(
        (t) => Object.hash(
          t.id,
          t.title,
          t.description,
          t.isCompleted,
          t.createdAt,
        ),
      ),
    ),
  );
}

final class TaskError extends TaskState {
  final String message;

  const TaskError(this.message);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskError && other.message == message);

  @override
  int get hashCode => message.hashCode;
}
