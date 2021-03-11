import 'package:moor_flutter/moor_flutter.dart';

part 'moor_database_tables.dart';
part 'moor_database_daos.dart';
part 'moor_database.g.dart';

class Users extends Table {
  IntColumn get id => integer().customConstraint('UNIQUE')();
  TextColumn get name => text().withLength(min: 3)();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
}
