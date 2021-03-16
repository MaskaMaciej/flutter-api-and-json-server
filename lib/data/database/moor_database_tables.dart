part of 'moor_database.dart';

class Users extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text().withLength(min: 3)();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
