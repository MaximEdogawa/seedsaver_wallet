import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import 'package:seedsaver_wallet/constants/api_constants.dart';

class ApiService {
  var loggerNoStack = Logger(
    printer: PrettyPrinter(methodCount: 0),
  );
  Future<dynamic> init(
      withdrawTimelock,
      paymentClawback,
      rekeyTimelock,
      rekeyClawback,
      slowRekeyPenalty,
      pubkeyListStrings,
      currentLockLevel,
      maximumLockLevel) async {
    loggerNoStack.i('init');

    var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.init);
    Map<String, dynamic> payload = {
      "init_singelton": true,
      "withdraw_timelock": withdrawTimelock,
      "payment_clawback": paymentClawback,
      "rekey_timelock": rekeyTimelock,
      "rekey_clawback": rekeyClawback,
      "slow_rekey_penalty": slowRekeyPenalty,
      "pubkeys_strings": pubkeyListStrings,
      "current_lock_level": currentLockLevel,
      "maximum_lock_level": maximumLockLevel
    };
    var body = jsonEncode(payload);

    loggerNoStack.i('Request Body: $body');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    try {
      if (response.statusCode == 200) {
        loggerNoStack.i(jsonDecode(response.body));
        return (jsonDecode(response.body));
      } else {
        loggerNoStack.i('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      loggerNoStack.i(e.toString());
    }
    return "";
  }
}
