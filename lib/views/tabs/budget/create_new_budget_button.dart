import 'package:flutter/material.dart';

class CreateNewBudgetButton extends StatelessWidget {
  const CreateNewBudgetButton({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      // width: 150,
      child: Text(
        'Create New Budget',
        style: TextStyle(
          fontSize: 17,
        ),
      ),
    );
  }
}
