import 'package:cloud_firestore/cloud_firestore.dart';

class Summary {

  final String _id;
  final String _name, _description;
  final Uri _url;

  Summary(this._id, this._name, this._description, this._url);

  get id => _id;
  get name => _name;

  get description => _description;

  get url => _url;

  static Summary fromJson(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic> json = snapshot.data()!;
    return Summary(
      snapshot.id,
      json['name'] as String,
      json['description'] as String,
      Uri.parse(json['url'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': _name,
      'description': _description,
      'url': _url.toString(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Summary &&
          runtimeType == other.runtimeType &&
          _id == other._id &&
          _name == other._name &&
          _description == other._description &&
          _url == other._url;

  @override
  int get hashCode => _id.hashCode ^ _name.hashCode ^ _description.hashCode ^ _url.hashCode;


}
