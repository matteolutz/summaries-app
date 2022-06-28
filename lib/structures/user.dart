import 'package:flutter/material.dart';

enum SummariesUserRole {
  admin("Administrator", Colors.red),
  user("Benutzer", Colors.blue);

  final String _repr;
  final Color _color;

  const SummariesUserRole(this._repr, this._color);

  get repr => _repr;

  get color => _color;
}

class SummariesUser {
  final String _name, _uid, _email;
  final SummariesUserRole _role;
  final List<String> _favouriteSummaries;

  SummariesUser(this._name, this._uid, this._email, this._role, this._favouriteSummaries);

  get name => _name;

  get uid => _uid;

  get email => _email;

  get role => _role;

  get favouriteSummaries => _favouriteSummaries;

  static SummariesUser fromJson(Map<String, dynamic> json) {
    return SummariesUser(
      json['name'] as String,
      json['uid'] as String,
      json["email"] as String,
      SummariesUserRole.values[json['role'] as int],
      json['favouriteSummaries'].cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': _name,
      'uid': _uid,
      "email": _email,
      'role': _role.index,
      'favouriteSummaries': _favouriteSummaries,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) &&
      other is SummariesUser &&
      runtimeType == other.runtimeType &&
      _name == other._name &&
      _uid == other._uid &&
      _email == other._email &&
      _role == other._role &&
      _favouriteSummaries == other._favouriteSummaries;

  @override
  int get hashCode =>
      _name.hashCode ^
      _uid.hashCode ^
      _email.hashCode ^
      _role.hashCode ^
      _favouriteSummaries.hashCode;

}
