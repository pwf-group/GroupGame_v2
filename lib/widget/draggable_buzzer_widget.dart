import 'dart:math';
import 'package:flutter/material.dart';

class DraggableBuzzerWidget extends StatefulWidget {
  final ValueChanged<Color> parentAction;
  final Color color;

  DraggableBuzzerWidget({Key key, this.parentAction, this.color}) : super(key: key);

  @override
  State<StatefulWidget> createState() => DraggableBuzzerWidgetState();
}

class DraggableBuzzerWidgetState extends State<DraggableBuzzerWidget> {
  final double buzzerSize = 85.0;
  double top = 0;
  double left = 0;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      int width = MediaQuery.of(context).size.width.toInt() - buzzerSize.toInt();
      int height = MediaQuery.of(context).size.height.toInt() - buzzerSize.toInt() - 50;

      setState(() {
        left = Random.secure().nextInt(width).toDouble();
        top = Random.secure().nextInt(height).toDouble() + 50;
      });
    });
  }

  void _buzz() {
    widget.parentAction(widget.color);
  }

  @override
  Widget build(BuildContext context) {
    return _draggableBuzzer();
  }

  Widget _draggableBuzzer() {
    return Draggable(
      child: Container(
        padding: EdgeInsets.only(top: top, left: left),
        child: _buzzer(),
      ),
      feedback: Container(
        padding: EdgeInsets.only(top: top, left: left),
        child: _buzzer(),
      ),
      childWhenDragging: Container(
        child: null,
      ),
      onDragCompleted: () {},
      onDragEnd: (drag) {
        setState(() {
          top = top + drag.offset.dy < 0 ? 0 : top + drag.offset.dy;
          left = left + drag.offset.dx < 0 ? 0 : left + drag.offset.dx;
        });
      },
    );
  }

  Widget _buzzer() {
    return Material(
      child: Ink(
        decoration: ShapeDecoration(
          color: widget.color,
          shape: CircleBorder(),
        ),
        child: SizedBox(
          height: buzzerSize,
          width: buzzerSize,
          child: IconButton(
            icon: Icon(Icons.gamepad, size: 2 * buzzerSize / 3),
            color: Colors.white,
            onPressed: _buzz,
          ),
        ),
      ),
    );
  }
}
