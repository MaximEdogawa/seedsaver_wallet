// ignore: file_names
import 'package:flutter/material.dart';
import 'package:seedsaver_wallet/widgets/custom_slider_widget.dart';
import 'package:seedsaver_wallet/widgets/custom_radio_group_widget.dart';

bool _isSelected = false;

class VaultInitWidget extends StatefulWidget {
  String textContent;

  VaultInitWidget({
    this.textContent = "",
  });

  @override
  _VaultInitWidgetState createState() => _VaultInitWidgetState();
}

class _VaultInitWidgetState extends State<VaultInitWidget> {
  @override
  void initState() {
    super.initState();
  }

  bool isLoading = false;
  double _withdrawal_timelock_value = 600;
  double _payment_clawback_value = 1200.0;
  double _rekey_timelock_value = 300.0;
  double _rekey_clawback_value = 600.0;
  double _rekey_penalty_value = 900.0;

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

  void _handleRadioValueChanged(int index) {
    setState(() {
      _selectedIndex = index;

      _withdrawal_timelock_value = 600.0;
      _payment_clawback_value = 1200.0;
      _rekey_timelock_value = 300.0;
      _rekey_clawback_value = 600.0;
      _rekey_penalty_value = 900.0;

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
      appBar: AppBar(
        title: const Text('Vault Create'),
      ),
      body: Center(
        child: Column(
          children: [
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
                      value: _withdrawal_timelock_value,
                      divisions: divisions_value,
                      label:
                          '${(_withdrawal_timelock_value.round() / slider_label_division).toStringAsFixed(0)}$slider_label_unit',
                      onChanged: (value) {
                        setState(() {
                          _withdrawal_timelock_value = value;
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
                      value: _payment_clawback_value,
                      divisions: divisions_value,
                      label:
                          '${(_payment_clawback_value.round() / slider_label_division).toStringAsFixed(0)}$slider_label_unit',
                      onChanged: (value) {
                        setState(() {
                          _payment_clawback_value = value;
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
                      value: _rekey_timelock_value,
                      divisions: divisions_value,
                      label:
                          '${(_rekey_timelock_value.round() / slider_label_division).toStringAsFixed(0)}$slider_label_unit',
                      onChanged: (value) {
                        setState(() {
                          _rekey_timelock_value = value;
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
                      value: _rekey_clawback_value,
                      divisions: divisions_value,
                      label:
                          '${(_rekey_clawback_value.round() / slider_label_division).toStringAsFixed(0)}$slider_label_unit',
                      onChanged: (value) {
                        setState(() {
                          _rekey_clawback_value = value;
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
                      value: _rekey_penalty_value,
                      divisions: divisions_value,
                      label:
                          '${(_rekey_penalty_value.round() / slider_label_division).toStringAsFixed(0)}$slider_label_unit',
                      onChanged: (value) {
                        setState(() {
                          _rekey_penalty_value = value;
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

                    // we had used future delayed to stop loading after
                    // 3 seconds and show text "submit" on the screen.
                    Future.delayed(const Duration(seconds: 3), () {
                      setState(() {
                        isLoading = false;
                      });
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

class OutlineButton {}
