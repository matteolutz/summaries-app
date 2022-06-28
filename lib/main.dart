import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:summaries/util/state.dart';
import 'package:summaries/util/firebase_options.dart';

import './widgets/navigator.dart';

Future<void> main() async {
  // await initializeDateFormatting("de_DE", null);

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(StateWidget(
    child: Builder(
      builder: (BuildContext context) {
        final state = StateInheritedWidget.of(context).state;

         return MaterialApp(
           localizationsDelegates: const [
             GlobalMaterialLocalizations.delegate,
             GlobalWidgetsLocalizations.delegate,
             GlobalCupertinoLocalizations.delegate,
           ],
           supportedLocales: const [
             Locale('de', 'DE'),
           ],
           darkTheme: ThemeData(
             brightness: Brightness.dark,
             primaryColor: const Color.fromRGBO(0x0, 0x80, 0x80, 1.0),
             colorScheme: ThemeData.dark().colorScheme.copyWith(
                 primary: const Color.fromRGBO(0x0, 0x80, 0x80, 1.0),
                 secondary: Colors.teal[400]),
             appBarTheme: const AppBarTheme(
               color: Color.fromRGBO(0x0, 0x80, 0x80, 1.0),
             ),
             snackBarTheme: const SnackBarThemeData(
               backgroundColor: Color.fromRGBO(0x0, 0x80, 0x80, 1.0),
               contentTextStyle: TextStyle(
                 color: Colors.white,
               ),
             ),
           ),
           theme: ThemeData.light(),

           // set dark theme for debug mode, so we can see the dark theme in the emulator
           themeMode: kDebugMode ? ThemeMode.dark : ThemeMode.system,
           title: "SUMmaries",
           home: const NavigatorWidget(),
         );
      },
    ),
  ));
}
