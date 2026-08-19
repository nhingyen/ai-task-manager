class Task {
  const Task._({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.createdAt,
  });

  factory Task.create({
    required String id,
    required String title,
    required DateTime createdAt,
    String? description,
  }) {
    _validateTitle(title);

    return Task._(
      id: id,
      title: title,
      description: description,
      isCompleted: false,
      createdAt: createdAt,
    );
  }

  final String id;
  final String title;
  final String? description;
  final bool isCompleted;
  final DateTime createdAt;

  Task updateTitle(String title) {
    _validateTitle(title);

    return Task._(
      id: id,
      title: title,
      description: description,
      isCompleted: isCompleted,
      createdAt: createdAt,
    );
  }

  Task updateDescription(String? description) {
    return Task._(
      id: id,
      title: title,
      description: description,
      isCompleted: isCompleted,
      createdAt: createdAt,
    );
  }

  Task toggleCompletion() {
    return Task._(
      id: id,
      title: title,
      description: description,
      isCompleted: !isCompleted,
      createdAt: createdAt,
    );
  }

  static void _validateTitle(String title) {
    if (title.trim().isEmpty) {
      throw ArgumentError.value(title, 'title', 'must not be blank');
    }
  }
}
