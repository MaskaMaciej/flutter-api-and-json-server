import 'package:moor_flutter/moor_flutter.dart';

part 'moor_database_tables.dart';
part 'moor_database_daos.dart';
part 'moor_database.g.dart';

@UseMoor(tables: [Users], daos: [UserDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase()
      : super(FlutterQueryExecutor.inDatabaseFolder(
            path: 'db.sqlite', logStatements: true));

  @override
  int get schemaVersion => 1;
}
