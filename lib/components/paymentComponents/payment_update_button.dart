import 'package:flutter/material.dart';
import 'package:loan_app/components/paymentComponents/payment_update_dialog.dart';
import 'package:loan_app/models/payment.dart';
import 'package:loan_app/utils/globals.dart';

class PaymentUpdateButton extends StatefulWidget {
  final Payment payment;
  final List<Payment> paymentsData;
  final VoidCallback onPaymentStatusUpdated;
  final bool? showFullyPaidOption;
  const PaymentUpdateButton({
    super.key,
    required this.payment,
    required this.paymentsData,
    required this.onPaymentStatusUpdated,
    this.showFullyPaidOption,
  });

  @override
  State<PaymentUpdateButton> createState() => _PaymentUpdateButtonState();
}

class _PaymentUpdateButtonState extends State<PaymentUpdateButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(
          widget.payment.remarks == "Paid" ||
                  widget.payment.remarks == "Fully Paid"
              ? Colors.green
              : (widget.payment.remarks == "Partial (Interest)" ||
                  widget.payment.remarks == "Partial (Capital)")
              ? Colors.lightGreen
              : widget.payment.remarks == "Overdue"
              ? Colors.red
              : widget.payment.remarks == "Completed"
              ? Colors.blueGrey
              : Colors.orange,
        ),
        foregroundColor: WidgetStatePropertyAll(Colors.white),
      ),
      onPressed: () {
        if (widget.payment.remarks == "Completed") {
          return;
        }
        // If payment behind is not paid disable the button
        // if (widget.paymentsData.indexOf(widget.payment) != 0 &&
        //     (widget
        //                 .paymentsData[widget.paymentsData.indexOf(
        //                       widget.payment,
        //                     ) -
        //                     1]
        //                 .remarks ==
        //             "Due" ||
        //         widget
        //                 .paymentsData[widget.paymentsData.indexOf(
        //                       widget.payment,
        //                     ) -
        //                     1]
        //                 .remarks ==
        //             "Overdue")) {
        //   // Show SnackBar
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(
        //       content: Text("Please update the previous payment first."),
        //       duration: Duration(seconds: 2),
        //     ),
        //   );
        //   return;
        // }

        showDialog(
          context: context,
          builder:
              (context) => PaymentUpdateDialog(
                isFlexible: widget.payment.isFlexible,
                showFullyPaidOption: widget.showFullyPaidOption,
                payment: widget.payment,
                onPaymentStatusUpdated: () {
                  paymentCrud.updateOverduePayments();
                  widget.onPaymentStatusUpdated();
                },
                paymentsData: widget.paymentsData,
              ),
        );
      },
      child: Text(widget.payment.remarks!),
    );
  }
}
