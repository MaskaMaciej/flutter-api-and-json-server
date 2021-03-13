part of 'moor_database.dart';

@UseDao(tables: [Users])
class UserDao extends DatabaseAccessor<AppDatabase> with _$UserDaoMixin {
  //TODO: Dont create redundant properties.
  final AppDatabase db;

  UserDao(this.db) : super(db);

  Future<List<User>> getAllUsers() => select(users).get();

  Future<List<User>> getSingleUser(int id) =>
      (select(users)..where((tbl) => tbl.id.equals(id))).get();

  Future<List<User>> getAlphabeticalUsers() => (select(users)
        ..orderBy([
          (tbl) => OrderingTerm(expression: tbl.name, mode: OrderingMode.asc)
        ]))
      .get();

  Future<List<User>> getFavoriteUsers() =>
      (select(users)..where((tbl) => tbl.isFavorite.equals(true))).get();

  Future<List<User>> getNotFavoriteUsers() =>
      (select(users)..where((tbl) => tbl.isFavorite.equals(false))).get();

  Stream<List<User>> watchAllUsers() => select(users).watch();

  Future insertUser(int id, String name) =>
      into(users).insert(UsersCompanion.insert(id: id, name: name));

  Future insertAll(List<User> user) async {
    await batch((batch) {
      batch.insertAll(
          users,
          user
              .map((user) => UsersCompanion.insert(
                  id: user.id,
                  name: user.name,
                  isFavorite: Value(user.isFavorite)))
              .toList(),
          mode: InsertMode.insertOrReplace);
    });
  }

  Future updateName(int id, String name) =>
      (update(users)..where((tbl) => tbl.id.equals(id)))
          .write(UsersCompanion(name: Value(name)));

  Future updateIsFavorite(int id, bool isFavorite) =>
      (update(users)..where((tbl) => tbl.id.equals(id)))
          .write(UsersCompanion(isFavorite: Value(isFavorite)));

  Future deleteUser(int id) =>
      (delete(users)..where((tbl) => tbl.id.equals(id))).go();

  Future<int> biggestId() async {
    return (await (select(users)
              ..orderBy([
                (tbl) =>
                    OrderingTerm(expression: tbl.id, mode: OrderingMode.desc)
              ])
              ..limit(1))
            .getSingle())
        .id;
  }
}
