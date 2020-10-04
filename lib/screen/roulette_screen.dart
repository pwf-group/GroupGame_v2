import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import '../utils.dart';
import '../widget/roulette_painter.dart';
import '../widget/roulette_edit_widget.dart';

class RouletteScreen extends StatefulWidget {
  RouletteScreen({Key key}) : super(key: key);

  @override
  RouletteScreenState createState() => RouletteScreenState();
}

class RouletteScreenState extends State<RouletteScreen>
    with TickerProviderStateMixin {
  double minSize = 0;
  List _cards = [];
  bool _isSpinning = true;
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 1500), () {
      setState(() {
        _isSpinning = false;
      });
    });

    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..addStatusListener((AnimationStatus status) {
        setState(() {
          if (status == AnimationStatus.forward) _isSpinning = true;
          if (status == AnimationStatus.completed) _isSpinning = false;
        });
      });

    _animation = Tween(begin: 0.0, end: 0.0).animate(new CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutQuad,
    ));

    _addCard();
  }

  void _addCard() {
    // final color = MyColor.randomHex();
    final text = _cards.length + 1;
    _cards.add(jsonDecode('{"color":"", "text":"$text"}'));
  }

  void _removeCard() {
    if (_cards.length > 1) _cards.removeLast();
  }

  void _spin(DragEndDetails details) {
    if (_isSpinning == true) {
      developer.log('roulette is not ready!', name: 'roulette.spin');
      return;
    }

    double duration = max(details.primaryVelocity.abs(), 10000);
    double rotation =
        details.primaryVelocity.abs() / 100 + Random.secure().nextDouble();

    if (rotation == 0) return;

    if (rotation > 20) rotation = rotation - (rotation.ceil() - 20);

    developer.log('(duration: $duration,  rotation: $rotation)',
        name: 'roulette.spin');

    _controller..duration = Duration(milliseconds: duration.toInt());
    _animation = Tween(begin: 0.0, end: rotation).animate(new CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutQuad,
    ));
    _controller.forward(from: 0.0);
  }

  void _editItem(LongPressStartDetails details) {
    print(context);
    double radius = minSize / 2;
    final pos = details.localPosition;
    final radian = atan2(pos.dy - radius, pos.dx - radius);
    final sweepingAngle = 2 * pi / _cards.length;

    final offRadian = radian + pi; // offset for computation
    final index = offRadian / sweepingAngle + 1;
    final floor = index.floor();

    print('long press index: $floor');
    _showEditDialog(_cards[floor - 1]);
  }

  _showEditDialog(dynamic card) async {
    final value = await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext buildContext, Animation animation,
          Animation secondaryAnimation) {
        return Center(child: RouletteEditWidget(card: card));
      },
    );

    if (value == null) return;

    setState(() {
      card['text'] = value['text'];
      card['color'] = value['color'];
    });
  }

  @override
  Widget build(BuildContext context) {
    minSize = minScreenSize(context) - 20;

    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            onVerticalDragEnd: _spin,
          ),
          Padding(
            padding: EdgeInsets.only(top: 40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildSelector(),
            ),
          ),
          Center(
            child: RotationTransition(
              turns: _animation != null
                  ? _animation
                  : Tween(begin: 0.0, end: 0.0).animate(_controller),
              child: GestureDetector(
                  onLongPressStart: _editItem,
                  onVerticalDragEnd: _spin,
                  child: CustomPaint(
                    size: Size(minSize, minSize),
                    painter: RoulettePainter(
                      cards: _cards,
                      context: context,
                    ),
                  )),
            ),
          ),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_on,
                  color: Theme.of(context).primaryColor,
                  size: 60,
                ),
                SizedBox(
                  height: minSize + 20,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Navigator.pop(context);
        },
        child: Icon(Icons.arrow_back),
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
          onPressed: _removeCard,
        ),
      ),
      SizedBox(width: 20),
      RaisedButton(
        onPressed: null, // () { _showEditDialog(_cards[0]); },
        child: const Text(
          'Spin',
          style: TextStyle(
            fontSize: 20,
          ),
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
          onPressed: _addCard,
        ),
      ),
    ];
  }
}
