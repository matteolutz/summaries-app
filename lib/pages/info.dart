import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:summaries/util/constants.dart';
import 'package:summaries/widgets/listcard.dart';
import 'package:url_launcher/url_launcher_string.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  String? _theIdea;

  @override
  Widget build(BuildContext context) {
    if (_theIdea == null) {
      DefaultAssetBundle.of(context)
          .loadString("assets/texts/the_idea.txt")
          .then((value) => setState(() => _theIdea = value));
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Text('Über '),
            Text("SUMarries", style: TextStyle(fontFamily: "Pacifico"))
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("© ${DateTime.now().year.toString()} Matteo Lutz",
                style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 24.0, horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/icon.png", width: 50.0),
                const SizedBox(width: 12.0),
                const Text("SUMmaries",
                    style: TextStyle(fontFamily: "Pacifico", fontSize: 30),
                    textAlign: TextAlign.center),
              ],
            ),
          ),
          ListCardWidget(
              leading: const Icon(Icons.lightbulb),
              title: const Text("Die Idee",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              bottomRow: [
                TextButton.icon(
                    onPressed: () {
                      launchUrlString(LEARN_MORE_URL,
                          mode: LaunchMode.externalApplication);
                    },
                    label: const Text("Mehr erfahren"),
                    icon: const Icon(Icons.info)),
              ],
              child: _theIdea == null
                  ? const Center(child: CircularProgressIndicator())
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(_theIdea!, textAlign: TextAlign.justify),
                    )),
          ListCardWidget(
            leading: const Icon(Icons.coffee),
            title: const Text("Entwicklung",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            bottomRow: [
              TextButton.icon(
                  onPressed: () {
                    launchUrlString(MATTEO_LUTZ_MAIL_URL,
                        mode: LaunchMode.externalApplication);
                  },
                  label: const Text("E-Mail"),
                  icon: const Icon(Icons.mail)),
            ],
            child: TextButton.icon(
                onPressed: () {
                  launchUrlString(MATTEO_LUTZ_URL,
                      mode: LaunchMode.externalApplication);
                },
                label:
                    const Text("Matteo Lutz", style: TextStyle(fontSize: 18)),
                icon: const Icon(Icons.person_outline)),
          ),
          ListCardWidget(
              leading: const Icon(Icons.person),
              title: const Text("Mitwirkende",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              bottomRow: [
                TextButton.icon(
                    onPressed: () {
                      launchUrlString(CONTRIBUTE_MAIL_URL,
                          mode: LaunchMode.externalApplication);
                    },
                    label: const Text("Selber mitwirken"),
                    icon: const Icon(Icons.person_add)),
              ],
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: CONTRIBUTORS.length,
                itemBuilder: (context, index) {
                  final String contributor = CONTRIBUTORS.keys.elementAt(index);
                  final List<String> contributors =
                      CONTRIBUTORS.values.elementAt(index);
                  return Column(
                    children: [
                      Text(contributor, style: const TextStyle(fontSize: 18)),
                      contributors.isNotEmpty
                          ? Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: contributors.map((contributor) {
                                return TextButton.icon(
                                    onPressed: () {},
                                    label: Text(contributor,
                                        style: const TextStyle(fontSize: 16)),
                                    icon: const Icon(Icons.group_outlined));
                              }).toList(),
                            )
                          : const Text("Keine Mitwirkenden",
                              style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 16.0),
                    ],
                  );
                },
              ))
        ],
      ),
    );
  }
}
