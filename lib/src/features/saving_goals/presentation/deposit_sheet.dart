import 'dart:io';

import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/common_widgets/buttons/full_width_button_with_text.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/constants/strings.dart';

class DepositSheet extends StatefulHookConsumerWidget {
  const DepositSheet({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DepositSheetState();
}

class _DepositSheetState extends ConsumerState<DepositSheet> {
  @override
  Widget build(BuildContext context) {
    final amountToSave = useTextEditingController();
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(
                  left: 8.0,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.settings,
                    color: Colors.transparent,
                  ),
                  onPressed: null,
                ),
              ),
              const Expanded(
                child: Text(
                  'Deposit',
                  style: TextStyle(
                    color: AppColors.mainColor1,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  right: 8.0,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: AppColors.mainColor1,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: SizedBox(
              width: 250,
              child: AutoSizeTextField(
                autofocus: true,
                textAlign: TextAlign.center,
                enableInteractiveSelection: false,
                showCursor: false,
                // keyboardType: const TextInputType.numberWithOptions(
                //   decimal: true,
                //   signed: true,
                // ),
                // textInputAction: TextInputAction.done,
                keyboardType: Platform.isIOS
                    ? const TextInputType.numberWithOptions(
                        // signed: true,
                        decimal: true,
                      )
                    : TextInputType.number,
                // This regex for only amount (price). you can create your own regex based on your requirement
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,4}'))
                ],
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: Strings.zeroAmount,
                ),
                controller: amountToSave,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.mainColor2,
                ),
              ),
            ),
          ),
          const Text(
            'MYR',
            style: TextStyle(
              color: AppColors.mainColor1,
              // fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          FullWidthButtonWithText(
            text: Strings.confirm,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
