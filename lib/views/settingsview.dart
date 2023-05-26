import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextStyle headingStyle = const TextStyle(
      fontSize: 16, fontWeight: FontWeight.w600, color: Colors.green);

  bool lockAppSwitchVal = true;
  bool fingerprintSwitchVal = false;
  bool changePassSwitchVal = true;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Settings"),
          backgroundColor: Colors.green,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(12),
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Common",
                      style: headingStyle,
                    ),
                  ],
                ),
                const ListTile(
                  leading: Icon(Icons.language),
                  title: Text("Language"),
                  subtitle: Text("English"),
                ),
                const Divider(),
                const ListTile(
                  leading: Icon(Icons.cloud),
                  title: Text("Environment"),
                  subtitle: Text("Production"),
                ),
                ListTile(
                  leading: const Icon(Icons.phonelink_lock_outlined),
                  title: const Text("Lock app in background"),
                  trailing: Switch(
                      value: lockAppSwitchVal,
                      activeColor: theme.colorScheme.primary,
                      onChanged: (val) {
                        setState(() {
                          lockAppSwitchVal = val;
                        });
                      }),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.fingerprint),
                  title: const Text("Use fingerprint"),
                  trailing: Switch(
                      value: fingerprintSwitchVal,
                      activeColor: theme.colorScheme.primary,
                      onChanged: (val) {
                        setState(() {
                          fingerprintSwitchVal = val;
                        });
                      }),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.lock),
                  title: const Text("Change Password"),
                  trailing: Switch(
                      value: changePassSwitchVal,
                      activeColor: theme.colorScheme.primary,
                      onChanged: (val) {
                        setState(() {
                          changePassSwitchVal = val;
                        });
                      }),
                ),
                const ListTile(
                  leading: Icon(Icons.file_open_outlined),
                  title: Text("Terms of Service"),
                ),
                const Divider(),
                const ListTile(
                  leading: Icon(Icons.file_copy_outlined),
                  title: Text("Open Source and Licences"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
