class CacheException implements Exception {
  final String message;
  CacheException([
    this.message = 'An error occurred while accessing local storage.',
  ]);

  @override
  String toString() => 'CacheException: $message';
}
