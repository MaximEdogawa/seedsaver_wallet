import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zxing/flutter_zxing.dart';

import '../widgets/debug_info_widget.dart';
import '../widgets/scan_result_widget.dart';
import '../widgets/unsupported_platform_widget.dart';
import '../widgets/writer_loop_widget.dart';
import '../widgets/load_file_widget.dart';

import 'dart:convert';
import 'package:cryptography/cryptography.dart';
import 'package:base32/base32.dart';

const PBKDF2_ROUNDS = 2048;
// Size of in bytes for each header section
Map<String, int> headerSize = {'mode': 1, 'chunk': 2, 'chunks': 2};

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
  List<int> hashedPayload = [];

  @override
  Widget build(BuildContext context) {
    final isCameraSupported = defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Code'),
      ),
      body: Stack(
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
      List<int> payload = [];
      Map<String, dynamic> data =
          decodeData(codes.codes[0].text.toString(), payload);
      final header = data["header"];
      int chunkIndex = header["chunk"] - 1;
      int mode = header["mode"];
      if (mode == 1) {
        if (totalSegments == 0) {
          totalSegments = header["chunks"];
          spendbundle = List.generate(totalSegments, (index) => "");
        }
        if (spendbundle[chunkIndex] == "" && payload.isNotEmpty == true) {
          spendbundle[chunkIndex] = utf8.decode(payload);
          collectedSegments++;
        }
      } else if (mode == 2) {
        hashedPayload = payload;
      }

      if (collectedSegments == totalSegments && totalSegments != 0) {
        String joinedSpendBundle = spendbundle.join("");
        //Removed hashing check develop at a later date
        //List<int> hash = pbkdf2HmacSHA512(joinedSpendBundle, PBKDF2_ROUNDS);

        codes.codes[0].text = joinedSpendBundle;
        result = codes.codes[0];
        // Refactor for state control to reset all scan parameters&states
        spendbundle = [];
        totalSegments = 0;
        collectedSegments = 0;
        hashedPayload = [];
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

  Map<String, dynamic> decodeData(String data, List<int> payload) {
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

  //Review code and find a hashing alogithm that works both on python and flutter
  List<int> pbkdf2HmacSHA512(String message, int rounds) {
    final pbkdf2 = Pbkdf2(
      macAlgorithm: Hmac.sha512(),
      iterations: rounds,
      bits: 64,
    );
    var hash = pbkdf2.deriveKeyFromPassword(
      password: message,
      nonce: const [],
    );
    return utf8.encode(hash.toString());
  }
}
