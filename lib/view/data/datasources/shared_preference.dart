import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesMock implements SharedPreferences {
  // Implement the methods you use in your MyApp class for testing purposes.
  // For example, getInt, setString, etc.
  @override
  dynamic operator [](String key) => null;

  @override
  bool containsKey(String key) => false;

  @override
  Future<bool> setString(String key, String value) async => false;

  @override
  Future<bool> setInt(String key, int value) async => false;

  @override
  int? getInt(String key) => null;

  @override
  String? getString(String key) => null;

  @override
  Future<bool> clear() {
    // TODO: implement clear
    throw UnimplementedError();
  }

  @override
  Future<bool> commit() {
    // TODO: implement commit
    throw UnimplementedError();
  }

  @override
  Object? get(String key) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  bool? getBool(String key) {
    // TODO: implement getBool
    throw UnimplementedError();
  }

  @override
  double? getDouble(String key) {
    // TODO: implement getDouble
    throw UnimplementedError();
  }

  @override
  Set<String> getKeys() {
    // TODO: implement getKeys
    throw UnimplementedError();
  }

  @override
  List<String>? getStringList(String key) {
    // TODO: implement getStringList
    throw UnimplementedError();
  }

  @override
  Future<void> reload() {
    // TODO: implement reload
    throw UnimplementedError();
  }

  @override
  Future<bool> remove(String key) {
    // TODO: implement remove
    throw UnimplementedError();
  }

  @override
  Future<bool> setBool(String key, bool value) {
    // TODO: implement setBool
    throw UnimplementedError();
  }

  @override
  Future<bool> setDouble(String key, double value) {
    // TODO: implement setDouble
    throw UnimplementedError();
  }

  @override
  Future<bool> setStringList(String key, List<String> value) {
    // TODO: implement setStringList
    throw UnimplementedError();
  }

// Implement other methods if needed...
}
