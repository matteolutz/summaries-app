import 'package:flutter/material.dart';

enum ExamType {
  classTest("Klassenarbeit", Colors.red),
  shortTest("Kurztest", Colors.orange),
  other("Andere", Colors.blue);

  final String _repr;
  final Color _color;

  const ExamType(this._repr, this._color);

  get repr => _repr;

  get color => _color;
}

class Exam {

  final ExamType _type;
  final String _name;
  final DateTime _dateTime;

  final List<String> _summaries;

  final String _createdBy;

  Exam(this._type, this._name, this._dateTime, this._summaries, this._createdBy);

  get type => _type;

  get name => _name;

  get dateTime => _dateTime;

  get summaries => _summaries;

  get createdBy => _createdBy;

  static Exam fromJson(Map<String, dynamic> json) {
    return Exam(
        ExamType.values[json["type"] as int],
        json["name"] as String,
        DateTime.parse(json["dateTime"] as String),
        json["summaries"].cast<String>(),
        json["createdBy"] as String
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "type": _type.index,
      "name": _name,
      "dateTime": _dateTime.toIso8601String(),
      "summaries": _summaries,
      "createdBy": _createdBy
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Exam &&
          runtimeType == other.runtimeType &&
          _type == other._type &&
          _name == other._name &&
          _dateTime == other._dateTime &&
          _summaries == other._summaries &&
          _createdBy == other._createdBy;

  @override
  int get hashCode => _type.hashCode ^ _name.hashCode ^ _dateTime.hashCode ^ _summaries.hashCode ^ _createdBy.hashCode;


}
