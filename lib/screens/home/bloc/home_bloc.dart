import 'dart:async';
import 'package:api_and_json_server/core/service_locator.dart';
import 'package:api_and_json_server/data/database/moor_database.dart';
import 'package:api_and_json_server/services/api_service/api_interface.dart';
import 'package:api_and_json_server/services/database_service/database_interface.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:dio/dio.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final apiService = locator.get<ApiInterface>();
  final databaseService = locator.get<DatabaseInterface>();

  HomeBloc() : super(HomeLoadingState());

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is HomeFetchDataEvent) {
      yield HomeLoadingState();
      try {
        yield HomeLoadedState(users: await apiService.fetchData());
      } on DioError {
        yield HomeLoadedState(users: await databaseService.getAllUsers());
        rethrow;
      } catch (e) {
        print(e.toString());
      }
    } else if (event is HomeRefreshDataEvent) {
      yield HomeLoadingState();
      var filter = _mapEnumToState(event.filter);
      yield HomeLoadedState(users: await filter());
    } else if (event is HomeGetSingleUserEvent) {
      yield HomeLoadedState(
          users: await databaseService.getSingleUser(id: event.id));
    } else if (event is HomeDeleteUserEvent) {
      await databaseService.deleteUser(id: event.id);
      yield HomeLoadedState(users: await databaseService.getAllUsers());
      apiService.deleteUser(id: event.id);
    } else if (event is HomeUpdateIsFavoriteEvent) {
      await databaseService.updateIsFavorite(
          id: event.id, isFavorite: event.isFavorite);
      yield HomeLoadedState(users: await databaseService.getAllUsers());
      apiService.updateIsFavorite(id: event.id, isFavorite: event.isFavorite);
    }
  }

  dynamic _mapEnumToState(expression) {
    // ignore: unused_local_variable
    var filter;
    switch (expression) {
      case RefreshEnum.all:
        return filter = databaseService.getAllUsers;
      case RefreshEnum.alphabetical:
        return filter = databaseService.getAlphabeticalUsers;
      case RefreshEnum.favorites:
        return filter = databaseService.getFavoriteUsers;
      case RefreshEnum.notFavorites:
        return filter = databaseService.getNotFavoriteUsers;
      default:
        return filter = databaseService.getAllUsers;
    }
  }
}
