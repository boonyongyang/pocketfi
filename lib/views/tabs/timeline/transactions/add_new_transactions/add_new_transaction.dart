import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  AddTransactionPageState createState() => AddTransactionPageState();
}

class AddTransactionPageState extends State<AddTransactionPage> {
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
      appBar: AppBar(
        title: const Text('Add Expense'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
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
              SizedBox(
                height: 50,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Picked Date: ${DateFormat.yMd().format(_selectedDate)}',
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).primaryColor,
                      ),
                      onPressed: _selectDate,
                      child: const Text(
                        'Choose Date',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
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
      ),
    );
  }
}
