import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:summaries/structures/exam_with_course_ref.dart';
import 'package:table_calendar/table_calendar.dart';

import '../structures/course.dart';
import '../util/state.dart';
import './day_overview.dart';
import '../structures/exam.dart';
import '../util/db.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();

  void _daySelected(DateTime selectedDay, DateTime focusedDay) {
    showModalBottomSheet(
        context: context,
        builder: (context) => DayOverviewPage(
            selectedDay: selectedDay,
            exams: _eventLoader(selectedDay)
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
    );

    if (isSameDay(selectedDay, _selectedDay)) return;

    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
  }

  List<ExamWithCourseRef> _eventLoader(DateTime day) {
    return StateInheritedWidget.of(context).state.courses
        .map<List<ExamWithCourseRef>>((c) => c.data()!.exams.map<ExamWithCourseRef>((e) => ExamWithCourseRef(e, c)).toList())
        .expand<ExamWithCourseRef>((e) => e)
        .where((e) => isSameDay(e.exam.dateTime, day))
        .toList();
  }

  @override
  Widget build(BuildContext context) {

    return ListView(children: [
      TableCalendar(
        firstDay: DateTime.now().subtract(const Duration(days: 365)),
        lastDay: DateTime.now().add(const Duration(days: 365)),
        focusedDay: _focusedDay,
        locale: 'de_DE',
        onDaySelected: _daySelected,
        selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
        onPageChanged: (DateTime focusedDay) => _focusedDay = focusedDay,
        startingDayOfWeek: StartingDayOfWeek.monday,
        eventLoader: _eventLoader,
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            shape: BoxShape.circle,
          ),
          markerDecoration: const BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
        ),
        availableCalendarFormats: const {
          CalendarFormat.month: 'Monat',
          CalendarFormat.twoWeeks: '2 Wochen',
          CalendarFormat.week: 'Woche',
        },
      ),
    ]);
  }
}
