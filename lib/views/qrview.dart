import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zxing/flutter_zxing.dart';

import '../widgets/debug_info_widget.dart';
import '../widgets/scan_result_widget.dart';
import '../widgets/unsupported_platform_widget.dart';
import '../widgets/writer_loop_widget.dart';

import 'dart:convert';
import 'package:base32/base32.dart';

Map<String, int> headerSize = {'mode': 1, 'chunk': 7, 'chunks': 7};

class QRView extends StatefulWidget {
  const QRView({Key? key}) : super(key: key);

  @override
  State<QRView> createState() => _QRViewState();
}

class _QRViewState extends State<QRView> {
  Uint8List? createdCodeBytes;

  Code? result;
  Codes? multiResult;

  bool isMultiScan = false;

  bool showDebugInfo = true;
  int successScans = 0;
  int failedScans = 0;
  List<String> spendbundle = [];
  int totalSegments = 0;
  int collectedSegments = 0;

  @override
  Widget build(BuildContext context) {
    final isCameraSupported = defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const TabBar(
            tabs: [
              Tab(text: 'Scan Code'),
              Tab(text: 'Create Code'),
            ],
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            if (kIsWeb)
              const UnsupportedPlatformWidget()
            else if (!isCameraSupported)
              const Center(
                child: Text('Camera not supported on this platform'),
              )
            else if (result != null && result?.isValid == true)
              ScanResultWidget(
                result: result,
                onScanAgain: () => setState(() => result = null),
              )
            else
              Stack(
                children: [
                  ReaderWidget(
                    onScan: _onScanSuccess,
                    onScanFailure: _onScanFailure,
                    onMultiScan: _onMultiScanSuccess,
                    onMultiScanFailure: _onMultiScanFailure,
                    onMultiScanModeChanged: _onMultiScanModeChanged,
                    isMultiScan: isMultiScan,
                    scanDelay: Duration(milliseconds: isMultiScan ? 50 : 500),
                    resolution: ResolutionPreset.high,
                    lensDirection: CameraLensDirection.back,
                  ),
                  if (showDebugInfo)
                    DebugInfoWidget(
                      successScans: successScans,
                      failedScans: failedScans,
                      error: isMultiScan ? multiResult?.error : result?.error,
                      duration: isMultiScan
                          ? multiResult?.duration ?? 0
                          : result?.duration ?? 0,
                      onReset: _onReset,
                    ),
                ],
              ),
            if (kIsWeb)
              const UnsupportedPlatformWidget()
            else
              ListView(
                children: [
                  WriterLoopWidget(
                    messages: const Messages(
                      createButton: 'Create Code',
                    ),
                    onSuccess: (result, bytes) {
                      setState(() {
                        createdCodeBytes = bytes;
                      });
                    },
                    onError: (error) {
                      _showMessage(context, 'Error: $error');
                    },
                  ),
                  if (createdCodeBytes != null)
                    Image.memory(createdCodeBytes ?? Uint8List(0), height: 400),
                ],
              ),
          ],
        ),
      ),
    );
  }

  _onScanSuccess(Code? code) {
    setState(() {
      successScans++;
      result = code;
    });
  }

  _onScanFailure(Code? code) {
    setState(() {
      failedScans++;
      result = code;
    });
    if (code?.error?.isNotEmpty == true) {
      _showMessage(context, 'Error: ${code?.error}');
    }
  }

  _onMultiScanSuccess(Codes codes) {
    setState(() {
      successScans++;
      Map<String, dynamic> data = decodeData(codes.codes[0].text.toString());
      final header = data["header"];
      if (totalSegments == 0) {
        totalSegments = header["chunks"];
        spendbundle = List.generate(totalSegments, (index) => "");
      }
      String payload = data["payload"];
      int chunkIndex = header["chunk"];
      if (spendbundle[chunkIndex - 1] == "" && payload != "") {
        spendbundle[chunkIndex] = payload;
        collectedSegments++;
      }

      if (collectedSegments == totalSegments) {
        codes.codes[0].text = spendbundle.join("");
        result = codes.codes[0];
      }
      multiResult = codes;
    });
  }

  _onMultiScanFailure(Codes result) {
    setState(() {
      failedScans++;
      multiResult = result;
    });
    if (result.codes.isNotEmpty == true) {
      _showMessage(context, 'Error: ${result.codes.first.error}');
    }
  }

  _onMultiScanModeChanged(bool isMultiScan) {
    setState(() {
      this.isMultiScan = isMultiScan;
    });
  }

  _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  _onReset() {
    setState(() {
      successScans = 0;
      failedScans = 0;
    });
  }

  Map<String, dynamic> decodeData(String data) {
    final header = <String, int>{};
    final payload = <int>[];
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
    return {'header': header, 'payload': utf8.decode(payload)};
  }

  int bytesToInt(List<int> bytes) {
    return bytes.fold(0, (result, byte) => (result << 8) + byte);
  }
}
