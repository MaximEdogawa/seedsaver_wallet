import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:seedsaver_wallet/views/qrview.dart';
import 'package:seedsaver_wallet/widgets/load_createQr_widget.dart';
import 'package:seedsaver_wallet/widgets/not_yet_implemented_widget.dart';
import 'package:seedsaver_wallet/widgets/vault_init_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Seedsaver_wallet',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        ),
        home: HomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  GlobalKey? historyListKey;
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    Widget page;
    switch (selectedIndex) {
      case 0:
        page = NotYetImplementedCard();
        break;
      case 1:
        page = FileTransferWidget();
        break;
      case 2:
        page = QRView();
        break;
      case 3:
        page = VaultInitWidget();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    var mainArea = ColoredBox(
      color: colorScheme.surfaceVariant,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 200),
        child: page,
      ),
    );

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 450) {
            return Column(
              children: [
                Expanded(child: mainArea),
                SafeArea(
                  child: BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.wallet),
                        label: 'Wallet',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.qr_code),
                        label: 'QR Show',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.camera_alt_outlined),
                        label: 'QR San',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.safety_check),
                        label: 'Vaults',
                      ),
                    ],
                    currentIndex: selectedIndex,
                    onTap: (value) {
                      setState(() {
                        selectedIndex = value;
                      });
                    },
                  ),
                )
              ],
            );
          } else {
            return Row(
              children: [
                SafeArea(
                  child: NavigationRail(
                    extended: constraints.maxWidth >= 600,
                    destinations: const [
                      NavigationRailDestination(
                        icon: Icon(Icons.wallet),
                        label: Text('Wallet'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.qr_code),
                        label: Text('QR Show '),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.camera_alt_outlined),
                        label: Text('QR Scan'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.safety_check),
                        label: Text('Vaults'),
                      ),
                    ],
                    selectedIndex: selectedIndex,
                    onDestinationSelected: (value) {
                      setState(() {
                        selectedIndex = value;
                      });
                    },
                  ),
                ),
                Expanded(child: mainArea),
              ],
            );
          }
        },
      ),
    );
  }
}
