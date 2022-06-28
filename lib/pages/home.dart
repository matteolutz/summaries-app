import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:summaries/widgets/listcard.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: const [
        ListCardWidget(
          title: Text("Dies steht als nächstes an",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          leading: Icon(Icons.access_time),
          child: Text("Funktion bald verfügbar",
              style: TextStyle(color: Colors.grey)),
        )
      ],
    );
  }
}
