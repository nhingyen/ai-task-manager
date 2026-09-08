import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/task_repository.dart';
import '../../domain/task.dart';
import 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final TaskRepository _repository;

  TaskCubit({required TaskRepository repository})
    : _repository = repository,
      super(const TaskInitial());

  Future<void> loadTasks() async {
    emit(const TaskLoading());
    try {
      final tasks = await _repository.getTasks();
      final sortedTasks = List<Task>.from(tasks)
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      emit(TaskLoaded(tasks: sortedTasks, filter: TaskFilter.all));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> createTask(
    String title, {
    String? description,
    String? id,
    DateTime? createdAt,
  }) async {
    try {
      final newTask = Task.create(
        id: id ?? DateTime.now().microsecondsSinceEpoch.toString(),
        title: title,
        description: description,
        createdAt: createdAt ?? DateTime.now(),
      );

      final currentTasks = await _repository.getTasks();
      final updatedTasks = [newTask, ...currentTasks]
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

      await _repository.saveTasks(updatedTasks);

      final currentFilter = state is TaskLoaded
          ? (state as TaskLoaded).filter
          : TaskFilter.all;

      emit(TaskLoaded(tasks: updatedTasks, filter: currentFilter));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> editTask(String id, String title, {String? description}) async {
    try {
      final currentTasks = await _repository.getTasks();
      final index = currentTasks.indexWhere((t) => t.id == id);
      if (index == -1) {
        emit(const TaskError('Task not found'));
        return;
      }

      final taskToUpdate = currentTasks[index];
      final updatedTask = taskToUpdate
          .updateTitle(title)
          .updateDescription(description);

      final updatedTasks = List<Task>.from(currentTasks);
      updatedTasks[index] = updatedTask;
      updatedTasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      await _repository.saveTasks(updatedTasks);

      final currentFilter = state is TaskLoaded
          ? (state as TaskLoaded).filter
          : TaskFilter.all;

      emit(TaskLoaded(tasks: updatedTasks, filter: currentFilter));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      final currentTasks = await _repository.getTasks();
      final updatedTasks = currentTasks.where((t) => t.id != id).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

      await _repository.saveTasks(updatedTasks);

      final currentFilter = state is TaskLoaded
          ? (state as TaskLoaded).filter
          : TaskFilter.all;

      emit(TaskLoaded(tasks: updatedTasks, filter: currentFilter));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> toggleTaskCompletion(String id) async {
    try {
      final currentTasks = await _repository.getTasks();
      final index = currentTasks.indexWhere((t) => t.id == id);
      if (index == -1) {
        emit(const TaskError('Task not found'));
        return;
      }

      final taskToUpdate = currentTasks[index];
      final updatedTask = taskToUpdate.toggleCompletion();

      final updatedTasks = List<Task>.from(currentTasks);
      updatedTasks[index] = updatedTask;
      updatedTasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      await _repository.saveTasks(updatedTasks);

      final currentFilter = state is TaskLoaded
          ? (state as TaskLoaded).filter
          : TaskFilter.all;

      emit(TaskLoaded(tasks: updatedTasks, filter: currentFilter));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  void setFilter(TaskFilter filter) {
    try {
      if (state is TaskLoaded) {
        final loadedState = state as TaskLoaded;
        emit(TaskLoaded(tasks: loadedState.tasks, filter: filter));
      }
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }
}
