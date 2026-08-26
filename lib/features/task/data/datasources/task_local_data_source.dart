import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/error/exceptions.dart';
import '../models/task_model.dart';

abstract class TaskLocalDataSource {
  Future<List<TaskModel>> getTasks();
  Future<void> saveTasks(List<TaskModel> tasks);
}

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String _tasksKey = 'cached_tasks';

  TaskLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<TaskModel>> getTasks() async {
    final jsonString = sharedPreferences.getString(_tasksKey);
    if (jsonString == null) {
      return [];
    }

    try {
      final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
      return jsonList
          .map((json) => TaskModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw CacheException('Failed to decode tasks: $e');
    }
  }

  @override
  Future<void> saveTasks(List<TaskModel> tasks) async {
    try {
      final jsonString = json.encode(
        tasks.map((task) => task.toJson()).toList(),
      );
      final result = await sharedPreferences.setString(_tasksKey, jsonString);
      if (!result) {
        throw CacheException('Failed to save tasks to local storage.');
      }
    } catch (e) {
      if (e is CacheException) rethrow;
      throw CacheException('Unexpected error during save: $e');
    }
  }
}
