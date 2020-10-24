import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

enum Bomb {
  none,
  hidden,
  open,
  fail,
}

class ExplodeScreen extends StatefulWidget {
  ExplodeScreen({Key key}) : super(key: key);

  @override
  ExplodeScreenState createState() => ExplodeScreenState();
}

class ExplodeScreenState extends State<ExplodeScreen>
    with TickerProviderStateMixin {
  int _bombCount = 1;
  final _slotCount = 24;
  final _slots = <Bomb>[];
  bool _start = false;

  @override
  void initState() {
    super.initState();
    initBomb(_bombCount);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void initBomb(count) {
    List<int> bomb = new List();
    while (bomb.length < count) {
      int index = Random.secure().nextInt(_slotCount);
      if (bomb.indexOf(index) == -1) bomb.add(index);
    }

    setState(() {
      _slots.clear();
      for (var i = 0; i < _slotCount; i++) {
        if (bomb.indexOf(i) == -1)
          _slots.add(Bomb.none);
        else
          _slots.add(Bomb.hidden);
      }
    });
  }

  void _removeBomb() {
    if (_bombCount > 1) initBomb(--_bombCount);
  }

  void _addBomb() {
    if (_bombCount < _slotCount) initBomb(++_bombCount);
  }

  void _revealSlot(index) {
    setState(() {
      _start = true;
      if (_slots[index] == Bomb.hidden) {
        _slots[index] = Bomb.fail;
      } else if (_slots[index] == Bomb.none) {
        _slots[index] = Bomb.open;
      }
    });

    if (_remainingBomb() == 0) _showResetDialog();
  }

  int _remainingBomb() {
    return _slots.where((elem) => elem == Bomb.hidden).toList().length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GridView.count(
            // Create a grid with 2 columns. If you change the scrollDirection to
            // horizontal, this produces 2 rows.
            crossAxisCount: 3,
            // Generate 100 widgets that display their index in the List.
            children: List.generate(_slotCount, (index) {
              return InkWell(
                onTap: () {
                  _revealSlot(index);
                },
                child: Center(
                  child: _buildSlot(index: index),
                ),
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildSelector(),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildSelector() {
    return [
      Ink(
        decoration: ShapeDecoration(
          color: Theme.of(context).primaryColor,
          shape: CircleBorder(),
        ),
        child: IconButton(
          icon: Icon(Icons.arrow_left),
          color: Theme.of(context).cardColor,
          onPressed: _start ? null : _removeBomb,
        ),
      ),
      SizedBox(width: 20),
      Ink(
        decoration: ShapeDecoration(
          color: Theme.of(context).primaryColor,
          shape: CircleBorder(),
        ),
        child: IconButton(
          icon: Icon(Icons.arrow_right),
          color: Theme.of(context).cardColor,
          onPressed: _start ? null : _addBomb,
        ),
      ),
      SizedBox(width: 20),
      Icon(Icons.report_problem),
      Text(
        '${_remainingBomb()}',
        style: TextStyle(
          fontSize: 16,
        ),
      ),
    ];
  }

  Widget _buildSlot({index: 0}) {
    Widget widget;
    switch (_slots[index]) {
      case Bomb.none:
      case Bomb.hidden:
        {
          widget = Text(
            '${index + 1}',
            style: Theme.of(context).textTheme.headline5,
          );
        }
        break;
      case Bomb.open:
        {
          widget = Lottie.asset(
            'assets/check-mark.json',
            animate: true,
            repeat: false,
            width: 150,
          );
        }
        break;
      case Bomb.fail:
        {
          widget = Lottie.asset(
            'assets/explosion.json',
            animate: true,
            repeat: true,
            width: 150,
          );
        }
        break;
    }
    return widget;
  }

  _showResetDialog() async {
    await showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext buildContext, Animation animation,
          Animation secondaryAnimation) {
        return Center(
          child: RaisedButton(
            onPressed: () {
              initBomb(_bombCount);
              Navigator.of(buildContext).pop();
            },
            child: const Text(
              'Reset',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        );
      },
    );
  }
}
