import 'package:flutter/material.dart';
import 'package:loan_app/models/payment.dart';
import 'package:loan_app/pages/client_page.dart';
import 'package:loan_app/utils/globals.dart';

class ClientPageButton extends StatefulWidget {
  final Payment payment;
  final VoidCallback whenComplete;
  const ClientPageButton({
    super.key,
    required this.payment,
    required this.whenComplete,
  });

  @override
  State<ClientPageButton> createState() => _ClientPageButtonState();
}

class _ClientPageButtonState extends State<ClientPageButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        final client = await clientCrud.getClientById(widget.payment.clientId);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ClientPage(client: client)),
        ).whenComplete(() {
          widget.whenComplete();
        });
      },
      child: Text(widget.payment.clientName!),
    );
  }
}
