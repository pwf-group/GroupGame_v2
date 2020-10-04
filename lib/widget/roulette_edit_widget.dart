import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:group_game/utils.dart';

// ignore: must_be_immutable
class RouletteEditWidget extends StatelessWidget {
  RouletteEditWidget({Key key, this.card}) : super(key: key) {
    _textEditingController.text = card['text'] ?? null;
  }

  final dynamic card;
  final TextEditingController _textEditingController = TextEditingController();
  String _colorHex = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 20,
      height: MediaQuery.of(context).size.height - 150,
      padding: EdgeInsets.all(20),
      color: Theme.of(context).cardColor,
      child: Column(
        children: [
          Material(
            child: TextFormField(
              controller: _textEditingController,
              decoration: InputDecoration(
                hintText: 'What do you want to name this?',
              ),
            ),
          ),
          Expanded(
            child: MaterialColorPicker(
              allowShades: false, // default true
              onMainColorChange: (ColorSwatch color) {
                // Handle main color changes
                _colorHex = color.value.toRadixString(16);
              },
              selectedColor: MyColor.hexToColor(card['color']),
            ),
          ),
          RaisedButton(
            onPressed: () {
              final text = _textEditingController.text;
              final color = _colorHex;
              Navigator.of(context).pop({'text':text, 'color':color});
            },
            child: Text(
              "Save",
              style: TextStyle(color: Colors.white),
            ),
            color: Theme.of(context).accentColor,
          )
        ],
      ),
    );
  }
}
