import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AddNewTransaction extends StatefulWidget {
  const AddNewTransaction({super.key});

  @override
  AddNewTransactionState createState() => AddNewTransactionState();
}

class AddNewTransactionState extends State<AddNewTransaction> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  String _selectedRecurrence = 'Never';

  DateTime _selectedDate = DateTime.now();

  void _submitData() {
    final enteredAmount = double.parse(_amountController.text);
    final enteredNote = _noteController.text;

    if (enteredAmount <= 0 || enteredNote.isEmpty) {
      return;
    }

    // Your code to handle adding the expense to the data source goes here
    Navigator.of(context).pop();
  }

  void _selectDate() {
    showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //       body: SfDateRangePicker(
  //     view: DateRangePickerView.month,
  //     selectionMode: DateRangePickerSelectionMode.single,
  //   ));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // elevation: 0,
        shadowColor: Colors.transparent,
        // title: const Text('Add Expense'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Container(
          // color: Colors.transparent,
          padding: EdgeInsets.only(
            top: 50,
            left: 0,
            right: 0,
            // bottom: MediaQuery.of(context).viewInsets.bottom + 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
                child: Container(
                  padding: const EdgeInsets.only(
                    top: 60,
                    left: 15,
                    right: 15,
                  ),
                  height: 150,
                  color: Colors.red[300],
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        child: const Icon(
                          Icons.restaurant,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        'Food and Drinks',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      const Text('RM 0.0',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          )),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 24.0,
                  right: 24.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextField(
                      decoration: const InputDecoration(labelText: 'Amount'),
                      controller: _amountController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      onSubmitted: (_) => _submitData(),
                    ),
                    TextField(
                      decoration: const InputDecoration(labelText: 'Note'),
                      controller: _noteController,
                      onSubmitted: (_) => _submitData(),
                    ),
                    Row(
                      children: [
                        const Text(
                          'Date: ',
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Theme.of(context).primaryColor,
                          ),
                          onPressed: _selectDate,
                          child: Text(
                            DateFormat.yMd().format(_selectedDate),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // Spacer(),
                        Expanded(
                          child: TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.grey,
                            ),
                            onPressed: _selectDate,
                            child: const Text(
                              'Today?',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Recurrence:'),
                        DropdownButton(
                          items: const [
                            DropdownMenuItem(
                              value: 'Never',
                              child: Text('Never'),
                            ),
                            DropdownMenuItem(
                              value: 'Everyday',
                              child: Text('Everyday'),
                            ),
                            DropdownMenuItem(
                              value: 'Every Work Day',
                              child: Text('Every Work Day'),
                            ),
                            DropdownMenuItem(
                              value: 'Every Week',
                              child: Text('Every Week'),
                            ),
                            DropdownMenuItem(
                              value: 'Every 2 Weeks',
                              child: Text('Every 2 Weeks'),
                            ),
                            DropdownMenuItem(
                              value: 'Every Month',
                              child: Text('Every Month'),
                            ),
                            DropdownMenuItem(
                              value: 'Every Year',
                              child: Text('Every Year'),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedRecurrence = value!;
                            });
                          },
                          value: _selectedRecurrence,
                        ),
                      ],
                    ),
                    ElevatedButton(
                      child: const Text('Categories'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AddNewTransaction(),
                          ),
                        );
                      },
                    ),
                    ElevatedButton(
                      child: const Text('Add Expense'),
                      onPressed: () {
                        // show snackbar
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Expense added'),
                          ),
                        );
                        _submitData();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
