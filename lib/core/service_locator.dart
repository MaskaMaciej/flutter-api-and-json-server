import 'package:api_and_json_server/services/api_service/api_interface.dart';
import 'package:api_and_json_server/services/api_service/api_service.dart';
import 'package:api_and_json_server/services/database_service/database_interface.dart';
import 'package:api_and_json_server/services/database_service/database_service.dart';
import 'package:get_it/get_it.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerFactory<ApiInterface>(() => ApiService());
  locator.registerFactory<DatabaseInterface>(() => DatabaseService());
  // locator.registerSingleton(DatabaseService());
  // locator.registerSingleton(ApiService());
}
