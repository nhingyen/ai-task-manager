import 'package:flutter_test/flutter_test.dart';

import 'package:ai_task_manager/features/task/domain/task.dart';

void main() {
  final createdAt = DateTime(2026, 8, 19, 15, 30);

  Task createTask({String? description}) {
    return Task.create(
      id: 'task-1',
      title: 'Learn Dart',
      description: description,
      createdAt: createdAt,
    );
  }

  test('creates a valid incomplete task', () {
    final task = createTask(description: 'Review domain modeling');

    expect(task.id, 'task-1');
    expect(task.title, 'Learn Dart');
    expect(task.description, 'Review domain modeling');
    expect(task.isCompleted, isFalse);
    expect(task.createdAt, createdAt);
  });

  test('allows an optional description', () {
    expect(createTask().description, isNull);
  });

  test('rejects an empty title', () {
    expect(
      () => Task.create(id: 'task-1', title: '', createdAt: createdAt),
      throwsA(isA<ArgumentError>()),
    );
  });

  test('rejects a whitespace-only title', () {
    expect(
      () => Task.create(id: 'task-1', title: '  \t\n', createdAt: createdAt),
      throwsA(isA<ArgumentError>()),
    );
  });

  test('updateTitle changes only the title', () {
    final original = createTask(description: 'Details');
    final updated = original.updateTitle('Practice Flutter');

    expect(updated.title, 'Practice Flutter');
    expect(updated.id, original.id);
    expect(updated.description, original.description);
    expect(updated.isCompleted, original.isCompleted);
    expect(updated.createdAt, original.createdAt);
  });

  test('updateTitle rejects an invalid title', () {
    expect(() => createTask().updateTitle('  '), throwsA(isA<ArgumentError>()));
  });

  test('updateDescription changes only the description', () {
    final original = createTask(description: 'Old details');
    final updated = original.updateDescription('New details');

    expect(updated.description, 'New details');
    expect(updated.id, original.id);
    expect(updated.title, original.title);
    expect(updated.isCompleted, original.isCompleted);
    expect(updated.createdAt, original.createdAt);
  });

  test('updateDescription can remove the description', () {
    final original = createTask(description: 'Details');
    final updated = original.updateDescription(null);

    expect(updated.description, isNull);
    expect(updated.id, original.id);
    expect(updated.title, original.title);
    expect(updated.isCompleted, original.isCompleted);
    expect(updated.createdAt, original.createdAt);
  });

  test('toggleCompletion changes only completion state', () {
    final original = createTask(description: 'Details');
    final completed = original.toggleCompletion();
    final incomplete = completed.toggleCompletion();

    expect(completed.isCompleted, isTrue);
    expect(incomplete.isCompleted, isFalse);
    for (final task in [completed, incomplete]) {
      expect(task.id, original.id);
      expect(task.title, original.title);
      expect(task.description, original.description);
      expect(task.createdAt, original.createdAt);
    }
  });
}
