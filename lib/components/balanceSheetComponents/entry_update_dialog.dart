import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loan_app/components/utilComponents/select_date_button.dart';
import 'package:loan_app/models/balanceSheet.dart';
import 'package:loan_app/utils/globals.dart';

class EntryUpdateDialog extends StatefulWidget {
  final BalanceSheet balanceSheet;
  final VoidCallback onEntryUpdated;
  const EntryUpdateDialog({
    super.key,
    required this.onEntryUpdated,
    required this.balanceSheet,
  });

  @override
  State<EntryUpdateDialog> createState() => _EntryUpdateDialogState();
}

class _EntryUpdateDialogState extends State<EntryUpdateDialog> {
  // Text Controllers
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _outController = TextEditingController();
  final TextEditingController _inController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _dateController.text = widget.balanceSheet.date.toString();
    _outController.text = widget.balanceSheet.outAmount.toString();
    _inController.text = widget.balanceSheet.inAmount.toString();
    _remarksController.text = widget.balanceSheet.remarks ?? "";
    return AlertDialog(
      title: Text('Edit Entry'),
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
            balanceSheetCrud.updateBalanceSheet(
              BalanceSheet(
                balanceSheetId: widget.balanceSheet.balanceSheetId,
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
            widget.onEntryUpdated();
            // Show success snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Entry updated successfully"),
                duration: Duration(seconds: 2),
              ),
            );
            Navigator.of(context).pop();
          },
          child: Text("Apply"),
        ),
      ],
    );
  }
}
