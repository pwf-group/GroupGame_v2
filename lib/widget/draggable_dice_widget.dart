import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class DraggableDiceWidget extends StatefulWidget {
  DraggableDiceWidget({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => DraggableDiceWidgetState();
}

class DraggableDiceWidgetState extends State<DraggableDiceWidget> {
  double top = 0;
  double left = 0;
  int face = Random.secure().nextInt(5) + 1;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      int width = MediaQuery.of(context).size.width.toInt() - 180;
      int height = MediaQuery.of(context).size.height.toInt() - 180;

      setState(() {
        left = Random.secure().nextInt(width).toDouble();
        top = Random.secure().nextInt(height).toDouble();
      });
    });
  }

  void shuffleStart() {
    setState(() { face = 0; });
  }

  void shuffleEnd() {
    setState(() { face = Random.secure().nextInt(6) + 1; });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () { shuffleStart(); },
      onLongPressUp: () { shuffleEnd(); },
      child: _draggableDice(),
    );
  }

  Widget _draggableDice() {
    return Draggable(
      child: Container(
        padding: EdgeInsets.only(top: top, left: left),
        child: _lottieDice(repeat: face > 0 ? false : true, number: face),
      ),
      feedback: Container(
        padding: EdgeInsets.only(top: top, left: left),
        child: _lottieDice(animate: false),
      ),
      childWhenDragging: Container(
        child: null,
      ),
      onDragCompleted: () {},
      onDragEnd: (drag) {
        shuffleEnd();
        setState(() {
          top = top + drag.offset.dy < 0 ? 0 : top + drag.offset.dy;
          left = left + drag.offset.dx < 0 ? 0 : left + drag.offset.dx;
        });
      },
    );
  }

  Widget _lottieDice({animate = true, repeat: true, number: 0}) {
    var s = number > 0 ? number : '';

    return Lottie.asset(
      'assets/touzidice$s.json',
      animate: animate,
      repeat: repeat,
      width: 150,
    );
  }
}
