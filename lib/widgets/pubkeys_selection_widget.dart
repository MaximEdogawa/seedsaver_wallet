import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:flutter_zxing/flutter_zxing.dart';

import 'package:seedsaver_wallet/store/data_store.dart';
import 'package:seedsaver_wallet/models/data_model.dart';
import 'package:seedsaver_wallet/widgets/vault_init_widget.dart';

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

    pubKeyList = pubKeyBox?.getAll();
    int? length = pubKeyList?.length.toInt();
    checkedList = List<bool>.filled(length!, false);

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
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 400, // Set a fixed height for the container
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
                                });
                              },
                            );
                          },
                        ),
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
                checkedList: checkedList, objectbox: widget.objectbox)
        ],
      ),
    );
  }

  _onContinue() {
    setState(() {
      isContinue = true;
    });
  }
}
