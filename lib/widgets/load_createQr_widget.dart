// ignore: file_names
import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:file_picker/file_picker.dart';
import 'package:share/share.dart';
import 'package:flutter_zxing/flutter_zxing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:convert';
import 'package:cryptography/cryptography.dart';

class FileTransferWidget extends StatefulWidget {
  final String textContent;
  final String ecLvl;
  final String mode;
  final int version;

  FileTransferWidget({
    required this.textContent,
    this.ecLvl = "M",
    this.mode = "full",
    this.version = 20,
  });

  @override
  _FileTransferWidgetState createState() => _FileTransferWidgetState();
}

class _FileTransferWidgetState extends State<FileTransferWidget> {
  List<String> chunks = [];
  late int totalChunks;
  int currentChunkIndex = 0;
  List<QrImage> qrCodes = [];

  @override
  void initState() {
    super.initState();
    _loadChunks();
  }

  Future<void> _loadChunks() async {
    final String text = widget.textContent;
    final textSize = text.length;

    const chunkSize = 512;
    final headerSize = {'mode': 1, 'chunk': 7, 'chunks': 7};
    final chunkCount = (textSize - 1) ~/ chunkSize + 1;

    totalChunks = chunkCount;

    final header = {'mode': 0, 'chunk': 0, 'chunks': totalChunks};
    final headerHash = {'mode': 1, 'chunk': 1, 'chunks': 1};

    if (totalChunks > 256 * headerSize['chunk']!) {
      throw ArgumentError(
          'The chosen file is too big to be transferred using these QR code parameters.');
    }
    //final chunkHash = _generateHash(utf8.encode(text));
    int x = 1;
    for (int i = 0; i < textSize; i += chunkSize) {
      header["chunk"] = x;
      x++;
      final headerData = _encodeHeader(header, headerSize);
      final String helpString = text.substring(
          i, i + chunkSize > text.length ? text.length : i + chunkSize);
      chunks.add(helpString);
    }

    // Display QR code immediately and wait for frame rate delay

    final stop = 1;
  }

  int _calculateChunkSize() {
    final charSize = widget.ecLvl == 'H'
        ? 8
        : widget.ecLvl == 'Q'
            ? 11
            : widget.ecLvl == 'M'
                ? 14
                : 17;
    final qrCodeSize = widget.version < 10
        ? 21
        : widget.version < 27
            ? 25
            : widget.version < 41
                ? 29
                : 33;
    final bytesSize = qrCodeSize * qrCodeSize ~/ 8 - charSize;
    return bytesSize;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Transfer'),
      ),
      body: chunks.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                LinearProgressIndicator(
                  value: currentChunkIndex / totalChunks,
                ),
                const SizedBox(height: 16.0),
                Expanded(
                  child: Center(
                    child: QrImage(
                      data: chunks[currentChunkIndex],
                      version: widget.version,
                      errorCorrectionLevel: _getErrorCorrectionLevel(),
                      size: 400.0,
                    ),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            currentChunkIndex++;
          });
        },
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }

  _encodeHeader(Map<String, int> header, Map<String, int> headerSize) {}
}
