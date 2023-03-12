import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class LoadFileWidget extends StatefulWidget {
  @override
  _LoadFileWidgetState createState() => _LoadFileWidgetState();
}

class _LoadFileWidgetState extends State<LoadFileWidget> {
  final TextEditingController _textEditingController = TextEditingController();

  Future<void> _loadFile() async {
    final FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.any);

    if (result != null) {
      final String fileName = result.files.single.name;
      final String contents =
          await File(result.files.single.path!).readAsString();
      _textEditingController.text = contents;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ElevatedButton(
          onPressed: _loadFile,
          child: const Text('Load file'),
        ),
        TextFormField(
          controller: _textEditingController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'File contents',
          ),
          maxLines: null,
          keyboardType: TextInputType.multiline,
        ),
      ],
    );
  }
}
