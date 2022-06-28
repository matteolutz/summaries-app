import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:http/http.dart' as http;
import 'package:photo_view/photo_view.dart';
import 'package:summaries/structures/summary.dart';
import 'package:summaries/widgets/listcard.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewSummaryPage extends StatefulWidget {
  final Summary summary;

  const ViewSummaryPage({Key? key, required this.summary}) : super(key: key);

  @override
  State<ViewSummaryPage> createState() => _ViewSummaryPageState();
}

class _ViewSummaryPageState extends State<ViewSummaryPage> {
  bool _shouldPop = false;
  String? _contentType;
  String? _data;

  Future<void> _loadSummaryFile() async {
    final http.Response response = await http.get(widget.summary.url);

    if (!response.headers.containsKey("content-type")) {
      setState(() {
        _shouldPop = true;
      });
      return;
    }

    setState(() {
      _contentType = response.headers["content-type"];
      _data = response.body;
    });
  }

  Widget _renderBody(Summary summary, String contentType, String data) {
    if (contentType.startsWith("image/")) {
      return PhotoView(
        imageProvider: NetworkImage(summary.url.toString()),
        loadingBuilder: (context, _) =>
            const Center(child: CircularProgressIndicator()),
      );
    }

    if (contentType == "application/pdf") {
      return const PDF(
        enableSwipe: true,
        autoSpacing: true,
        pageSnap: true,
      ).cachedFromUrl(summary.url.toString());
    }

    if (contentType.startsWith("text/")) {
      return Markdown(
          data: data,
          extensionSet: md.ExtensionSet(
            md.ExtensionSet.gitHubFlavored.blockSyntaxes,
            [md.EmojiSyntax(), ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes],
          ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListCardWidget(
        title: const Text("Nicht unterstützter Dateityp",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        leading: const Icon(CupertinoIcons.exclamationmark_circle),
        child: Column(
          children: [
            Text("Der Dateityp '$contentType' wird nicht unterstützt."),
            TextButton(
                onPressed: () {
                  launchUrl(summary.url, mode: LaunchMode.externalApplication)
                      .then((result) {
                    if (!result) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Datei konnte nicht geöffnet werden."),
                      ));
                    }
                  });
                },
                child: const Text("Datei herunterladen"))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_shouldPop) {
      Navigator.pop(context);
    }

    if (_contentType == null || _data == null) {
      _loadSummaryFile();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.summary.name),
        actions: [
          IconButton(
              icon: const Icon(CupertinoIcons.printer),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Diese Funktion ist noch nicht verfügbar.")));
              }),
          IconButton(
            icon: const Icon(CupertinoIcons.arrow_down),
            onPressed: () {
              launchUrl(widget.summary.url,
                  mode: LaunchMode.externalNonBrowserApplication);
            },
          ),
        ],
      ),
      body: _contentType == null
          ? const Center(child: CircularProgressIndicator())
          : Container(
              child: _renderBody(widget.summary, _contentType!, _data!)),
    );
  }
}
