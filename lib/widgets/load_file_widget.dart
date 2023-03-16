import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_zxing/flutter_zxing.dart';

class LoadFileWidget extends StatefulWidget {
  const LoadFileWidget({
    super.key,
    this.text,
    this.format = Format.qrCode,
    this.height = 120, // Width is calculated from height and format ratio
    this.margin = 0,
    this.eccLevel = EccLevel.low,
    this.messages = const Messages(),
    this.onSuccess,
    this.onError,
  });
  final String? text;
  final int format;
  final int height;
  final int margin;
  final EccLevel eccLevel;
  final Messages messages;
  final Function(Encode result, Uint8List? bytes)? onSuccess;
  final Function(String error)? onError;

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
