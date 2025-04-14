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
        paymentCrud.deletePaymentByClientId(widget.client.clientId!);
        await paymentCrud.generatePayments(widget.client);
        await paymentCrud.updateOverduePayments();

        widget.onReset();
      },
      child: Text("Reset Schedule"),
    );
  }
}
