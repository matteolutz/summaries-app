import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:summaries/pages/home.dart';
import 'package:summaries/pages/login/wrapper.dart';
import 'package:summaries/pages/me.dart';
import 'package:summaries/structures/future_option.dart';
import 'package:summaries/structures/user.dart';
import 'package:summaries/util/state.dart';

import '../pages/calendar.dart';
import '../pages/info.dart';
import '../structures/option.dart';

class NavigatorWidget extends StatefulWidget {
  const NavigatorWidget({Key? key}) : super(key: key);

  @override
  State<NavigatorWidget> createState() => _NavigatorWidgetState();
}

class _NavigatorWidgetState extends State<NavigatorWidget> {
  static const List<Widget> _widgets = <Widget>[
    HomePage(),
    CalendarPage(),
    Text("Add"),
    Text("Messages"),
    MePage()
  ];

  static const _defaultIndex = 0;
  int _selectedIndex = 0;

  bool _wasLoggedIn = false;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final FutureOption<SummariesUser> user = StateInheritedWidget.of(context).state.user;

    if(_wasLoggedIn != user.isSome) {
      setState(() {
        _wasLoggedIn = !_wasLoggedIn;
        _selectedIndex = _defaultIndex;
      });
    }

    if(user.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return user.isNone
        ? const AuthWrapperPage()
        : Scaffold(
            appBar: AppBar(
              title: const Text("SUMmaries",
                  style: TextStyle(fontFamily: "Pacifico")),
              actions: [
                IconButton(
                  icon: const Icon(Icons.help),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const InfoPage()));
                  },
                )
              ],
            ),
            body: Container(
              child: _widgets.elementAt(_selectedIndex),
            ),
            bottomNavigationBar: BottomNavigationBar(
              showSelectedLabels: false,
              showUnselectedLabels: false,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_today),
                  label: 'Kalender',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.add),
                  activeIcon: Icon(Icons.add_circle_outline),
                  label: "Hinzufügen",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.message),
                  label: "Nachrichten"
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Ich',
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Theme.of(context).colorScheme.primary,
              onTap: _onItemTapped,
            ),
          );
  }
}
