import 'package:flutter/material.dart';
import 'package:seedsaver_wallet/views/qrview.dart';

import '../store/data_store.dart';

class VaultPage extends StatelessWidget {
  const VaultPage({
    Key? key,
    this.objectbox,
  }) : super(key: key);

  final ObjectBox? objectbox;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vaults"),
        backgroundColor: Colors.green,
      ),
      body: Center(
          child: ElevatedButton(
        child: const Text("Add Vault"),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) =>
                      CreateVaultPage(objectbox: objectbox))));
        },
      )),
    );
  }
}

class CreateVaultPage extends StatelessWidget {
  const CreateVaultPage({
    Key? key,
    this.objectbox,
  }) : super(key: key);
  final ObjectBox? objectbox;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Vault"),
        backgroundColor: Colors.green,
      ),
      body: Center(child: QRView(objectbox: objectbox)),
    );
  }
}
