import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:math';
import 'dart:developer' as developer;

class BottleSpinnerScreen extends StatefulWidget {
  BottleSpinnerScreen({Key key}) : super(key: key);

  @override
  _BottleSpinnerScreenState createState() => _BottleSpinnerScreenState();
}

class _BottleSpinnerScreenState extends State<BottleSpinnerScreen>
    with TickerProviderStateMixin {
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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _getMinSize(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return min(width, height);
  }

  void _spin(DragEndDetails details) {
    if (_isSpinning == true) {
      developer.log('bottle is not ready!', name: 'bottle_spinner.spin');
      return;
    }

    double duration = max(details.primaryVelocity.abs(), 2500);
    double rotation = details.primaryVelocity.abs() / 100;

    if (rotation == 0) return;

    if (rotation > 15) rotation = rotation - (rotation.ceil() - 15);

    developer.log('(duration: $duration,  rotation: $rotation)', name: 'bottle_spinner.spin');

    _controller..duration = Duration(milliseconds: duration.toInt());
    _animation = Tween(begin: 0.0, end: rotation).animate(new CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutQuad,
    ));
    _controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    double minSize = _getMinSize(context);
    return Scaffold(
      body: GestureDetector(
        onVerticalDragEnd: _spin,
        child: Stack(
          children: [
            Center(
              child: RotationTransition(
                turns: _animation != null
                    ? _animation
                    : Tween(begin: 0.0, end: 0.0).animate(_controller),
                child: SizedBox(
                  height: minSize,
                  width: minSize,
                  child: Lottie.asset(
                    'assets/beer-bottle.json',
                    repeat: false,
                  ),
                ),
              ),
            ),
            Center(
              child: Opacity(
                opacity: _isSpinning ? 0.0 : 0.7,
                child: Lottie.asset(
                  'assets/swipe-up-gesture.json',
                  animate: !_isSpinning,
                ),
              ),
            ),
          ],
        ),
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
}
