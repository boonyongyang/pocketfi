import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/views/constants/app_colors.dart';
import 'package:pocketfi/views/constants/strings.dart';

class CreateNewBudgetView extends StatefulHookConsumerWidget {
  const CreateNewBudgetView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateNewBudgetViewState();
}

class _CreateNewBudgetViewState extends ConsumerState<CreateNewBudgetView> {
  @override
  Widget build(BuildContext context) {
    final budgetNameController = useTextEditingController();
    final amountController = useTextEditingController();

    final isCreateButtonEnabled = useState(false);

    useEffect(
      () {
        void listener() {
          isCreateButtonEnabled.value = budgetNameController.text.isNotEmpty &&
              amountController.text.isNotEmpty;
        }

        budgetNameController.addListener(listener);
        amountController.addListener(listener);

        return () {
          budgetNameController.removeListener(listener);
          amountController.removeListener(listener);
        };
      },
      [
        budgetNameController,
        amountController,
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.createNewBudget),
      ),
      body: Flex(
        direction: Axis.vertical,
        children: [
          // Expanded(
          //   flex: 4,
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.stretch,
          //     children: const [
          //       Padding(
          //         padding: EdgeInsets.all(8.0),
          //         child: Text(
          //           "0.00",
          //           textAlign: TextAlign.center,
          //         ),
          //       ),
          //       Text(
          //         'MYR',
          //         textAlign: TextAlign.center,
          //       ),
          //     ],
          //   ),
          // ),
          // Expanded(
          //     child: Row(
          //   children: [
          //     DropdownButton(
          //         items: <String>["Food and Drinks"]
          //             .map<DropdownMenuItem<String>>((String value) {
          //           return DropdownMenuItem<String>(
          //             value: value,
          //             child: Text(value),
          //           );
          //         }).toList(),
          //         onChanged: (_) {}),
          //   ],
          // )),
          Expanded(
            flex: 4,
            child: Column(
              children: [
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 16.0, right: 32.0),
                      child: SizedBox(
                        width: 5,
                        child: Icon(
                          Icons.wallet,
                          color: AppSwatches.mainColor1,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: budgetNameController,
                          decoration: const InputDecoration(
                            labelText: Strings.budgetName,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 16.0, right: 32.0),
                      child: SizedBox(
                        width: 5,
                        child: Icon(
                          Icons.money_rounded,
                          color: AppSwatches.mainColor1,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: amountController,
                          decoration: const InputDecoration(
                            labelText: Strings.amount,
                            hintText: "0.00",
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 8.0,
                        right: 16.0,
                        top: 35.0,
                        bottom: 8.0,
                      ),
                      child: DropdownButton<String>(
                        hint: const Text(Strings.currency),
                        value: "MYR",
                        items: <String>[
                          "USD",
                          "EUR",
                          "GBP",
                          "CAD",
                          "AUD",
                          "MYR",
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (_) {},
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 16.0, right: 32.0),
                      child: SizedBox(
                        width: 5,
                        child: Icon(
                          Icons.wallet,
                          color: AppSwatches.mainColor1,
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Wallets',
                          style: TextStyle(
                            // color: AppSwatches.mainColor2,
                            // fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 8.0,
                        right: 16.0,
                        // top: 16.0,
                        bottom: 8.0,
                      ),
                      child: DropdownButton<String>(
                        value: "All wallet",
                        items: <String>[
                          "All wallet",
                          "wallet 1",
                          "wallet 2",
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (_) {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
