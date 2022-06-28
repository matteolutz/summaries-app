import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:summaries/structures/course.dart';
import 'package:summaries/structures/exam.dart';

class ExamWithCourseRef {
  final Exam _exam;
  final DocumentSnapshot<Course> _course;

  ExamWithCourseRef(this._exam, this._course);

  Exam get exam => _exam;
  DocumentSnapshot<Course> get course => _course;
}