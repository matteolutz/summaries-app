import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:summaries/structures/core_state.dart';
import 'package:summaries/structures/exam.dart';
import 'package:summaries/structures/future_option.dart';
import 'package:summaries/structures/result.dart';
import 'package:summaries/structures/user.dart';
import 'package:summaries/util/db.dart';
import 'package:table_calendar/table_calendar.dart';

import '../structures/course.dart';
import '../structures/option.dart';

class StateWidget extends StatefulWidget {

  final Widget child;
  const StateWidget({Key? key, required this.child}) : super(key: key);

  @override
  State<StateWidget> createState() => _StateWidgetState();
}

class _StateWidgetState extends State<StateWidget> {
  CoreState state = const CoreState();

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((fbUser) async {
      if(fbUser == null) {
        final newState = state.copy(user: const FutureOption.none());
        setState(() {
          state = newState;
        });
      } else {
        final newState = state.copy(user: FutureOption.some((await SummariesDB.getUser(fbUser.uid)).data()!));
        setState(() {
          state = newState;
        });
        fetchUserCourses();
      }
    });

    SummariesDB.coursesRef.snapshots().listen((_) => fetchUserCourses());
  }

  // region Auth Methods
  Future<Result<void, FirebaseAuthException>> loginWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential c = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return Result.success(null);
    } on FirebaseAuthException catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void, dynamic>> registerWithEmailAndPassword(
      String email, String password, String username) async {
    try {
      UserCredential c = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      if(c.user == null) throw "user-is-null";
      if(c.user!.email == null) throw "user-email-is-null";

      SummariesUser u = SummariesUser(username, c.user!.uid, c.user!.email!, SummariesUserRole.user, []);
      SummariesDB.setUserData(u);
      return Result.success(null);
    } catch (e) {
      return Result.error(e);
    }
  }

  Future<void> addFavouriteSummary(String summaryId) async {
    if (state.user.isNone) {
      throw Exception("User not logged in");
    }
    await SummariesDB.userAddFavouriteSummary(state.user.unwrap().uid, summaryId);
    final newState = state.copy(user: FutureOption.some((await SummariesDB.getUser(state.user.unwrap().uid)).data()!));
    setState(() => state = newState);
  }

  Future<void> removeFavouriteSummary(String summaryId) async {
    if (state.user.isNone) {
      throw Exception("User not logged in");
    }
    await SummariesDB.userRemoveFavouriteSummary(state.user.unwrap().uid, summaryId);
    final newState = state.copy(user: FutureOption.some((await SummariesDB.getUser(state.user.unwrap().uid)).data()!));
    setState(() => state = newState);
  }

  bool isFavouriteSummary(String summaryId) {
    if (state.user.isNone) {
      throw Exception("User not logged in");
    }
    return state.user.unwrap().favouriteSummaries.contains(summaryId);
  }

  Future<void> logout() async {
    if(state.user.isNone) {
      return;
    }

    setState(() {
      state = state.copy(user: const FutureOption.loading());
    });

    return FirebaseAuth.instance.signOut();
  }

  Future<void> deleteAccount() async {
    if(state.user.isNone) {
      throw Exception("User not logged in");
    }

    setState(() {
      state = state.copy(user: const FutureOption.loading());
    });

    await SummariesDB.deleteUser(state.user.unwrap().uid);
    await FirebaseAuth.instance.currentUser!.delete();
    logout();
  }
  // endregion

  Future<void> fetchUserCourses() async {
    if(state.user.isNone) return;

    List<DocumentSnapshot<Course>> userCourses = (await SummariesDB.getCoursesForUser(state.user.unwrap().uid)).docs.cast<DocumentSnapshot<Course>>();
    final newState = state.copy(courses: userCourses);
    setState(() {
      state = newState;
    });
  }

  Course getCourseById(String id) {
    return state.courses.firstWhere((element) => element.id == id).data()!;
  }

  @override
  Widget build(BuildContext context) {
    return StateInheritedWidget(
      state: state,
      stateWidget: this,
      child: widget.child,
    );
  }
}


class StateInheritedWidget extends InheritedWidget {

  final CoreState state;
  final _StateWidgetState stateWidget;
  StateInheritedWidget({required super.child, required this.state, required this.stateWidget});

  static _StateWidgetState of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<StateInheritedWidget>()!.stateWidget;

  @override
  bool updateShouldNotify(StateInheritedWidget oldWidget) {
    return oldWidget.state != state;
  }

}