import 'package:flutter/material.dart';
import 'package:loan_app/pages/client_page.dart';
import 'package:loan_app/utils/globals.dart';

class RemarksLinkButton extends StatefulWidget {
  final String remarks;
  final int clientId;
  final VoidCallback whenComplete;
  const RemarksLinkButton({
    super.key,
    required this.remarks,
    required this.clientId,
    required this.whenComplete,
  });

  @override
  State<RemarksLinkButton> createState() => _RemarksLinkButtonState();
}

class _RemarksLinkButtonState extends State<RemarksLinkButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        final client = await clientCrud.getClientById(widget.clientId);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ClientPage(client: client)),
        ).whenComplete(widget.whenComplete);
      },
      child: Text(widget.remarks),
    );
  }
}
