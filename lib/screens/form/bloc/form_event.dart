part of 'form_bloc.dart';

abstract class FormEvent {
  const FormEvent();
}

class FormInsertOrUpdateUserEvent extends FormEvent {
  final int? id;
  final String? name;

  const FormInsertOrUpdateUserEvent({required this.id, required this.name});
}
