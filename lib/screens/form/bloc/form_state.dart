part of 'form_bloc.dart';

abstract class FormPageState {
  const FormPageState();
}

class FormEditState extends FormPageState {
  final int id;
  final String name;

  const FormEditState({this.id, this.name});
}

class FormErrorState extends FormPageState {
  final String error;

  const FormErrorState({@required this.error});
}
