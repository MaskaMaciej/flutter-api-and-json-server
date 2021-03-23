import 'package:get_it/get_it.dart';

import '../services/api_service/api_interface.dart';
import '../services/api_service/api_service.dart';
import '../services/database_service/database_interface.dart';
import '../services/database_service/database_service.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerFactory<ApiInterface>(() => ApiService());
  locator.registerFactory<DatabaseInterface>(() => DatabaseService());
}
