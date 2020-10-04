import 'package:flutter/material.dart';
import '../widget/draggable_buzzer_widget.dart';
import '../utils.dart';

class BuzzerScreen extends StatefulWidget {
  BuzzerScreen({Key key}) : super(key: key);

  @override
  BuzzerScreenState createState() => BuzzerScreenState();
}

class BuzzerScreenState extends State<BuzzerScreen>
    with TickerProviderStateMixin {
  final _buzzers = <Widget>[];
  final _buzzSeq = <Color>[];

  @override
  void initState() {
    super.initState();

    _addBuzzer();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _addBuzzer() {
    setState(() {
      if (_buzzers.length < 9) {
        _buzzers.add(DraggableBuzzerWidget(
          parentAction: buzz,
          color: MyColor.colors[_buzzers.length],
        ));
      }
    });
  }

  void _removeBuzzer() {
    setState(() {
      if (_buzzers.length > 1) {
        _buzzers.removeLast();
      }
    });
  }

  void _resetGame() {
    setState(() {
      _buzzSeq.clear();
    });
  }

  void buzz(Color color) {
    print('buzz: $color');
    setState(() {
      if (_buzzSeq.indexOf(color) == -1) {
        _buzzSeq.add(color);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: _buzzSeq.map((color) => Expanded(
              child: Container(
                color: color,
              ),
            )).toList(),
          ),
          Padding(
            padding: EdgeInsets.only(top: 35.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildDiceSelector(),
            ),
          ),
          ..._buzzers,
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Icon(Icons.arrow_back),
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
          onPressed: _removeBuzzer,
        ),
      ),
      SizedBox(width: 20),
      RaisedButton(
        onPressed: _resetGame,
        child: const Text(
          'Reset',
          style: TextStyle(
            fontSize: 20,
          ),
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
          onPressed: _addBuzzer,
        ),
      ),
    ];
  }
}
