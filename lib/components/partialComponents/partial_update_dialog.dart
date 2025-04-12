import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:loan_app/components/utilComponents/select_date_button.dart';
import 'package:loan_app/models/balanceSheet.dart';
import 'package:loan_app/models/partial.dart';
import 'package:loan_app/utils/globals.dart';

class PartialUpdateDialog extends StatefulWidget {
  final VoidCallback onPartialStatusUpdated;
  final Partial partial;
  const PartialUpdateDialog({
    super.key,
    required this.partial,
    required this.onPartialStatusUpdated,
  });

  @override
  State<PartialUpdateDialog> createState() => _PartialUpdateDialogState();
}

class _PartialUpdateDialogState extends State<PartialUpdateDialog> {
  // Text Editing Controllers
  final TextEditingController _modeOfPaymentController =
      TextEditingController();
  final TextEditingController _paymentDateController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();

  @override
  void initState() {
    _modeOfPaymentController.text = widget.partial.modeOfPayment ?? '';
    _paymentDateController.text = widget.partial.paymentDate?.toString() ?? '';
    _remarksController.text = widget.partial.remarks!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Update Payment Status"),
      content: SizedBox(
        width: 250,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _modeOfPaymentController,
              decoration: InputDecoration(labelText: "Mode of Payment"),
            ),
            SizedBox(height: 16),
            SelectDateButton(
              buttonText: "Select Payment Date",
              onDateSelected: (date) {
                setState(() {
                  _paymentDateController.text = date.toString();
                });
              },
            ),
            SizedBox(height: 16),
            DropdownMenu(
              controller: _remarksController,
              initialSelection: widget.partial.remarks,
              width: 250,
              dropdownMenuEntries: [
                DropdownMenuEntry(label: "Unpaid", value: 'Unpaid'),
                DropdownMenuEntry(label: "Paid", value: 'Paid'),
              ],
              onSelected: (value) {
                setState(() {
                  _remarksController.text = value!;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            if (_paymentDateController.text.isEmpty &&
                _remarksController.text != 'Unpaid') {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Please select a payment date."),
                  duration: Duration(seconds: 2),
                ),
              );
              return;
            }

            if (_remarksController.text == 'Unpaid') {
              _paymentDateController.clear();
              _modeOfPaymentController.clear();
            }

            partialCrud.updatePartialRemarks(
              widget.partial.partialId!,
              _paymentDateController.text,
              _modeOfPaymentController.text,
              _remarksController.text,
            );

            widget.onPartialStatusUpdated();

            // Delete first
            balanceSheetCrud.deleteBalanceSheetByPartialId(
              widget.partial.partialId!,
            );

            // Import to Balance Sheet
            if (_remarksController.text == 'Paid') {
              balanceSheetCrud.createBalanceSheet(
                BalanceSheet(
                  date: _paymentDateController.text,
                  inAmount:
                      widget.partial.capitalPayment +
                      widget.partial.interestPaid,
                  outAmount: 0,
                  balance:
                      widget.partial.capitalPayment +
                      widget.partial.interestPaid,
                  remarks:
                      '${widget.partial.clientName} - Partial Payment Completed for ${Jiffy.parse(widget.partial.paymentSchedule!, pattern: 'MMM d, yyyy').format(pattern: 'MMM yyyy')}',
                  partialId: widget.partial.partialId,
                ),
              );
            }

            // Show a success message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Partial Payment status updated successfully!"),
                duration: Duration(seconds: 2),
              ),
            );
            Navigator.pop(context);
          },
          child: Text("Update"),
        ),
      ],
    );
  }
}
