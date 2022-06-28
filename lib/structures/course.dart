import 'dart:ui';

import 'exam.dart';

class Course {

  final String _name, _description;
  final Color _color;
  final List<String> _users;

  final List<Exam> _exams;

  Course(this._name, this._description, this._color, this._users, this._exams);

  get name => _name;
  get description => _description;
  get color => _color;
  get users => _users;
  get exams => _exams;

  static Course fromJson(Map<String, dynamic> json) {
    return Course(json['name'] as String, json['description'] as String, Color(json["color"] as int),
        json['users'].cast<String>(),
        json['exams'].map<Exam>((e) => Exam.fromJson(e)).toList()
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": _name,
      "description": _description,
      "color": _color.value,
      "users": _users,
      "exams": _exams.map((e) => e.toJson()).toList()
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Course &&
          runtimeType == other.runtimeType &&
          _name == other._name &&
          _description == other._description &&
          _color == other._color &&
          _users == other._users &&
          _exams == other._exams;

  @override
  int get hashCode => _name.hashCode ^ _description.hashCode ^ _color.hashCode ^ _users.hashCode ^ _exams.hashCode;

}
