import 'package:flutter/material.dart';
import 'package:loan_app/models/client.dart';
import 'package:loan_app/utils/globals.dart';

class ResetPaymentScheduleButton extends StatefulWidget {
  final Client client;
  final VoidCallback onReset;
  const ResetPaymentScheduleButton({
    super.key,
    required this.client,
    required this.onReset,
  });

  @override
  State<ResetPaymentScheduleButton> createState() =>
      _ResetPaymentScheduleButtonState();
}

class _ResetPaymentScheduleButtonState
    extends State<ResetPaymentScheduleButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
      ),
      onPressed: () async {
        final confirm = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Confirm Reset"),
              content: Text(
                "Are you sure you want to reset the payment schedule?\nThis action cannot be undone.",
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text("Cancel"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text("Confirm"),
                ),
              ],
            );
          },
        );

        if (confirm == true) {
          paymentCrud.deletePaymentByClientId(widget.client.clientId!);
          if (widget.client.isFlexible == 1) {
            await paymentCrud.generateFlexiblePayment(widget.client);
          } else {
            await paymentCrud.generatePayments(widget.client);
          }
          await paymentCrud.updateOverduePayments();

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Payment schedule reset successfully.")),
          );

          widget.onReset();
        }
      },
      child: Text("Reset Schedule"),
    );
  }
}
