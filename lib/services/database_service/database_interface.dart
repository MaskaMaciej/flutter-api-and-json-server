import 'package:api_and_json_server/data/database/moor_database.dart';

abstract class DatabaseInterface {
  Future<List<User>> getAllUsers();

  Future<List<User>> getSingleUser({required int id});

  Future<List<User>> getAlphabeticalUsers();

  Future<List<User>> getFavoriteUsers();

  Future<List<User>> getNotFavoriteUsers();

  Stream<List<User>> watchAllUsers();

  Future<void> insertUser({required int id, required String name});

  Future<void> deleteUser({required int id});

  Future<void> updateName({required int id, required String name});

  Future<void> updateIsFavorite({required int id, required bool isFavorite});

  Future<int> biggestId();
}
