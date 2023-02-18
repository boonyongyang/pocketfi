import 'package:flutter/material.dart';
import 'package:pocketfi/views/constants/strings.dart';

class CreateNewWalletButton extends StatelessWidget {
  const CreateNewWalletButton({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      // width: 150,
      child: Text(
        Strings.createNewWallet,
        style: TextStyle(
          fontSize: 17,
        ),
      ),
    );
  }
}
