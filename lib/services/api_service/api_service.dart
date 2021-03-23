import 'package:dio/dio.dart';

import '../../data/database/moor_database.dart';
import '../../data/person/person.dart';
import '../../services/api_service/api_interface.dart';
import '../../app.dart';

class ApiService extends ApiInterface {
  // final String url = 'http://localhost:3000/people';
  final String url = 'https://maciej-maska-93.loca.lt/people';
  Dio dio = Dio();

  @override
  Future<List<User>> fetchData() async {
    Response response = await dio.get(url);
    final List<Person> persons = (response.data as List<dynamic>)
        .map((e) => Person.fromJson(e as Map<String, dynamic>))
        .toList();
    List<User> users = persons.map((user) => user.toEntity()).toList();

    App.appDatabase.userDao.insertAll(users);

    return users;
  }

  @override
  Future<void> insertUser({required int id, required String name}) async {
    await dio.post('$url', data: {'id': id, 'name': name, 'isFavorite': false});
  }

  @override
  Future<void> deleteUser({required int id}) async {
    await dio.delete('$url/$id');
  }

  @override
  Future<void> updateName({required int id, required String name}) async {
    await dio.patch('$url/$id', data: {'name': name});
  }

  @override
  Future<void> updateIsFavorite(
      {required int id, required bool isFavorite}) async {
    await dio.patch('$url/$id', data: {'isFavorite': isFavorite});
  }
}
