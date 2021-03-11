import 'package:api_and_json_server/data/database/moor_database.dart';
import 'package:json_annotation/json_annotation.dart';
part 'person.g.dart';

@JsonSerializable()
class Person {
  final int id;
  final String name;
  final bool isFavorite;

  Person({this.id, this.name, this.isFavorite});

  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);

  Map<String, dynamic> toJson() => _$PersonToJson(this);

  User toEntity() => User(id: id, name: name, isFavorite: isFavorite);
}
