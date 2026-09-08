import 'package:ai_task_manager/features/task/domain/repositories/task_repository.dart';
import 'package:ai_task_manager/features/task/domain/task.dart';
import 'package:ai_task_manager/features/task/presentation/cubit/task_cubit.dart';
import 'package:ai_task_manager/features/task/presentation/cubit/task_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  late MockTaskRepository mockRepository;
  late TaskCubit taskCubit;

  final testDate1 = DateTime(2026, 8, 20, 10, 0);
  final testDate2 = DateTime(2026, 8, 20, 11, 0);

  final tTask1 = Task(
    id: '1',
    title: 'Task 1',
    description: 'Description 1',
    isCompleted: false,
    createdAt: testDate1,
  );

  final tTask2Incomplete = Task(
    id: '2',
    title: 'Task 2',
    description: 'Description 2',
    isCompleted: false,
    createdAt: testDate2,
  );

  final tTask2Completed = Task(
    id: '2',
    title: 'Task 2',
    description: 'Description 2',
    isCompleted: true,
    createdAt: testDate2,
  );

  setUp(() {
    mockRepository = MockTaskRepository();
    taskCubit = TaskCubit(repository: mockRepository);
  });

  tearDown(() {
    taskCubit.close();
  });

  test('initial state should be TaskInitial', () {
    expect(taskCubit.state, equals(const TaskInitial()));
  });

  group('loadTasks', () {
    blocTest<TaskCubit, TaskState>(
      'emits [TaskLoading, TaskLoaded] with tasks sorted by createdAt descending on success',
      build: () {
        when(
          () => mockRepository.getTasks(),
        ).thenAnswer((_) async => [tTask1, tTask2Incomplete]);
        return taskCubit;
      },
      act: (cubit) => cubit.loadTasks(),
      expect: () => [
        const TaskLoading(),
        TaskLoaded(tasks: [tTask2Incomplete, tTask1], filter: TaskFilter.all),
      ],
      verify: (_) {
        verify(() => mockRepository.getTasks()).called(1);
      },
    );

    blocTest<TaskCubit, TaskState>(
      'emits [TaskLoading, TaskError] when repository fails',
      build: () {
        when(
          () => mockRepository.getTasks(),
        ).thenThrow(Exception('Failed to load tasks'));
        return taskCubit;
      },
      act: (cubit) => cubit.loadTasks(),
      expect: () => [
        const TaskLoading(),
        isA<TaskError>().having(
          (e) => e.message,
          'message',
          contains('Failed to load tasks'),
        ),
      ],
    );
  });

  group('createTask', () {
    blocTest<TaskCubit, TaskState>(
      'calls repository and emits updated TaskLoaded on success',
      build: () {
        when(() => mockRepository.getTasks()).thenAnswer((_) async => [tTask1]);
        when(() => mockRepository.saveTasks(any())).thenAnswer((_) async {});
        return taskCubit;
      },
      act: (cubit) => cubit.createTask(
        'Task 2',
        description: 'Description 2',
        id: '2',
        createdAt: testDate2,
      ),
      expect: () => [
        TaskLoaded(tasks: [tTask2Incomplete, tTask1], filter: TaskFilter.all),
      ],
      verify: (_) {
        verify(() => mockRepository.getTasks()).called(1);
        verify(() => mockRepository.saveTasks(any())).called(1);
      },
    );

    blocTest<TaskCubit, TaskState>(
      'emits TaskError when title is empty or invalid',
      build: () => taskCubit,
      act: (cubit) => cubit.createTask('   '),
      expect: () => [
        isA<TaskError>().having(
          (e) => e.message,
          'message',
          contains('must not be blank'),
        ),
      ],
      verify: (_) {
        verifyNever(() => mockRepository.saveTasks(any()));
      },
    );

    blocTest<TaskCubit, TaskState>(
      'emits TaskError when repository save fails',
      build: () {
        when(() => mockRepository.getTasks()).thenAnswer((_) async => []);
        when(
          () => mockRepository.saveTasks(any()),
        ).thenThrow(Exception('Database write error'));
        return taskCubit;
      },
      act: (cubit) => cubit.createTask('Task 1', id: '1', createdAt: testDate1),
      expect: () => [
        isA<TaskError>().having(
          (e) => e.message,
          'message',
          contains('Database write error'),
        ),
      ],
    );
  });

  group('editTask', () {
    blocTest<TaskCubit, TaskState>(
      'updates task and emits TaskLoaded with updated task',
      build: () {
        when(() => mockRepository.getTasks()).thenAnswer((_) async => [tTask1]);
        when(() => mockRepository.saveTasks(any())).thenAnswer((_) async {});
        return taskCubit;
      },
      act: (cubit) =>
          cubit.editTask('1', 'Updated Title', description: 'Updated Desc'),
      expect: () => [
        TaskLoaded(
          tasks: [
            Task(
              id: '1',
              title: 'Updated Title',
              description: 'Updated Desc',
              isCompleted: false,
              createdAt: testDate1,
            ),
          ],
          filter: TaskFilter.all,
        ),
      ],
      verify: (_) {
        verify(() => mockRepository.getTasks()).called(1);
        verify(() => mockRepository.saveTasks(any())).called(1);
      },
    );

    blocTest<TaskCubit, TaskState>(
      'emits TaskError when task id is not found',
      build: () {
        when(() => mockRepository.getTasks()).thenAnswer((_) async => [tTask1]);
        return taskCubit;
      },
      act: (cubit) => cubit.editTask('non-existent', 'Title'),
      expect: () => [const TaskError('Task not found')],
      verify: (_) {
        verifyNever(() => mockRepository.saveTasks(any()));
      },
    );

    blocTest<TaskCubit, TaskState>(
      'emits TaskError when edit title is empty',
      build: () {
        when(() => mockRepository.getTasks()).thenAnswer((_) async => [tTask1]);
        return taskCubit;
      },
      act: (cubit) => cubit.editTask('1', '   '),
      expect: () => [
        isA<TaskError>().having(
          (e) => e.message,
          'message',
          contains('must not be blank'),
        ),
      ],
    );

    blocTest<TaskCubit, TaskState>(
      'emits TaskError when repository fails on edit',
      build: () {
        when(
          () => mockRepository.getTasks(),
        ).thenThrow(Exception('Read failure'));
        return taskCubit;
      },
      act: (cubit) => cubit.editTask('1', 'New Title'),
      expect: () => [
        isA<TaskError>().having(
          (e) => e.message,
          'message',
          contains('Read failure'),
        ),
      ],
    );
  });

  group('deleteTask', () {
    blocTest<TaskCubit, TaskState>(
      'removes task and emits TaskLoaded with remaining tasks',
      build: () {
        when(
          () => mockRepository.getTasks(),
        ).thenAnswer((_) async => [tTask2Incomplete, tTask1]);
        when(() => mockRepository.saveTasks(any())).thenAnswer((_) async {});
        return taskCubit;
      },
      act: (cubit) => cubit.deleteTask('1'),
      expect: () => [
        TaskLoaded(tasks: [tTask2Incomplete], filter: TaskFilter.all),
      ],
      verify: (_) {
        verify(() => mockRepository.getTasks()).called(1);
        verify(() => mockRepository.saveTasks(any())).called(1);
      },
    );

    blocTest<TaskCubit, TaskState>(
      'emits TaskError when repository fails on delete',
      build: () {
        when(
          () => mockRepository.getTasks(),
        ).thenThrow(Exception('Delete error'));
        return taskCubit;
      },
      act: (cubit) => cubit.deleteTask('1'),
      expect: () => [
        isA<TaskError>().having(
          (e) => e.message,
          'message',
          contains('Delete error'),
        ),
      ],
    );
  });

  group('toggleTaskCompletion', () {
    blocTest<TaskCubit, TaskState>(
      'toggles completion state and emits updated TaskLoaded',
      build: () {
        when(() => mockRepository.getTasks()).thenAnswer((_) async => [tTask1]);
        when(() => mockRepository.saveTasks(any())).thenAnswer((_) async {});
        return taskCubit;
      },
      act: (cubit) => cubit.toggleTaskCompletion('1'),
      expect: () => [
        TaskLoaded(
          tasks: [
            Task(
              id: '1',
              title: 'Task 1',
              description: 'Description 1',
              isCompleted: true,
              createdAt: testDate1,
            ),
          ],
          filter: TaskFilter.all,
        ),
      ],
      verify: (_) {
        verify(() => mockRepository.getTasks()).called(1);
        verify(() => mockRepository.saveTasks(any())).called(1);
      },
    );

    blocTest<TaskCubit, TaskState>(
      'emits TaskError when task id is not found for toggle',
      build: () {
        when(() => mockRepository.getTasks()).thenAnswer((_) async => [tTask1]);
        return taskCubit;
      },
      act: (cubit) => cubit.toggleTaskCompletion('unknown-id'),
      expect: () => [const TaskError('Task not found')],
    );

    blocTest<TaskCubit, TaskState>(
      'emits TaskError when repository fails on toggle',
      build: () {
        when(
          () => mockRepository.getTasks(),
        ).thenThrow(Exception('Toggle save error'));
        return taskCubit;
      },
      act: (cubit) => cubit.toggleTaskCompletion('1'),
      expect: () => [
        isA<TaskError>().having(
          (e) => e.message,
          'message',
          contains('Toggle save error'),
        ),
      ],
    );
  });

  group('setFilter & filteredTasks', () {
    blocTest<TaskCubit, TaskState>(
      'updates filter in TaskLoaded state',
      build: () => taskCubit,
      seed: () =>
          TaskLoaded(tasks: [tTask2Completed, tTask1], filter: TaskFilter.all),
      act: (cubit) => cubit.setFilter(TaskFilter.incomplete),
      expect: () => [
        TaskLoaded(
          tasks: [tTask2Completed, tTask1],
          filter: TaskFilter.incomplete,
        ),
      ],
    );

    test('filteredTasks returns correct subset for each TaskFilter', () {
      final loaded = TaskLoaded(
        tasks: [tTask2Completed, tTask1],
        filter: TaskFilter.all,
      );

      expect(loaded.filteredTasks, equals([tTask2Completed, tTask1]));

      final incompleteOnly = loaded.copyWith(filter: TaskFilter.incomplete);
      expect(incompleteOnly.filteredTasks, equals([tTask1]));

      final completedOnly = loaded.copyWith(filter: TaskFilter.completed);
      expect(completedOnly.filteredTasks, equals([tTask2Completed]));
    });

    test('does nothing when setFilter is called on non-TaskLoaded state', () {
      expect(taskCubit.state, equals(const TaskInitial()));
      taskCubit.setFilter(TaskFilter.completed);
      expect(taskCubit.state, equals(const TaskInitial()));
    });
  });
}
