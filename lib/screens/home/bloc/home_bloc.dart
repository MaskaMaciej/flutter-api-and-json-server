import 'dart:async';
import 'package:dio/dio.dart';

import '../../../core/service_locator.dart';
import '../../../data/database/moor_database.dart';
import '../../../services/api_service/api_interface.dart';
import '../../../services/database_service/database_interface.dart';
import 'package:bloc/bloc.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeLoadingState());

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is HomeFetchDataEvent) {
      yield HomeLoadingState();
      try {
        final apiService = locator.get<ApiInterface>();
        yield HomeLoadedState(users: await apiService.fetchData());
      } on DioError catch (_) {
        final databaseService = locator.get<DatabaseInterface>();
        yield HomeLoadedState(users: await databaseService.getAllUsers());
        print('API is currently unavailable.');
      } catch (e) {
        print(e.toString());
      }
    } else if (event is HomeRefreshDataEvent) {
      yield HomeLoadingState();
      var filter = _mapEnumToFilterFunction(event.filter);
      yield HomeLoadedState(users: await filter());
    } else if (event is HomeGetSingleUserEvent) {
      final databaseService = locator.get<DatabaseInterface>();
      yield HomeLoadedState(
          users: await databaseService.getSingleUser(id: event.id));
    } else if (event is HomeDeleteUserEvent) {
      final databaseService = locator.get<DatabaseInterface>();
      await databaseService.deleteUser(id: event.id);
      yield HomeLoadedState(users: await databaseService.getAllUsers());
      try {
        final apiService = locator.get<ApiInterface>();
        await apiService.deleteUser(id: event.id);
      } on DioError catch (_) {
        print('API is currently unavailable.');
      } catch (e) {
        print(e.toString());
      }
    } else if (event is HomeUpdateIsFavoriteEvent) {
      final databaseService = locator.get<DatabaseInterface>();
      await databaseService.updateIsFavorite(
          id: event.id, isFavorite: event.isFavorite);
      yield HomeLoadedState(users: await databaseService.getAllUsers());
      try {
        final apiService = locator.get<ApiInterface>();
        await apiService.updateIsFavorite(
            id: event.id, isFavorite: event.isFavorite);
      } on DioError catch (_) {
        print('API is currently unavailable.');
      } catch (e) {
        print(e.toString());
      }
    }
  }

  Future<List<User>> Function() _mapEnumToFilterFunction(
      RefreshEnum enumValue) {
    final databaseService = locator.get<DatabaseInterface>();
    switch (enumValue) {
      case RefreshEnum.all:
        return databaseService.getAllUsers;
      case RefreshEnum.alphabetical:
        return databaseService.getAlphabeticalUsers;
      case RefreshEnum.favorites:
        return databaseService.getFavoriteUsers;
      case RefreshEnum.notFavorites:
        return databaseService.getNotFavoriteUsers;
      default:
        return databaseService.getAllUsers;
    }
  }
}
