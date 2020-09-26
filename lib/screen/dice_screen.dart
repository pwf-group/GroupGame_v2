import 'package:flutter/material.dart';
import '../widget/draggable_dice_widget.dart';

class DiceScreen extends StatefulWidget {
  DiceScreen({Key key}) : super(key: key);

  @override
  DiceScreenState createState() => DiceScreenState();
}


class DiceScreenState extends State<DiceScreen> with TickerProviderStateMixin {
  int _diceCount = 0;
  final _dices = <Widget>[];
  final _dicesKey = <GlobalKey<DraggableDiceWidgetState>>[];

  @override
  void initState() {
    super.initState();

    _addDice();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _addDice() {
    setState(() {
      if (_diceCount < 9) {
        _diceCount++;

        final key = GlobalKey<DraggableDiceWidgetState>();
        _dicesKey.add(key);

        _dices.add(DraggableDiceWidget(key: key));
      }
    });
  }

  void _removeDice() {
    setState(() {
      if (_diceCount > 1) {
        _diceCount--;

        _dicesKey.removeLast();
        _dices.removeLast();
      }
    });
  }

  void _shuffleAllStart() {
    for (var key in _dicesKey) {
      key.currentState.shuffleStart();
    }
  }

  void _shuffleAllEnd() {
    for (var key in _dicesKey) {
      key.currentState.shuffleEnd();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildDiceSelector(),
            ),
          ),
          GestureDetector(
            onLongPress: _shuffleAllStart,
            onLongPressUp: _shuffleAllEnd,
          ),
          ..._dices,
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        onPressed: () {
          Navigator.pop(context);
        },
        child: Icon(Icons.arrow_back),
      ),
    );
  }

  List<Widget> _buildDiceSelector() {
    return [
      Ink(
        decoration: const ShapeDecoration(
          color: Colors.purple,
          shape: CircleBorder(),
        ),
        child: IconButton(
          icon: Icon(Icons.arrow_left),
          color: Colors.white,
          onPressed: _removeDice,
        ),
      ),
      SizedBox(width: 20),
      Text(
        '$_diceCount',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 50,
          color: Colors.purple,
        ),
      ),
      SizedBox(width: 20),
      Ink(
        decoration: const ShapeDecoration(
          color: Colors.purple,
          shape: CircleBorder(),
        ),
        child: IconButton(
          icon: Icon(Icons.arrow_right),
          color: Colors.white,
          onPressed: _addDice,
        ),
      ),
    ];
  }
}
