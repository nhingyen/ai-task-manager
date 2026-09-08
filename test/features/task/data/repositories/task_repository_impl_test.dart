import 'package:ai_task_manager/features/task/data/datasources/task_local_data_source.dart';
import 'package:ai_task_manager/features/task/data/models/task_model.dart';
import 'package:ai_task_manager/features/task/data/repositories/task_repository_impl.dart';
import 'package:ai_task_manager/features/task/domain/task.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTaskLocalDataSource extends Mock implements TaskLocalDataSource {}

void main() {
  late TaskRepositoryImpl repository;
  late MockTaskLocalDataSource mockLocalDataSource;

  setUp(() {
    mockLocalDataSource = MockTaskLocalDataSource();
    repository = TaskRepositoryImpl(localDataSource: mockLocalDataSource);
  });

  final tTask = Task(
    id: '1',
    title: 'Test Task',
    description: 'Description',
    isCompleted: false,
    createdAt: DateTime(2023, 1, 1),
  );
  final tTaskModel = TaskModel.fromDomain(tTask);

  group('getTasks', () {
    test('should return list of tasks from local data source', () async {
      // arrange
      when(
        () => mockLocalDataSource.getTasks(),
      ).thenAnswer((_) async => [tTaskModel]);
      // act
      final result = await repository.getTasks();
      // assert
      expect(result, [tTaskModel]);
      verify(() => mockLocalDataSource.getTasks());
    });
  });

  group('saveTasks', () {
    test('should call saveTasks on local data source', () async {
      // arrange
      when(
        () => mockLocalDataSource.saveTasks(any()),
      ).thenAnswer((_) async => {});
      // act
      await repository.saveTasks([tTask]);
      // assert
      verify(() => mockLocalDataSource.saveTasks(any()));
    });
  });
}
