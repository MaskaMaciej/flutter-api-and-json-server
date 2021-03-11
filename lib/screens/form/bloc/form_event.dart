part of 'form_bloc.dart';

abstract class FormEvent {
  const FormEvent();
}

class FormInsertUserEvent extends FormEvent {
  final int id;
  final String name;

  const FormInsertUserEvent({@required this.id, @required this.name});
}

class FormUpdateNameEvent extends FormEvent {
  final int id;
  final String name;

  const FormUpdateNameEvent({@required this.id, @required this.name});
}
