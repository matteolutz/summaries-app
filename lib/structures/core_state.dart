import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:summaries/structures/course.dart';
import 'package:summaries/structures/future_option.dart';
import 'package:summaries/structures/user.dart';

class CoreState {

  final FutureOption<SummariesUser> user;
  final List<DocumentSnapshot<Course>> courses;

  const CoreState({
    this.user = const FutureOption.loading(),
    this.courses = const [],
  });

  CoreState copy({
    FutureOption<SummariesUser>? user,
    List<DocumentSnapshot<Course>>? courses,
  }) => CoreState(
    user: user ?? this.user,
    courses: courses ?? this.courses,
  );

  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
    other is CoreState &&
      runtimeType == other.runtimeType &&
      user == other.user &&
      courses == other.courses;

  @override
  int get hashCode => user.hashCode ^ courses.hashCode;




}