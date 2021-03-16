part of 'home_bloc.dart';

abstract class HomeEvent {
  const HomeEvent();
}

class HomeFetchDataEvent extends HomeEvent {
  const HomeFetchDataEvent();
}

enum RefreshEnum { all, alphabetical, favorites, notFavorites }

class HomeRefreshDataEvent extends HomeEvent {
  final RefreshEnum filter;
  const HomeRefreshDataEvent({@required this.filter});
}

class HomeGetSingleUserEvent extends HomeEvent {
  final int id;

  const HomeGetSingleUserEvent({@required this.id});
}

class HomeInsertUserEvent extends HomeEvent {
  final int id;
  final String name;

  const HomeInsertUserEvent({@required this.id, @required this.name});
}

class HomeDeleteUserEvent extends HomeEvent {
  final int id;

  const HomeDeleteUserEvent({@required this.id});
}

class HomeUpdateNameEvent extends HomeEvent {
  final int id;
  final String name;

  const HomeUpdateNameEvent({@required this.id, @required this.name});
}

class HomeUpdateIsFavoriteEvent extends HomeEvent {
  final int id;
  final bool isFavorite;

  const HomeUpdateIsFavoriteEvent(
      {@required this.id, @required this.isFavorite});
}
