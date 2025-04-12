import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:loan_app/components/utilComponents/select_date_button.dart';
import 'package:loan_app/models/balanceSheet.dart';
import 'package:loan_app/models/partial.dart';
import 'package:loan_app/models/payment.dart';
import 'package:loan_app/utils/globals.dart';

class PaymentUpdateDialog extends StatefulWidget {
  final VoidCallback onPaymentStatusUpdated;
  final Payment payment;
  const PaymentUpdateDialog({
    super.key,
    required this.payment,
    required this.onPaymentStatusUpdated,
  });

  @override
  State<PaymentUpdateDialog> createState() => _PaymentUpdateDialogState();
}

class _PaymentUpdateDialogState extends State<PaymentUpdateDialog> {
  // Text Editing Controllers
  final TextEditingController _modeOfPaymentController =
      TextEditingController();
  final TextEditingController _paymentDateController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();

  @override
  void initState() {
    _modeOfPaymentController.text = widget.payment.modeOfPayment ?? '';
    _paymentDateController.text = widget.payment.paymentDate?.toString() ?? '';
    _remarksController.text = widget.payment.remarks!;
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
              initialSelection: widget.payment.remarks,
              width: 250,
              dropdownMenuEntries: [
                DropdownMenuEntry(label: "Due", value: 'Due'),
                DropdownMenuEntry(
                  label: "Partial (Interest)",
                  value: 'Partial (Interest)',
                ),
                DropdownMenuEntry(
                  label: "Partial (Capital)",
                  value: 'Partial (Capital)',
                ),
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
                _remarksController.text != 'Due') {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Please select a payment date."),
                  duration: Duration(seconds: 2),
                ),
              );
              return;
            }

            // Set to 'Overdue' if the payment is overdue
            if (_remarksController.text == 'Due') {
              String currentDate = Jiffy.now().format(pattern: 'MMM d, yyyy');
              if (Jiffy.parse(
                widget.payment.paymentSchedule,
                pattern: 'MMM d, yyyy',
              ).isBefore(Jiffy.parse(currentDate, pattern: 'MMM d, yyyy'))) {
                _remarksController.text = 'Overdue';
              }
              _paymentDateController.clear();
              _modeOfPaymentController.clear();
            }

            paymentCrud.updatePaymentRemarks(
              widget.payment.paymentId!,
              _paymentDateController.text,
              _modeOfPaymentController.text,
              _remarksController.text,
            );

            partialCrud.deletePartial(widget.payment.paymentId!);

            // If remarks is partial create a partial payment
            if (_remarksController.text == 'Partial (Capital)') {
              partialCrud.createPartial(
                Partial(
                  interestPaid: widget.payment.interestPaid,
                  capitalPayment: 0,
                  agentShare: widget.payment.agentShare,
                  paymentId: widget.payment.paymentId!,
                  remarks: 'Unpaid',
                ),
              );
            } else if (_remarksController.text == 'Partial (Interest)') {
              partialCrud.createPartial(
                Partial(
                  interestPaid: 0,
                  capitalPayment: widget.payment.capitalPayment,
                  agentShare: widget.payment.agentShare,
                  paymentId: widget.payment.paymentId!,
                  remarks: 'Unpaid',
                ),
              );
            }

            widget.onPaymentStatusUpdated();

            // Delete Balance Sheet First
            balanceSheetCrud.deleteBalanceSheetByPaymentId(
              widget.payment.paymentId!,
            );

            // Import to Balance Sheet

            if (_remarksController.text == 'Paid') {
              balanceSheetCrud.createBalanceSheet(
                BalanceSheet(
                  date: _paymentDateController.text,
                  inAmount: widget.payment.monthlyPayment,
                  outAmount: 0,
                  balance: widget.payment.monthlyPayment,
                  remarks:
                      'Payment for ${widget.payment.clientName} - ${widget.payment.paymentSchedule}',
                  paymentId: widget.payment.paymentId,
                ),
              );
            } else if (_remarksController.text == 'Partial (Interest)') {
              balanceSheetCrud.createBalanceSheet(
                BalanceSheet(
                  date: _paymentDateController.text,
                  inAmount: widget.payment.interestPaid,
                  outAmount: 0,
                  balance: widget.payment.interestPaid,
                  remarks:
                      'Partial Payment for ${widget.payment.clientName} - ${widget.payment.paymentSchedule}',
                  paymentId: widget.payment.paymentId,
                ),
              );
            } else if (_remarksController.text == 'Partial (Capital)') {
              balanceSheetCrud.createBalanceSheet(
                BalanceSheet(
                  date: _paymentDateController.text,
                  inAmount: widget.payment.capitalPayment,
                  outAmount: 0,
                  balance: widget.payment.capitalPayment,
                  remarks:
                      'Partial Payment for ${widget.payment.clientName} - ${widget.payment.paymentSchedule}',
                  paymentId: widget.payment.paymentId,
                ),
              );
            }

            // Show a success message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Payment status updated successfully!"),
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
