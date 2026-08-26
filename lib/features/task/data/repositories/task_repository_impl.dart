import '../../domain/repositories/task_repository.dart';
import '../../domain/task.dart';
import '../datasources/task_local_data_source.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource localDataSource;

  TaskRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Task>> getTasks() async {
    return await localDataSource.getTasks();
  }

  @override
  Future<void> saveTasks(List<Task> tasks) async {
    final models = tasks.map((task) => TaskModel.fromDomain(task)).toList();
    await localDataSource.saveTasks(models);
  }
}
