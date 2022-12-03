abstract class StorageService {
  Future<void> remove(String key);

  dynamic get(String key);

  Future<void> clear();

  bool has(String key);

  Future<void> set<T>(String key, T data);
}
