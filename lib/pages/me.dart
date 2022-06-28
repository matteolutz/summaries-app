import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:summaries/pages/summary.dart';
import 'package:summaries/util/state.dart';
import 'package:summaries/util/db.dart';
import 'package:summaries/widgets/listcard.dart';

import '../structures/summary.dart';

class MePage extends StatefulWidget {
  const MePage({Key? key}) : super(key: key);

  @override
  State<MePage> createState() => _MePageState();
}

class _MePageState extends State<MePage> {
  List<DocumentSnapshot<Summary>>? _favouriteSummaries;

  Future<void> _logout() async {
    await StateInheritedWidget.of(context).logout();
  }

  Future<void> _deleteAccount() async {
    showDialog(
        context: context,
        builder: (context) => Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.5,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text("Willst du deinen Account wirklich löschen?",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center),
                        const Text(
                            "Alle deine persönlichen Daten (Zusammenfassungen, Bewertungen, Kommentare, etc.) werden unwiderruflich gelöscht werden!",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                            textAlign: TextAlign.center),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.delete),
                          label: const Text("Ja, Account löschen"),
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.red)),
                          onPressed: () async {
                            Navigator.of(context).pop();
                            await StateInheritedWidget.of(context).deleteAccount();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    if (_favouriteSummaries == null) {
      Future.wait(
          StateInheritedWidget.of(context).state.user.unwrap().favouriteSummaries.map((id) async => await SummariesDB.getSummary(id)).toList().cast<Future<DocumentSnapshot<Summary>>>()
      )
      .then((summaries) => setState(() => _favouriteSummaries = summaries.cast<DocumentSnapshot<Summary>>()));
    }

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        ListCardWidget(
          title: const Text("Profil",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          leading: const Icon(Icons.account_circle_outlined),
          child: ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                title: const Text("Benutzername"),
                subtitle: Text("${StateInheritedWidget.of(context).state.user.unwrap().name}",
                    style: const TextStyle(color: Colors.green)),
              ),
              ListTile(
                title: const Text("E-Mail"),
                subtitle: Text("${StateInheritedWidget.of(context).state.user.unwrap().email}",
                    style: const TextStyle(color: Colors.orange)),
              ),
              ListTile(
                title: const Text("UID"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.0),
                      child: Text("(Bei Problemen bitte bereithalten)"),
                    ),
                    Text("${StateInheritedWidget.of(context).state.user.unwrap().uid}",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              ListTile(
                title: const Text("Rolle"),
                subtitle: Text("${StateInheritedWidget.of(context).state.user.unwrap().role.repr}",
                    style: TextStyle(
                        color: StateInheritedWidget.of(context).state.user.unwrap().role.color)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        ListCardWidget(
          title: const Text("Gespeicherte Zusammenfassungen",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          leading: const Icon(Icons.favorite),
          child: _favouriteSummaries == null
              ? const CircularProgressIndicator()
              : (_favouriteSummaries!.isEmpty
                  ? const Text("Keine gespeicherten Zusammenfassungen")
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: _favouriteSummaries!.length,
                      itemBuilder: (context, index) => ListTile(
                            title: Text(_favouriteSummaries![index].data()!.name),
                            subtitle: Text(
                              _favouriteSummaries![index].data()!.description,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                            ),
                            leading: const Icon(Icons.description),
                            trailing: IconButton(
                                onPressed: () {
                                  StateInheritedWidget.of(context).removeFavouriteSummary(_favouriteSummaries![index].id).then((_) {
                                    setState(() {
                                      _favouriteSummaries = null;
                                    });
                                  });
                                },
                                icon: const Icon(Icons.favorite)),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ViewSummaryPage(
                                          summary:
                                              _favouriteSummaries![index].data()!)));
                            },
                          ))),
        ),
        const SizedBox(height: 24),
        ListCardWidget(
          title: const Text("Ausloggen", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          leading: const Icon(Icons.exit_to_app),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton(
                onPressed: () => _logout(),
                child: const Text("Aus der SUMmaries-App ausloggen")),
          ),
        ),
        ListCardWidget(
          title: const Text("Account löschen", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          leading: const Icon(Icons.delete),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton(
                onPressed: () => _deleteAccount(),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red)),
                child: const Text("SUMmaries Account löschen")),
          ),
        )
      ],
    );
  }
}
