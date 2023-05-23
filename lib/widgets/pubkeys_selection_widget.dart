import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:flutter_zxing/flutter_zxing.dart';

import 'package:seedsaver_wallet/store/data_store.dart';
import 'package:seedsaver_wallet/models/data_model.dart';
import 'package:seedsaver_wallet/widgets/vault_init_widget.dart';
import 'package:seedsaver_wallet/widgets/custom_slider_widget.dart';

class PubkeyResultWidget extends StatefulWidget {
  const PubkeyResultWidget({
    Key? key,
    required this.result,
    required this.onScanAgain,
    required this.objectbox,
  }) : super(key: key);

  final Code? result;
  final Function()? onScanAgain;
  final ObjectBox? objectbox;

  @override
  _PubkeyResultWidgetState createState() => _PubkeyResultWidgetState();
}

class _PubkeyResultWidgetState extends State<PubkeyResultWidget> {
  var loggerNoStack = Logger(
    printer: PrettyPrinter(methodCount: 0),
  );

  late List<Pubkey>? pubKeyList;
  List<bool> checkedList = [];
  bool isContinue = false;
  double currentLockLevel_value = 1.0;
  int saved_curretnLockLevel = 1;
  int saved_maximumLockLevel = 1;
  int max_length = 1;
  @override
  void initState() {
    super.initState();
    final pubKeyBox = widget.objectbox?.store.box<Pubkey>();
    isContinue = false;

    Pubkey? pubKey = Pubkey();
    if (widget.result != null) {
      pubKey.key = widget.result?.text ?? '';
      pubKeyBox?.put(pubKey);
    }

    int? length = setPubKeyList(pubKeyBox);

    for (int i = 0; i < length!; i++) {
      loggerNoStack.i(pubKeyList?.elementAt(i).key.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (isContinue == false)
            SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: widget.onScanAgain,
                        child: const Text('Scan Another'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _onDeletePubkeyList();
                        },
                        child: const Text('Delete PubKey List'),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 300, // Set a fixed height for the container
                        child: ListView.builder(
                          itemCount: pubKeyList?.length,
                          itemBuilder: (context, index) {
                            return CheckboxListTile(
                              title:
                                  Text(pubKeyList?.elementAt(index).key ?? ''),
                              value: checkedList[index],
                              onChanged: (value) {
                                setState(() {
                                  checkedList[index] = value!;
                                  max_length = 1;
                                  for (int i = 0; i < checkedList.length; i++) {
                                    if (checkedList[i] == true) {
                                      max_length++;
                                    }
                                  }
                                  if (max_length > 1) {
                                    max_length--;
                                  } else {
                                    max_length = 1;
                                  }
                                  saved_maximumLockLevel = max_length;
                                });
                              },
                            );
                          },
                        ),
                      ),
                      Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.lock),
                          ),
                          Expanded(
                            child: CustomSlider(
                              context: context,
                              child: Slider(
                                min: 1.0,
                                max: (1.0 * max_length),
                                value: currentLockLevel_value,
                                divisions: max_length,
                                label: saved_curretnLockLevel.toString(),
                                onChanged: (value) {
                                  setState(() {
                                    currentLockLevel_value = value;
                                    saved_curretnLockLevel =
                                        currentLockLevel_value.toInt();
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 60,
                          child: ElevatedButton(
                            style:
                                ElevatedButton.styleFrom(primary: Colors.green),
                            onPressed: () {
                              _onContinue();
                            },
                            child: const Text('Submit'),
                          ))
                    ],
                  ),
                ),
              ),
            )
          else
            VaultInitWidget(
                pubKeyListString: getPubKeyList(),
                currentLockLevel: saved_curretnLockLevel,
                maximumLockLevel: saved_curretnLockLevel)
        ],
      ),
    );
  }

  _onContinue() {
    setState(() {
      isContinue = true;
    });
  }

  _onDeletePubkeyList() {
    setState(() {
      final pubKeyBox = widget.objectbox?.store.box<Pubkey>();
      pubKeyBox?.removeAll();
      setPubKeyList(pubKeyBox);
      max_length = 1;
    });
  }

  setPubKeyList(pubKeyBox) {
    pubKeyList = pubKeyBox?.getAll();
    int? length = pubKeyList?.length.toInt();
    checkedList = List<bool>.filled(length!, false);
    return length;
  }

  getPubKeyList() {
    final pubKeyBox = widget.objectbox?.store.box<Pubkey>();
    late List<String>? pubKeyListString = [];

    pubKeyList = pubKeyBox?.getAll();
    int? length = pubKeyList?.length.toInt();
    for (int i = 0; i < length!; i++) {
      if (checkedList[i] == true) {
        pubKeyListString.add(
            pubKeyList?.elementAt(i).key.toString().replaceAll('\n', '') ?? '');
        loggerNoStack.i(pubKeyListString);
      }
    }
    return pubKeyListString;
  }
}
