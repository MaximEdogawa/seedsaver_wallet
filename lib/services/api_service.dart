import 'dart:developer';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:seedsaver_wallet/constants/api_constants.dart';

class ApiService {
  Future<String> initData(
      withdrawTimelock,
      paymentClawback,
      rekeyTimelock,
      rekeyClawback,
      slowRekeyPenalty,
      pubkeysStrings,
      currentLockLevel,
      maximumLockLevel) async {
    var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.init);
    Map<String, dynamic> payload = {
      "init_singelton": true,
      "withdraw_timelock": withdrawTimelock,
      "payment_clawback": paymentClawback,
      "rekey_timelock": rekeyTimelock,
      "rekey_clawback": rekeyClawback,
      "slow_rekey_penalty": slowRekeyPenalty,
      "pubkeys_strings": pubkeysStrings,
      "current_lock_level": currentLockLevel,
      "maximum_lock_level": maximumLockLevel
    };
    var body = jsonEncode(payload);

    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    try {
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        return (jsonResponse);
      } else {
        log('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      log(e.toString());
    }
    return "";
  }
}
