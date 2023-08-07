// ignore: file_names
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:seedsaver_wallet/store/data_store.dart';
import 'package:seedsaver_wallet/models/data_model.dart';
import 'package:seedsaver_wallet/widgets/custom_slider_widget.dart';
import 'package:seedsaver_wallet/widgets/custom_radio_group_widget.dart';
import 'package:seedsaver_wallet/services/api_service.dart';

import '../objectbox.g.dart';

bool _isSelected = false;

class VaultInitWidget extends StatefulWidget {
  VaultInitWidget({
    Key? key,
    required this.pubKeyListString,
    required this.currentLockLevel,
    required this.maximumLockLevel,
    required this.objectbox,
  }) : super(key: key);

  late List<String>? pubKeyListString;
  final int currentLockLevel;
  final int maximumLockLevel;
  final ObjectBox? objectbox;

  @override
  _VaultInitWidgetState createState() => _VaultInitWidgetState();
}

class _VaultInitWidgetState extends State<VaultInitWidget> {
  var loggerNoStack = Logger(
    printer: PrettyPrinter(methodCount: 0),
  );
  late List<Pubkey>? pubKeyList;
  late List<String>? pubKeyListString = [];

  @override
  void initState() {
    super.initState();
  }

  bool isLoading = false;
  double withdrawal_timelock_value = 600;
  double payment_clawback_value = 1200.0;
  double rekey_timelock_value = 300.0;
  double rekey_clawback_value = 600.0;
  double rekey_penalty_value = 900.0;

  double saved_withdrawal_timelock_value = 600;
  double saved_payment_clawback_value = 1200.0;
  double saved_rekey_timelock_value = 300.0;
  double saved_rekey_clawback_value = 600.0;
  double saved_rekey_penalty_value = 900.0;

  double min_withdrawal_timelock_value = 600.0;
  double min_payment_clawback_value = 1200.0;
  double min_rekey_timelock_value = 300.0;
  double min_rekey_clawback_value = 600.0;
  double min_rekey_penalty_value = 900.0;

  double max_value = 3600.0;
  int divisions_value = 3600;

  int _selectedIndex = 0;
  String slider_label_unit = " s";
  int slider_label_division = 1;

  late ApiService apiRequest = ApiService();

  void _sendResponse() async {
    Map<String, dynamic> jsonResponse = {"Succes": "false"};
    String response = await apiRequest.init(
        withdrawal_timelock_value.toInt().toString(),
        payment_clawback_value.toInt().toString(),
        rekey_timelock_value.toInt().toString(),
        rekey_clawback_value.toInt().toString(),
        rekey_penalty_value.toInt().toString(),
        widget.pubKeyListString,
        widget.currentLockLevel.toString(),
        widget.maximumLockLevel.toString());
    if (response != "") {
      jsonResponse = jsonDecode(response);
    }
    loggerNoStack.i("Response code: ", response);
    if (jsonResponse["Success"] == "true") {
      final vaultBox = widget.objectbox?.store.box<Vault>();
      isLoading = false;
      Vault? vault = Vault();
      final query = vaultBox?.query(
          Vault_.singeltonHex.equals(jsonResponse['launched_singelton_hex']));
      final result = query?.build().findFirst();
      if (result == null) {
        vault.singeltonHex = jsonResponse['launched_singelton_hex'];
        vaultBox?.put(vault);
      }
    } else {
      loggerNoStack.e("Error response code:", response.toString());
    }
    isLoading = false;
  }

  void _handleRadioValueChanged(int index) {
    setState(() {
      _selectedIndex = index;

      withdrawal_timelock_value = 600.0;
      payment_clawback_value = 1200.0;
      rekey_timelock_value = 300.0;
      rekey_clawback_value = 600.0;
      rekey_penalty_value = 900.0;

      switch (_selectedIndex) {
        case 0:
          divisions_value = 3600;
          slider_label_unit = " s";
          slider_label_division = 1;
          max_value = 3600;
          break;
        case 1:
          divisions_value = 60;
          slider_label_unit = " m";
          slider_label_division = 60;
          max_value = 3600;
          break;
        case 2:
          divisions_value = 24;
          slider_label_unit = " h";
          slider_label_division = 3600;
          max_value = 86400;
          break;
        case 3:
          divisions_value = 365;
          slider_label_unit = " d";
          slider_label_division = 86400;
          max_value = 31536000;
          break;
        case 4:
          divisions_value = 10;
          slider_label_unit = " y";
          slider_label_division = 31536000;
          max_value = 315360000;
          break;
        default:
          divisions_value = 3600;
          slider_label_unit = " s";
          slider_label_division = 1;
          max_value = 3600;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Card(
              elevation: 50,
              shadowColor: Colors.black,
              color: Colors.greenAccent[100],
              child: SizedBox(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      //SizedBox
                      Text(
                        'Vault Name',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.green.shade800,
                          fontWeight: FontWeight.w500,
                        ), //Textstyle
                      ), //Text
                      //SizedBox
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Withdrawal Timelock: ',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                ), //Textstyle
                              ),
                              Text(
                                formatDuration(saved_withdrawal_timelock_value),
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Payment Claw back: ',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                ), //Textstyle
                              ),
                              Text(
                                formatDuration(saved_payment_clawback_value),
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Rekey Timelock: ',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                ), //Textstyle
                              ),
                              Text(
                                formatDuration(saved_rekey_timelock_value),
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Rekey Claw back: ',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                ), //Textstyle
                              ),
                              Text(
                                formatDuration(saved_rekey_clawback_value),
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Slow rekey Penalty : ',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                ), //Textstyle
                              ),
                              Text(
                                formatDuration(saved_rekey_penalty_value),
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ), //Text
                      const SizedBox(
                        height: 10,
                      ), //SizedBox
                    ],
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomRadioGroup(
                  options: const ['sec', 'min', 'hour', 'day', 'year'],
                  selectedIndex: _selectedIndex,
                  onSelect: _handleRadioValueChanged,
                ),
              ],
            ),
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.lock),
                ),
                const Icon(Icons.timelapse),
                Expanded(
                  child: CustomSlider(
                    context: context,
                    child: Slider(
                      min: min_withdrawal_timelock_value,
                      max: max_value,
                      value: withdrawal_timelock_value,
                      divisions: divisions_value,
                      label:
                          '${(withdrawal_timelock_value.round() / slider_label_division).toStringAsFixed(0)}$slider_label_unit',
                      onChanged: (value) {
                        setState(() {
                          withdrawal_timelock_value = value;
                          saved_withdrawal_timelock_value = value;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.refresh_rounded),
                ),
                const Icon(Icons.timelapse),
                Expanded(
                  child: CustomSlider(
                    context: context,
                    child: Slider(
                      min: min_payment_clawback_value,
                      max: max_value,
                      value: payment_clawback_value,
                      divisions: divisions_value,
                      label:
                          '${(payment_clawback_value.round() / slider_label_division).toStringAsFixed(0)}$slider_label_unit',
                      onChanged: (value) {
                        setState(() {
                          payment_clawback_value = value;
                          saved_payment_clawback_value = value;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.key),
                ),
                const Icon(Icons.timelapse),
                Expanded(
                  child: CustomSlider(
                    context: context,
                    child: Slider(
                      min: min_rekey_timelock_value,
                      max: max_value,
                      value: rekey_timelock_value,
                      divisions: divisions_value,
                      label:
                          '${(rekey_timelock_value.round() / slider_label_division).toStringAsFixed(0)}$slider_label_unit',
                      onChanged: (value) {
                        setState(() {
                          rekey_timelock_value = value;
                          saved_rekey_timelock_value = value;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.key),
                ),
                const Icon(Icons.refresh),
                Expanded(
                  child: CustomSlider(
                    context: context,
                    child: Slider(
                      min: min_rekey_clawback_value,
                      max: max_value,
                      value: rekey_clawback_value,
                      divisions: divisions_value,
                      label:
                          '${(rekey_clawback_value.round() / slider_label_division).toStringAsFixed(0)}$slider_label_unit',
                      onChanged: (value) {
                        setState(() {
                          rekey_clawback_value = value;
                          saved_rekey_clawback_value = value;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.key),
                ),
                const Icon(Icons.error),
                Expanded(
                  child: CustomSlider(
                    context: context,
                    child: Slider(
                      min: min_rekey_penalty_value,
                      max: max_value,
                      value: rekey_penalty_value,
                      divisions: divisions_value,
                      label:
                          '${(rekey_penalty_value.round() / slider_label_division).toStringAsFixed(0)}$slider_label_unit',
                      onChanged: (value) {
                        setState(() {
                          rekey_penalty_value = value;
                          saved_rekey_penalty_value = value;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            Container(
                padding: const EdgeInsets.only(left: 10, right: 10),
                width: MediaQuery.of(context).size.width,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.green),
                  onPressed: () {
                    setState(() {
                      isLoading = true;
                    });
                    _sendResponse();
                    setState(() {
                      isLoading = false;
                    });
                  },
                  child: isLoading
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'Loading...',
                              style: TextStyle(fontSize: 20),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ],
                        )
                      : const Text('Submit'),
                ))
          ],
        ),
      ),
    );
  }

  String formatDuration(double seconds) {
    int years = (seconds / (365 * 24 * 60 * 60)).floor();
    seconds -= years * 365 * 24 * 60 * 60;

    int days = (seconds / (24 * 60 * 60)).floor();
    seconds -= days * 24 * 60 * 60;

    int hours = (seconds / (60 * 60)).floor();
    seconds -= hours * 60 * 60;

    int minutes = (seconds / 60).floor();
    seconds -= minutes * 60;

    int remainingSeconds = seconds.floor();

    String formattedDuration = '';
    if (years > 0) {
      formattedDuration += '$years y ';
    }
    if (days > 0) {
      formattedDuration += '$days d ';
    }
    if (hours > 0) {
      formattedDuration += '$hours h ';
    }
    if (minutes > 0) {
      formattedDuration += '$minutes min ';
    }
    if (remainingSeconds > 0) {
      formattedDuration += '$remainingSeconds s';
    }

    return formattedDuration;
  }
}
