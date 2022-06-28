import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:summaries/pages/new_exam.dart';
import 'package:summaries/structures/exam_with_course_ref.dart';

import './exam_overview.dart';
import '../structures/exam.dart';
import '../widgets/modalbottomsheet.dart';

class DayOverviewPage extends StatefulWidget {
  final DateTime selectedDay;
  final List<ExamWithCourseRef> exams;

  const DayOverviewPage({Key? key, required this.selectedDay, required this.exams})
      : super(key: key);

  @override
  State<DayOverviewPage> createState() => _DayOverviewPageState();
}

class _DayOverviewPageState extends State<DayOverviewPage> {
  static final DateFormat _dayDateFormat = DateFormat("E, dd.MM.yyyy", "de_DE");
  static final DateFormat _timeDateFormat = DateFormat("HH:mm", "de_DE");

  @override
  Widget build(BuildContext context) {

    return ModalBottomSheetWidget(
        title: _dayDateFormat.format(widget.selectedDay),
        child: ListView(
                  children: [
                    widget.exams.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(child: Text("Keine Prüfungen an diesem Tag.", style: TextStyle(fontSize: 20, color: Colors.grey), textAlign: TextAlign.center)),)
                    : ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.exams.length,
                      itemBuilder: (context, index) => ListTile(
                        title: Text(widget.exams[index].exam.name),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(widget.exams[index].exam.type.repr,
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: widget.exams[index].exam.type.color)),
                            Text(widget.exams[index].exam.summaries.length.toString(),
                                style: const TextStyle(color: Colors.green)),
                            Text(_timeDateFormat
                                .format(widget.exams[index].exam.dateTime)),
                          ],
                        ),
                        leading: const Icon(Icons.event),

                        // on tap: go to overview
                        onTap: () => showModalBottomSheet(
                            context: context,
                            builder: (context) =>
                                ExamOverviewPage(exam: widget.exams[index]),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                            ),
                        ),

                        // on long press: shortcut for directly adding summary
                        onLongPress: () {},
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    ListTile(
                      title: const Text("Prüfung hinzufügen"),
                      leading: const Icon(Icons.add, color: Colors.green),
                      onTap: () =>
                          Navigator.push(context, MaterialPageRoute(builder: (context) => NewExamPage(selectedDay: widget.selectedDay))),
                    ),
                  ]
                )

    );
  }
}
