import '../../data/database/moor_database.dart';

abstract class ApiInterface {
  Future<List<User>> fetchData();

  Future<void> insertUser({required int id, required String name});

  Future<void> deleteUser({required int id});

  Future<void> updateName({required int id, required String name});

  Future<void> updateIsFavorite({required int id, required bool isFavorite});
}
