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
import 'package:cryptography/cryptography.dart';
import 'package:base32/base32.dart';
import 'package:seedsaver_wallet/constants/qr_constants.dart';

class FileTransferWidget extends StatefulWidget {
  final String textContent;
  final String ecLvl;
  final String mode;
  final int version;

  FileTransferWidget({
    required this.textContent,
    this.ecLvl = "L",
    this.mode = "full",
    this.version = 15,
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

    int chunkSize = 330;
    final headerSize = {'m': 1, 'i': 7, 'n': 7};
    final chunkCount = (textSize - 1) ~/ chunkSize + 1;

    totalChunks = chunkCount;

    final header = {'m': 0, 'i': 0, 'n': totalChunks};
    final headerHash = {'m': 1, 'i': 1, 'n': 1};

    if (totalChunks > 256 * headerSize['i']!) {
      throw ArgumentError(
          'The chosen file is too big to be transferred using these QR code parameters.');
    }
    //final chunkHash = _generateHash(utf8.encode(text));
    int x = 1;
    for (int i = 0; i < textSize; i += chunkSize) {
      header["i"] = x;
      x++;
      final String payload = text.substring(
          i, i + chunkSize > text.length ? text.length : i + chunkSize);
      String data = encodeData(header, headerSize, payload);
      List<int> content = [];
      Map<String, dynamic> headerData = decodeData(data, headerSize, content);
      chunks.add(data);
    }
    final stop = 1;
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
                  value: currentChunkIndex / (totalChunks - 1),
                ),
                const SizedBox(height: 16.0),
                Expanded(
                  child: Center(
                    child: QrImage(
                      data: chunks[currentChunkIndex],
                      errorCorrectionLevel: _getErrorCorrectionLevel(),
                      version: widget.version,
                      size: 400.0,
                    ),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (currentChunkIndex < totalChunks - 1) {
              currentChunkIndex++;
            }
          });
        },
        child: const Icon(Icons.arrow_forward),
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

  Map<String, dynamic> decodeData(
      String data, Map<String, int> headerSize, List<int> payload) {
    final header = <String, int>{};
    try {
      final content = base32.decode(data.replaceAll('%', '='));
      var cursor = 0;
      for (final key in headerSize.keys) {
        final size = headerSize[key]!;
        header[key] = bytesToInt(content.sublist(cursor, cursor + size));
        cursor += size;
      }

      payload.addAll(content.sublist(cursor));
    } on FormatException {
      throw ArgumentError('QR code is not in a valid format');
    }
    return {'header': header};
  }

  int bytesToInt(List<int> bytes) {
    return bytes.fold(0, (result, byte) => (result << 8) + byte);
  }

  int _calculateMaxDataSize(int version, String ecLvl) {
    final totalDataCodewords =
        NUM_BLOCKS_BY_VERSION[version]![1] * NUM_EC_BLOCKS[ecLvl]![1];
    final maxDataBits = totalDataCodewords * 8;
    final dataSize = maxDataBits - QR_CODE_CHARACTERS_SIZE[version]![1];
    return dataSize;
  }
}
