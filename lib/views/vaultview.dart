import 'package:flutter/material.dart';
import '../widgets/pubkeys_selection_widget.dart';
import '../widgets/pubkeys_selection_widget.dart';

import '../store/data_store.dart';

class VaultPage extends StatelessWidget {
  const VaultPage({
    Key? key,
    this.objectbox,
  }) : super(key: key);

  final ObjectBox? objectbox;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text("Vaults"),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: FloatingActionButton.extended(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: ((context) =>
                        CreateVaultPage(objectbox: objectbox))));
          },
          icon: Icon(Icons.add),
          label: Text('Add Vault'),
        ),
      ),
    ));
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
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
                title: const Text("Add Vault"),
                backgroundColor: Colors.green,
                actions: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close))
                ]),
            body: Center(
                child: PubkeyResultWidget(
                    result: null, onScanAgain: null, objectbox: objectbox))));
  }
}
