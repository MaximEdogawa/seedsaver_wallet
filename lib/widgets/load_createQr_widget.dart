// ignore: file_names
import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:crypto/crypto.dart';
import 'package:base32/base32.dart';
import 'package:file_picker/file_picker.dart';

class FileTransferWidget extends StatefulWidget {
  String textContent;
  final String ecLvl;
  final String mode;
  final int version;

  FileTransferWidget({
    this.textContent = "",
    this.ecLvl = "L",
    this.mode = "full",
    this.version = 10,
  });

  @override
  _FileTransferWidgetState createState() => _FileTransferWidgetState();
}

class _FileTransferWidgetState extends State<FileTransferWidget> {
  List<String> chunks = [];
  late int totalChunks;
  int currentChunkIndex = 0;
  List<QrImage> qrCodes = [];
  Timer? _qrTimer;
  int delayMillisecondsState = 1;

  @override
  void initState() {
    super.initState();
  }

  void _startQrTransferLoop() {
    Duration qrDisplayInterval = const Duration(milliseconds: 1000);

    switch (delayMillisecondsState) {
      case 1:
        qrDisplayInterval = const Duration(milliseconds: 1000);
        break;
      case 2:
        qrDisplayInterval = const Duration(milliseconds: 500);
        break;
      case 3:
        qrDisplayInterval = const Duration(milliseconds: 300);
        break;
      case 4:
        qrDisplayInterval = const Duration(milliseconds: 100);
        break;
      default:
    }
    _qrTimer = Timer.periodic(qrDisplayInterval, (timer) {
      setState(() {
        if (currentChunkIndex < totalChunks - 1) {
          currentChunkIndex++;
        } else {
          currentChunkIndex =
              0; // cancel the timer when all chunks have been displayed
        }
      });
    });
  }

  Future<void> _loadChunks() async {
    final String text = widget.textContent;
    final textSize = text.length;

    int chunkSize = 160;
    final headerSize = {'mode': 1, 'chunk': 2, 'chunks': 2};
    final chunkCount = (textSize - 1) ~/ chunkSize + 1;

    totalChunks = chunkCount;

    final header = {'mode': 1, 'chunk': 0, 'chunks': totalChunks};
    final headerHash = {'mode': 2, 'chunk': 1, 'chunks': 1};

    if (totalChunks > 256 * headerSize['chunks']!) {
      throw ArgumentError(
          'The chosen file is too big to be transferred using these QR code parameters.');
    }
    //final chunkHash = _generateHash(utf8.encode(text));
    int x = 1;
    for (int i = 0; i < textSize; i += chunkSize) {
      header["chunk"] = x;
      x++;
      final String payload = text.substring(
          i, i + chunkSize > text.length ? text.length : i + chunkSize);
      String data = encodeData(header, headerSize, payload);
      chunks.add(data);
    }
  }

  Future<void> _loadFile() async {
    final FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.any);

    if (result != null) {
      final String fileName = result.files.single.name;
      final String contents =
          await File(result.files.single.path!).readAsString();
      widget.textContent = contents;
      _loadChunks();
      _startQrTransferLoop();
    }
  }

  @override
  void dispose() {
    _qrTimer?.cancel(); // cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: chunks.isEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: FloatingActionButton.extended(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.black,
                    onPressed: () {
                      _loadFile();
                    },
                    icon: Icon(Icons.add),
                    label: Text('Load File'),
                  ),
                )
              ],
            )
          : Column(
              children: [
                LinearProgressIndicator(
                  value: currentChunkIndex / (totalChunks - 1),
                ),
                const SizedBox(height: 16.0),
                Expanded(
                  child: Center(
                    child: QrImage(
                      data: chunks[currentChunkIndex],
                      errorCorrectionLevel: _getErrorCorrectionLevel(),
                      version: widget.version,
                      size: 380.0,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FloatingActionButton(
                      onPressed: () {
                        setState(() {
                          delayMillisecondsState = 1;
                        });
                        _qrTimer?.cancel();
                        _startQrTransferLoop();
                      },
                      child: const Text('1s'),
                    ),
                    const SizedBox(width: 16.0),
                    FloatingActionButton(
                      onPressed: () {
                        setState(() {
                          delayMillisecondsState = 2;
                        });
                        _qrTimer?.cancel();
                        _startQrTransferLoop();
                      },
                      child: const Text('500ms'),
                    ),
                    const SizedBox(width: 16.0),
                    FloatingActionButton(
                      onPressed: () {
                        setState(() {
                          delayMillisecondsState = 3;
                        });
                        _qrTimer?.cancel();
                        _startQrTransferLoop();
                      },
                      child: const Text('300ms'),
                    ),
                    const SizedBox(width: 16.0),
                    FloatingActionButton(
                      onPressed: () {
                        setState(() {
                          delayMillisecondsState = 4;
                        });
                        _qrTimer?.cancel();
                        _startQrTransferLoop();
                      },
                      child: const Text('100ms'),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  String encodeData(
      Map<String, int> header, Map<String, int> headerSize, String content) {
    // Decode the Base32-encoded content and replace '%' with '='
    final contentBytes =
        base32.decode(base32.encode(Uint8List.fromList(utf8.encode(content))));
    var data = header.entries.map((entry) {
      final k = entry.key;
      final size = headerSize[k]!;
      var value = entry.value.toRadixString(16).padLeft(size * 2, '0');
      return value;
    }).join('');
    final dataBytes =
        base32.decode(base32.encode(Uint8List.fromList(hexToIntList(data))));
    var combinedData = base32.encode(dataBytes) + base32.encode(contentBytes);

    return combinedData;
  }

  List<int> hexToIntList(String hexString) {
    List<int> bytes = [];
    for (int i = 0; i < hexString.length; i += 2) {
      String hexByte = hexString.substring(i, i + 2);
      int byte = int.parse(hexByte, radix: 16);
      bytes.add(byte);
    }
    return bytes;
  }

  int _getErrorCorrectionLevel() {
    return widget.ecLvl == 'H'
        ? QrErrorCorrectLevel.H
        : widget.ecLvl == 'Q'
            ? QrErrorCorrectLevel.Q
            : widget.ecLvl == 'M'
                ? QrErrorCorrectLevel.M
                : QrErrorCorrectLevel.L;
  }

  List<int> _generateHash(List<int> data) {
    return sha256.convert(data).bytes;
  }
}
