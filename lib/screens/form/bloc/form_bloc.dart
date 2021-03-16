import 'package:api_and_json_server/core/service_locator.dart';
import 'package:api_and_json_server/services/api_service/api_interface.dart';
import 'package:api_and_json_server/services/database_service/database_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'form_event.dart';
part 'form_state.dart';

class FormBloc extends Bloc<FormEvent, FormPageState> {
  FormBloc() : super(FormEditState());

  @override
  Stream<FormPageState> mapEventToState(FormEvent event) async* {
    if (event is FormInsertUserEvent) {
      final apiService = locator.get<ApiInterface>();
      final databaseService = locator.get<DatabaseInterface>();
      int biggestId = await databaseService.biggestId();
      await databaseService.insertUser(id: biggestId, name: event.name);
      await databaseService.getAllUsers();
      apiService.insertUser(id: biggestId, name: event.name);
    } else if (event is FormUpdateNameEvent) {
      final apiService = locator.get<ApiInterface>();
      final databaseService = locator.get<DatabaseInterface>();
      await databaseService.updateName(id: event.id, name: event.name);
      await databaseService.getAllUsers();
      apiService.updateName(id: event.id, name: event.name);
    }
  }
}
