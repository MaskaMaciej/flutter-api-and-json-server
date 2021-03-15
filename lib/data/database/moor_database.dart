import 'package:moor_flutter/moor_flutter.dart';

part 'moor_database_tables.dart';
part 'moor_database_daos.dart';
part 'moor_database.g.dart';

//TODO: Wrong filename, it should be moor_database_tables.dart
class Users extends Table {
  IntColumn get id => integer().customConstraint('UNIQUE')();
  TextColumn get name => text().withLength(min: 3)();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();

  //TODO: Override primary key here and use id. After that you can remove UNIQUE constraint.
}
