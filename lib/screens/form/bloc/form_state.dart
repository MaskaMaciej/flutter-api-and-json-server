part of 'form_bloc.dart';

abstract class FormPageState {
  const FormPageState();
}

class FormInitialState extends FormPageState {
  const FormInitialState();
}

class FormSuccessState extends FormPageState {
  final String name;

  const FormSuccessState({required this.name});
}

class FormErrorState extends FormPageState {
  final String error;

  const FormErrorState({required this.error});
}
