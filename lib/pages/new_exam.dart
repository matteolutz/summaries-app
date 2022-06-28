import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:summaries/structures/exam.dart';
import 'package:summaries/util/date.dart';
import 'package:summaries/util/db.dart';
import 'package:summaries/util/state.dart';
import 'package:summaries/widgets/listcard.dart';

import '../structures/course.dart';

class NewExamPage extends StatefulWidget {

  final DateTime? selectedDay;
  const NewExamPage({Key? key, this.selectedDay}) : super(key: key);

  @override
  State<NewExamPage> createState() => _NewExamPageState();
}

class _NewExamPageState extends State<NewExamPage> {

  static final DateFormat _dayDateFormat = DateFormat("E, dd.MM.yyyy", "de_DE");
  static final DateFormat _timeDateFormat = DateFormat("HH:mm", "de_DE");

  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  ExamType? _examType;
  String? _course;

  final _formKey = GlobalKey<FormState>();

  Future<void> _openDatePicker() async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: now.subtract(const Duration(days: 365)),
        lastDate: now.add(const Duration(days: 365)),
        locale: const Locale("de", "DE")
    );

    if(picked == null) return;

    setState(() => _date = picked);
  }

  Future<void> _openTimePicker() async {
    final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: _time,
    );

    if(picked == null) return;

    setState(() => _time = picked);
  }

  DateTime _timeOfDayToDateTime(TimeOfDay time) {
    return DateTime(
        _date.year,
        _date.month,
        _date.day,
        time.hour,
        time.minute
    );
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _date = widget.selectedDay ?? DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Neue Prüfung"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            ListCardWidget(
              title: const Text("Name und Beschreibung", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Name",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if(value == null || value.isEmpty) return "Bitte gib der Prüfung einen Namen";
                        return null;
                      },
                      controller: _nameController,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      maxLines: 8,
                      decoration: const InputDecoration(
                        labelText: "Beschreibung",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if(value == null || value.isEmpty) return "Bitte beschreibe die Prüfung kurz";
                        return null;
                      },
                      controller: _descriptionController,
                    ),
                  ],
                ),
              ),
            ),
            ListCardWidget(
              title: const Text("Prüfungstyp", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: DropdownButtonFormField(
                  items: const [
                    DropdownMenuItem(
                      value: ExamType.classTest,
                      child: Text("Klassenarbeit"),
                    ),
                    DropdownMenuItem(
                      value: ExamType.shortTest,
                      child: Text("Kurztest"),
                    ),
                    DropdownMenuItem(
                      value: ExamType.other,
                      child: Text("Andere"),
                    ),
                  ],
                  onChanged: (ExamType? value) => setState(() => _examType = value),
                  validator: (value) {
                    if(value == null) return "Bitte gib einen Prüfungstyp an";
                    return null;
                  },
                ),
              )
            ),
            ListCardWidget(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Datum und Uhrzeit", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text("Tippen, um zu ändern", style: TextStyle(color: Colors.grey, fontSize: 14))
                  ],
                ),
                leading: const Icon(Icons.access_time),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(onPressed: () => _openDatePicker(), child: Text(_dayDateFormat.format(_date))),
                      TextButton(onPressed: () => _openTimePicker(), child: Text(_timeDateFormat.format(_timeOfDayToDateTime(_time)))),
                    ],
                  ),
                )
            ),
            ListCardWidget(
                title: const Text("Kurs", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: DropdownButtonFormField<String>(
                    items: StateInheritedWidget.of(context).state.courses.map((c) => DropdownMenuItem<String>(
                      value: c.id,
                      child: Text(c.data()!.name),
                    )).toList(),
                    onChanged: (String? value) => setState(() => _course = value),
                    validator: (value) {
                      if(value == null) return "Bitte gib einen Prüfungstyp an";
                      return null;
                    },
                  ),
                )
            ),
            ElevatedButton(
                onPressed: () {
                  if(!_formKey.currentState!.validate()) {
                    return;
                  }

                  final examDateTime = _date.copyWith(
                    hour: _time.hour,
                    minute: _time.minute,
                    second: 0,
                    millisecond: 0,
                  );

                  Exam e = Exam(_examType!, _nameController.text, examDateTime, [], StateInheritedWidget.of(context).state.user.unwrap().uid);
                  SummariesDB.addExam(_course!, e)
                    .then((_) {
                      StateInheritedWidget.of(context).fetchUserCourses();
                      Navigator.pop(context);
                  });
                },
                child: const Text("Prüfung erstellen"),
            )
          ],
        ),
      ),
    );
  }
}
