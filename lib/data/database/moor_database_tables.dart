part of 'moor_database.dart';

//TODO: Wrong filename, it should be moor_database.dart
@UseMoor(tables: [Users], daos: [UserDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase()
      : super(FlutterQueryExecutor.inDatabaseFolder(
            path: 'db.sqlite', logStatements: true));

  @override
  int get schemaVersion => 1;
}
