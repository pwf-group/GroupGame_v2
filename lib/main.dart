import 'package:flutter/material.dart';
import 'screen/home_screen.dart';
import 'screen/bottle_spinner_screen.dart';
import 'screen/dice_screen.dart';
import 'screen/buzzer_screen.dart';
import 'screen/roulette_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Group Game',
      theme: ThemeData(
        // This is the theme of your application.
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'NoContinue',
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.purple,
        brightness: Brightness.dark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'NoContinue',
      ),
      home: HomeScreen(),
      routes: <String, WidgetBuilder> {
        '/bottle_spinner': (BuildContext context) => BottleSpinnerScreen(),
        '/dice': (BuildContext context) => DiceScreen(),
        '/buzzer': (BuildContext context) => BuzzerScreen(),
        '/roulette': (BuildContext context) => RouletteScreen(),
        // '/pirate_knife': (BuildContext context) => MyHomePage(title: 'aa'),
      },
    );
  }
}
