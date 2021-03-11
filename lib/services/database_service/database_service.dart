import 'package:api_and_json_server/data/database/moor_database.dart';
import 'package:api_and_json_server/services/database_service/database_interface.dart';
import 'package:flutter/foundation.dart';
import '../../app.dart';

class DatabaseService extends DatabaseInterface {
  Future<List<User>> getAllUsers() {
    return App.appDatabase.userDao.getAllUsers();
  }

  Future<List<User>> getSingleUser({@required int id}) async {
    return App.appDatabase.userDao.getSingleUser(id);
  }

  Future<List<User>> getAlphabeticalUsers() {
    return App.appDatabase.userDao.getAlphabeticalUsers();
  }

  Future<List<User>> getFavoriteUsers() {
    return App.appDatabase.userDao.getFavoriteUsers();
  }

  Future<List<User>> getNotFavoriteUsers() {
    return App.appDatabase.userDao.getNotFavoriteUsers();
  }

  Stream<List<User>> watchAllUsers() {
    return App.appDatabase.userDao.watchAllUsers();
  }

  Future<void> insertUser({@required int id, @required String name}) async {
    await App.appDatabase.userDao.insertUser(id, name);
  }

  Future<void> deleteUser({@required int id}) async {
    await App.appDatabase.userDao.deleteUser(id);
  }

  Future<void> updateName({@required int id, @required String name}) async {
    await App.appDatabase.userDao.updateName(id, name);
  }

  Future<void> updateIsFavorite(
      {@required int id, @required bool isFavorite}) async {
    await App.appDatabase.userDao.updateIsFavorite(id, isFavorite);
  }

  Future<int> biggestId() async {
    try {
      return await App.appDatabase.userDao.biggestId() + 1;
    } catch (e) {
      return 1;
    }
  }
}
