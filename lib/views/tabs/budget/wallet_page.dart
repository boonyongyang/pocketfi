import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/views/constants/app_colors.dart';
import 'package:pocketfi/views/tabs/budget/create_new_wallet_button.dart';
import 'package:pocketfi/views/tabs/budget/wallet_tiles.dart';

class WalletPage extends ConsumerStatefulWidget {
  const WalletPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WalletPageState();
}

class _WalletPageState extends ConsumerState<WalletPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet'),
      ),
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(
            height: 10,
          ),
          GestureDetector(
            // go to the detail page of the wallet
            onTap: () {},
            child: const WalletTiles(
              walletName: 'Wallet 1',
              walletBalance: 100.00,
            ),
          ),
          // WalletTiles(
          //   walletName: 'Wallet 2',
          //   walletBalance: 200.00,
          // ),
          // WalletTiles(
          //   walletName: 'Wallet 3',
          //   walletBalance: 300.00,
          // ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(80, 55),
                backgroundColor: AppSwatches.mainColor1,
                foregroundColor: AppSwatches.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(25),
                  ),
                ),
              ),
              onPressed: () {},
              child: const CreateNewWalletButton(),
            ),
          ),
        ],
      )),
    );
  }
}
