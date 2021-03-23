import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/service_locator.dart';
import '../../../services/api_service/api_interface.dart';
import '../../../services/database_service/database_interface.dart';

part 'form_event.dart';
part 'form_state.dart';

class FormBloc extends Bloc<FormEvent, FormPageState> {
  FormBloc() : super(FormInitialState());

  @override
  Stream<FormPageState> mapEventToState(FormEvent event) async* {
    if (event is FormInsertOrUpdateUserEvent && event.name != null) {
      final databaseService = locator.get<DatabaseInterface>();
      final apiService = locator.get<ApiInterface>();

      final bool isInsert = event.id == null;
      final int id = isInsert ? await databaseService.biggestId() : event.id!;
      final String name = event.name!;
      if (isInsert) {
        await databaseService.insertUser(id: id, name: name);
      } else {
        await databaseService.updateName(id: id, name: name);
      }
      try {
        if (isInsert) {
          await apiService.insertUser(id: id, name: name);
        } else {
          await apiService.updateName(id: id, name: name);
        }
      } on DioError catch (_) {
        print('API is currently unavailable.');
      } catch (e) {
        print(e.toString());
      }
      yield FormSuccessState(name: name);
    } else {
      yield FormErrorState(error: 'Name cannot be empty.');
    }
  }
}
