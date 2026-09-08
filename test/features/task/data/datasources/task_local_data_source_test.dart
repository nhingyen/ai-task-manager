import 'dart:convert';
import 'package:ai_task_manager/core/error/exceptions.dart';
import 'package:ai_task_manager/features/task/data/datasources/task_local_data_source.dart';
import 'package:ai_task_manager/features/task/data/models/task_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late TaskLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = TaskLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  final tTaskModel = TaskModel(
    id: '1',
    title: 'Test Task',
    description: 'Description',
    isCompleted: false,
    createdAt: DateTime(2023, 1, 1),
  );
  final tTaskModelList = [tTaskModel];
  const tTasksKey = 'cached_tasks';

  group('getTasks', () {
    test(
      'should return empty list when there is no data in SharedPreferences',
      () async {
        // arrange
        when(() => mockSharedPreferences.getString(any())).thenReturn(null);
        // act
        final result = await dataSource.getTasks();
        // assert
        expect(result, []);
        verify(() => mockSharedPreferences.getString(tTasksKey));
      },
    );

    test(
      'should return list of TaskModel when there is data in SharedPreferences',
      () async {
        // arrange
        final jsonString = json.encode([tTaskModel.toJson()]);
        when(
          () => mockSharedPreferences.getString(any()),
        ).thenReturn(jsonString);
        // act
        final result = await dataSource.getTasks();
        // assert
        expect(result.length, 1);
        expect(result[0].id, tTaskModel.id);
        expect(result[0].title, tTaskModel.title);
      },
    );

    test('should throw CacheException when data is invalid JSON', () async {
      // arrange
      when(
        () => mockSharedPreferences.getString(any()),
      ).thenReturn('invalid json');
      // act
      final call = dataSource.getTasks;
      // assert
      expect(() => call(), throwsA(isA<CacheException>()));
    });
  });

  group('saveTasks', () {
    test('should call SharedPreferences to save data', () async {
      // arrange
      when(
        () => mockSharedPreferences.setString(any(), any()),
      ).thenAnswer((_) async => true);
      // act
      await dataSource.saveTasks(tTaskModelList);
      // assert
      final expectedJsonString = json.encode(
        tTaskModelList.map((t) => t.toJson()).toList(),
      );
      verify(
        () => mockSharedPreferences.setString(tTasksKey, expectedJsonString),
      );
    });

    test(
      'should throw CacheException when SharedPreferences returns false',
      () async {
        // arrange
        when(
          () => mockSharedPreferences.setString(any(), any()),
        ).thenAnswer((_) async => false);
        // act
        final call = dataSource.saveTasks;
        // assert
        expect(() => call(tTaskModelList), throwsA(isA<CacheException>()));
      },
    );
  });
}
