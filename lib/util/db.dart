import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:summaries/structures/summary.dart';
import 'package:summaries/util/state.dart';
import 'package:table_calendar/table_calendar.dart';

import '../structures/course.dart';
import '../structures/exam.dart';
import '../structures/user.dart';

class SummariesDB {
  static final summariesRef = FirebaseFirestore.instance
      .collection("summaries")
      .withConverter(
          fromFirestore: (snapshots, _) => Summary.fromJson(snapshots),
          toFirestore: (summary, _) => summary.toJson());

  static final coursesRef = FirebaseFirestore.instance
      .collection("courses")
      .withConverter(fromFirestore: (snapshots, _) => Course.fromJson(snapshots.data()!), toFirestore: (course, _) => course.toJson());

  static final usersRef = FirebaseFirestore.instance
      .collection("users")
      .withConverter(
          fromFirestore: (snapshots, _) =>
              SummariesUser.fromJson(snapshots.data()!),
          toFirestore: (user, _) => user.toJson());

  static Future<DocumentSnapshot<Summary>> getSummary(String summaryId) async {
    return summariesRef.doc(summaryId).get();
  }

  static Future<QuerySnapshot<Course>> getCoursesForUser(String uid) {
    return coursesRef.where("users", arrayContains: uid).get();
  }

  static Future<void> addExam(String courseId, Exam exam) async {
    await coursesRef.doc(courseId).update({"exams": FieldValue.arrayUnion([exam.toJson()])});
  }

  static Future<void> deleteExam(String courseId, Exam exam) async {
    await coursesRef.doc(courseId).update({"exams": FieldValue.arrayRemove([exam.toJson()])});
  }

  static Future<void> setUserData(SummariesUser user) async {
    return usersRef.doc(user.uid).set(user);
  }

  static Future<DocumentSnapshot<SummariesUser>> getUser(String uid) async {
    return usersRef.doc(uid).get();
  }

  static Future<void> deleteUser(String uid) async {
    return usersRef.doc(uid).delete();
  }

  static Future<void> userAddFavouriteSummary(String uid, String summaryId) async {
    return usersRef.doc(uid).update({
      "favouriteSummaries": FieldValue.arrayUnion([summaryId])
    });
  }

  static Future<void> userRemoveFavouriteSummary(String uid, String summaryId) async {
    return usersRef.doc(uid).update({
      "favouriteSummaries": FieldValue.arrayRemove([summaryId])
    });
  }

}
