import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:summaries/pages/summary.dart';
import 'package:summaries/structures/exam_with_course_ref.dart';
import 'package:summaries/structures/summary.dart';
import 'package:summaries/structures/user.dart';
import 'package:summaries/util/db.dart';
import 'package:summaries/util/list.dart';

import '../structures/exam.dart';
import '../util/state.dart';
import '../widgets/modalbottomsheet.dart';

class ExamOverviewPage extends StatefulWidget {
  final ExamWithCourseRef exam;

  const ExamOverviewPage({Key? key, required this.exam}) : super(key: key);

  @override
  State<ExamOverviewPage> createState() => _ExamOverviewPageState();
}

class _ExamOverviewPageState extends State<ExamOverviewPage> {
  static final DateFormat _dayDateFormat =
      DateFormat("dd.MM.yyyy, HH:mm", "de_DE");

  List<DocumentSnapshot<Summary>>? _summaries;

  @override
  Widget build(BuildContext context) {
    if (_summaries == null) {
      Future.wait(widget.exam.exam
              .summaries
              .map<Future<DocumentSnapshot<Summary>>>(
                  (sum) async => await SummariesDB.getSummary(sum))
              .toList())
          .then((summaries) => setState(() => _summaries = summaries.cast<DocumentSnapshot<Summary>>()));
    }

    return ModalBottomSheetWidget(
        title: _summaries == null
            ? "Lade Übersicht..."
            : "${widget.exam.exam.name}, ${_dayDateFormat.format(widget.exam.exam.dateTime)}",
        child: _summaries == null
            ? const Center(child: CircularProgressIndicator())
            : ListView(
              children: [
                _summaries!.isEmpty ?
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: Text("Keine Zusammenfassungen für diese Prüfung.", style: TextStyle(fontSize: 20, color: Colors.grey), textAlign: TextAlign.center)),
                ) :
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: _summaries!.length,
                  itemBuilder: (context, index) => ListTile(
                      title: Text(_summaries![index].data()!.name),
                      subtitle: Text(
                        _summaries![index].data()!.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                      leading: const Icon(Icons.description),
                      trailing: IconButton(
                          onPressed: () async {
                            if(StateInheritedWidget.of(context).isFavouriteSummary(_summaries![index].id)) {
                              await StateInheritedWidget.of(context).removeFavouriteSummary(_summaries![index].id);
                            } else {
                              await StateInheritedWidget.of(context).addFavouriteSummary(_summaries![index].id);
                            }
                            setState(() {});
                          },
                          icon: StateInheritedWidget.of(context).isFavouriteSummary(_summaries![index].id)
                              ? const Icon(Icons.favorite, color: Colors.red)
                              : const Icon(Icons.favorite_border)
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewSummaryPage(
                                    summary: _summaries![index].data()!)));
                      }),
                ),
                const SizedBox(height: 24.0),
                ListTile(
                  title: const Text("Zusammenfassung hinzufügen"),
                  leading: const Icon(Icons.add, color: Colors.green),
                  onTap: () {},
                ),
                widget.exam.exam.createdBy == StateInheritedWidget.of(context).state.user.unwrap().uid || StateInheritedWidget.of(context).state.user.unwrap().role == SummariesUserRole.admin ?
                  ListTile(
                    title: const Text("Prüfung löschen"),
                    leading: const Icon(Icons.delete, color: Colors.red),
                    onTap: () {
                      SummariesDB.deleteExam(widget.exam.course.id, widget.exam.exam)
                        .then((_) {
                          StateInheritedWidget.of(context).fetchUserCourses();
                          Navigator.pop(context);
                        });
                      }
                  )
                 : null
          ].notNulls().cast<Widget>(),
        )
    );
  }
}
