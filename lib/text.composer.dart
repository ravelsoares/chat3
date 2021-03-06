import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TextComposer extends StatefulWidget {
  TextComposer(this.sendMessage);
  final void Function({String text, File imgFile}) sendMessage;

  @override
  _TextComposerState createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {
  TextEditingController _controller = TextEditingController();
  bool _isComposing = false;

  void _reset() {
    _controller.clear();
    setState(() {
      _isComposing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () async {
              final File imgFile =
                  // ignore: deprecated_member_use
                  (await ImagePicker.pickImage(source: ImageSource.gallery));
              if (imgFile == null) return;
              widget.sendMessage(imgFile: imgFile);
            },
            icon: const Icon(Icons.photo_camera),
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration.collapsed(
                hintText: 'Envie uma mensagem',
              ),
              onChanged: (text) {
                setState(() {
                  _isComposing = text.isNotEmpty;
                });
              },
              onSubmitted: (text) {
                widget.sendMessage(text: text);
                _reset();
              },
            ),
          ),
          IconButton(
            onPressed: _isComposing
                ? () {
                    widget.sendMessage(text: _controller.text);
                    _reset();
                  }
                : null,
            icon: Icon(Icons.send),
          )
        ],
      ),
    );
  }
}
