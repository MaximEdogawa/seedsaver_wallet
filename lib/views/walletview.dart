import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seedsaver_wallet/models/wallet_page_view_model.dart';
import 'package:seedsaver_wallet/widgets/xch_balance_section.dart';
import 'package:seedsaver_wallet/widgets/public_address_section.dart';
import 'package:seedsaver_wallet/widgets/token_details_section.dart';
import 'package:seedsaver_wallet/widgets/token_transfer_section.dart';
import 'package:url_launcher/url_launcher.dart';

class MyCryptoWallet extends ConsumerStatefulWidget {
  const MyCryptoWallet({Key? key}) : super(key: key);

  @override
  _MyCryptoWalletState createState() => _MyCryptoWalletState();
}

class _MyCryptoWalletState extends ConsumerState<MyCryptoWallet>
    with WalletPageView {
  late final WalletPageViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ref.read(walletPageViewModel)..attachView(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wallet'),
      ),
      body: Builder(
        builder: (context) {
          return GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Builder(
                      builder: (context) {
                        int xchBalance = 0;
                        int tokenBalance = 0;

                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            PublicAddressSection(),
                            const SizedBox(height: 10.0),
                            TokenDetailsSection(
                              tokenBalance: 0,
                            ),
                            XCHBalanceSection(xchBalance: xchBalance),
                            const TokenTransferSection(),
                          ],
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  showAlertDialog(String message, String url) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Message',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          message,
          style: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              await launch(url);
              Navigator.pop(context);
            },
            child: const Text(
              'Go to Spacescan',
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
