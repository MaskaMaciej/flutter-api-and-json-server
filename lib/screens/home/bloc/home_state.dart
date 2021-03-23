part of 'home_bloc.dart';

abstract class HomeState {
  const HomeState();
}

class HomeLoadingState extends HomeState {
  const HomeLoadingState();
}

class HomeLoadedState extends HomeState {
  final List<User> users;

  const HomeLoadedState({required this.users});
}

class HomeErrorState extends HomeState {
  final String error;

  const HomeErrorState({required this.error});
}
