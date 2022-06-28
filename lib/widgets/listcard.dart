import 'package:flutter/material.dart';

class ListCardWidget extends StatelessWidget {
  final Widget title, child;
  final Widget? leading;
  final List<Widget>? bottomRow;

  const ListCardWidget(
      {Key? key,
      required this.title,
      required this.child,
      this.leading,
      this.bottomRow})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        ListTile(
          leading: leading,
          title: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: title,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: child,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: bottomRow ?? []),
        )
      ]),
    );
  }
}
