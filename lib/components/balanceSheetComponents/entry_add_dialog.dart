import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loan_app/components/utilComponents/select_date_button.dart';
import 'package:loan_app/models/balanceSheet.dart';
import 'package:loan_app/utils/globals.dart';

class EntryAddDialog extends StatefulWidget {
  final VoidCallback onEntryAdded;
  const EntryAddDialog({super.key, required this.onEntryAdded});

  @override
  State<EntryAddDialog> createState() => _EntryAddDialogState();
}

class _EntryAddDialogState extends State<EntryAddDialog> {
  // Text Controllers
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _outController = TextEditingController();
  final TextEditingController _inController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Entry'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
            ],
            controller: _inController,
            decoration: InputDecoration(labelText: "Enter IN Amount"),
          ),
          SizedBox(height: 16),
          TextField(
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
            ],
            controller: _outController,
            decoration: InputDecoration(labelText: "Enter OUT Amount"),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _remarksController,
            decoration: InputDecoration(labelText: "Remarks"),
          ),
          SizedBox(height: 16),
          SelectDateButton(
            onDateSelected: (selectedDate) {
              _dateController.text = selectedDate.toString();
            },
            buttonText: "Select Date",
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            if (_dateController.text.isEmpty) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("Please select a date")));
              return;
            }
            balanceSheetCrud.createBalanceSheet(
              BalanceSheet(
                date: _dateController.text,
                inAmount:
                    _inController.text != ""
                        ? double.parse(_inController.text)
                        : 0,
                outAmount:
                    _outController.text != ""
                        ? double.parse(_outController.text)
                        : 0,
                balance:
                    _outController.text.isEmpty
                        ? double.parse(_inController.text)
                        : _inController.text.isEmpty
                        ? -double.parse(_outController.text)
                        : double.parse(_inController.text) -
                            double.parse(_outController.text),
                remarks: _remarksController.text,
              ),
            );
            widget.onEntryAdded();
            Navigator.of(context).pop();
          },
          child: Text("Add"),
        ),
      ],
    );
  }
}
