import 'dart:io';
import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:flutter_zxing/flutter_zxing.dart';
import 'package:path_provider/path_provider.dart';

class ScanResultWidget extends StatefulWidget {
  const ScanResultWidget({
    Key? key,
    this.result,
    this.onScanAgain,
  }) : super(key: key);

  final Code? result;
  final Function()? onScanAgain;

  @override
  _ScanResultWidgetState createState() => _ScanResultWidgetState();
}

class _ScanResultWidgetState extends State<ScanResultWidget> {
  late Future<String> _filePathFuture;
  late String _fileContent;

  @override
  void initState() {
    super.initState();
    _filePathFuture = _initFilePath();
    _writeToFile(widget.result?.text ?? '');
    _fileContent = '';
  }

  @override
  void didUpdateWidget(covariant ScanResultWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.result?.text != widget.result?.text) {
      _writeToFile(widget.result?.text ?? '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'File saved at:',
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(height: 20),
              FutureBuilder<String>(
                future: _filePathFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return GestureDetector(
                      onTap: () async {
                        final filePath = snapshot.data!;
                        final file = File(filePath);
                        final content = await file.readAsString();
                        setState(() {
                          _fileContent = content;
                        });
                      },
                      child: Text(
                        snapshot.data!,
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                              color: Theme.of(context).primaryColor,
                              decoration: TextDecoration.underline,
                            ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: widget.onScanAgain,
                child: const Text('Scan Again'),
              ),
              const SizedBox(height: 20),
              if (_fileContent.isNotEmpty) ...[
                Container(
                  height: 200,
                  child: SingleChildScrollView(
                    child: Text(_fileContent),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final directory = await getApplicationDocumentsDirectory();
                    final filePath = '${directory.path}/result.txt';
                    final file = File(filePath);
                    final content = await file.readAsString();
                    final RenderBox renderBox =
                        context.findRenderObject() as RenderBox;
                    await Share.share(content,
                        subject: 'File content',
                        sharePositionOrigin:
                            renderBox.localToGlobal(Offset.zero) &
                                renderBox.size);
                  },
                  child: const Text('Share'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<String> _initFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    const fileName = 'result.txt';
    final filePath = '${directory.path}/$fileName';
    return filePath;
  }

  void _writeToFile(String text) async {
    final filePath = await _initFilePath();
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }
    final hexString = hex.encode(utf8.encode(text));
    await file.writeAsString(hexString);
  }
}
