import 'package:flutter/material.dart';
import 'package:pocketfi/views/constants/strings.dart';

class CreateNewBudgetButton extends StatelessWidget {
  const CreateNewBudgetButton({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      // width: 150,
      child: Text(
        Strings.createNewBudget,
        style: TextStyle(
          fontSize: 17,
        ),
      ),
    );
  }
}
