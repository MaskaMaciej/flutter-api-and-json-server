import 'package:api_and_json_server/services/api_service/api_interface.dart';
import 'package:api_and_json_server/services/database_service/database_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'form_event.dart';
part 'form_state.dart';

class FormBloc extends Bloc<FormEvent, FormPageState> {
  final ApiInterface apiService;
  final DatabaseInterface databaseService;

  FormBloc({@required this.apiService, @required this.databaseService})
      : super(FormEditState());

  @override
  Stream<FormPageState> mapEventToState(FormEvent event) async* {
    if (event is FormInsertUserEvent) {
      int biggestId = await databaseService.biggestId();
      await databaseService.insertUser(id: biggestId, name: event.name);
      await databaseService.getAllUsers();
      apiService.insertUser(id: biggestId, name: event.name);
    } else if (event is FormUpdateNameEvent) {
      await databaseService.updateName(id: event.id, name: event.name);
      await databaseService.getAllUsers();
      apiService.updateName(id: event.id, name: event.name);
    }
  }
}
