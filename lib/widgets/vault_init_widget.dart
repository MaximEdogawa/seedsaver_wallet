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

  double min_withdrawal_timelock_value = 600.0;
  double min_payment_clawback_value = 1200.0;
  double min_rekey_timelock_value = 300.0;
  double min_rekey_clawback_value = 600.0;
  double min_rekey_penalty_value = 900.0;

  double max_withdrawal_timelock_value = 1000000.0;
  double max_payment_clawback_value = 1000000.0;
  double max_rekey_timelock_value = 1000000.0;
  double max_rekey_clawback_value = 1000000.0;
  double max_rekey_penalty_value = 1000000.0;

  double divisions_value = 1000000;
  int _selectedIndex = 0;

  void _handleRadioValueChanged(int index) {
    setState(() {
      _selectedIndex = index;
      switch (_selectedIndex) {
        case 0:
          min_withdrawal_timelock_value = 600.0;
          _payment_clawback_value = 1200.0;
          _rekey_timelock_value = 300.0;
          _rekey_clawback_value = 600.0;
          _rekey_penalty_value = 900.0;
          max_withdrawal_timelock_value = 1000000.0;
          max_payment_clawback_value = 1000000.0;
          max_rekey_timelock_value = 1000000.0;
          max_rekey_clawback_value = 1000000.0;
          max_rekey_penalty_value = 1000000.0;
          break;
        default:
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
                                "${_withdrawal_timelock_value.toStringAsFixed(0)} sec",
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
                                "${_payment_clawback_value.toStringAsFixed(0)} sec",
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
                                "${_rekey_timelock_value.toStringAsFixed(0)} sec",
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
                                "${_rekey_clawback_value.toStringAsFixed(0)} sec",
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
                                "${_rekey_penalty_value.toStringAsFixed(0)} sec",
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
                  options: const ['sec', 'min', 'hour', 'day'],
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
                      max: max_withdrawal_timelock_value,
                      value: _withdrawal_timelock_value,
                      divisions: divisions_value,
                      label: '${_withdrawal_timelock_value.round()}',
                      onChanged: (value) {
                        setState(() {
                          _withdrawal_timelock_value = value;
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
                      max: max_payment_clawback_value,
                      value: _payment_clawback_value,
                      divisions: divisions_value,
                      label: '${_payment_clawback_value.round()}',
                      onChanged: (value) {
                        setState(() {
                          _payment_clawback_value = value;
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
                      max: max_rekey_timelock_value,
                      value: _rekey_timelock_value,
                      divisions: divisions_value,
                      label: '${_rekey_timelock_value.round()}',
                      onChanged: (value) {
                        setState(() {
                          _rekey_timelock_value = value;
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
                      max: max_rekey_clawback_value,
                      value: _rekey_clawback_value,
                      divisions: divisions_value,
                      label: '${_rekey_clawback_value.round()}',
                      onChanged: (value) {
                        setState(() {
                          _rekey_clawback_value = value;
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
                      max: max_rekey_penalty_value,
                      value: _rekey_penalty_value,
                      divisions: divisions_value,
                      label: '${_rekey_penalty_value.round()}',
                      onChanged: (value) {
                        setState(() {
                          _rekey_penalty_value = value;
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
}

class OutlineButton {}
