import 'package:flutter/material.dart';
import 'package:loan_app/utils/globals.dart';

class ClientDeleteDialog extends StatefulWidget {
  final VoidCallback onConfirmDelete;
  final int clientId;
  const ClientDeleteDialog({
    super.key,
    required this.onConfirmDelete,
    required this.clientId,
  });

  @override
  State<ClientDeleteDialog> createState() => _ClientDeleteDialogState();
}

class _ClientDeleteDialogState extends State<ClientDeleteDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Delete Agent"),
      content: const Text("Are you sure you want to delete this client?"),
      actions: [
        // Cancel Button
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),
        // Delete Button
        TextButton(
          onPressed: () {
            clientCrud.deleteClient(widget.clientId);
            Navigator.pop(context);
            widget.onConfirmDelete();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Client deleted successfully'),
                duration: Duration(seconds: 2),
              ),
            );
          },
          child: Text("Delete"),
        ),
      ],
    );
  }
}
