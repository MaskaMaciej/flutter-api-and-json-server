import 'package:json_annotation/json_annotation.dart';

import '../database/moor_database.dart';

part 'person.g.dart';

@JsonSerializable()
class Person {
  final int id;
  final String name;
  final bool isFavorite;

  const Person({required this.id, required this.name, required this.isFavorite});

  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);

  Map<String, dynamic> toJson() => _$PersonToJson(this);

  User toEntity() => User(id: id, name: name, isFavorite: isFavorite);
}
