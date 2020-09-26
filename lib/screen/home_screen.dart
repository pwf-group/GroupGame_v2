import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Lottie.asset(
              'assets/background-full-screen.json',
              fit: BoxFit.fill,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Group Game',
                  style: TextStyle(
                    fontFamily: 'Crackman',
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple[800],
                  ),
                ),
                SizedBox(height: 20),
                alignedGameButton(
                  name: 'Bottle Spinner',
                  onPressed: () {
                    Navigator.pushNamed(context, '/bottle_spinner');
                  },
                ),
                alignedGameButton(
                  name: 'Dice',
                  onPressed: () {
                    Navigator.pushNamed(context, '/dice');
                  },
                ),
                alignedGameButton(
                  name: 'Buzzer',
                  onPressed: () {
                    Navigator.pushNamed(context, '/buzzer');
                  },
                ),
                // alignedGameButton('Wheel Of Fortune', () => {}),
                // alignedGameButton('Pirate Knife', () => {}),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget alignedGameButton({String name, VoidCallback onPressed}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        gameButton(name, onPressed),
      ],
    );
  }

  RaisedButton gameButton(String name, VoidCallback onPressed) {
    return RaisedButton(
      color: Colors.purple,
      textColor: Colors.white,
      padding: const EdgeInsets.all(10.0),
      child: Center(
        child: Text(
          name,
          style: TextStyle(fontSize: 20),
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      onPressed: () {
        onPressed();
      },
    );
  }
}
