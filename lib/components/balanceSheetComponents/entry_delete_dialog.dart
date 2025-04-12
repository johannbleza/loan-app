import 'package:flutter/material.dart';
import 'package:loan_app/utils/globals.dart';

class EntryDeleteDialog extends StatefulWidget {
  final VoidCallback onConfirmDelete;
  final int balanceSheetId;
  const EntryDeleteDialog({
    super.key,
    required this.onConfirmDelete,
    required this.balanceSheetId,
  });

  @override
  State<EntryDeleteDialog> createState() => _EntryDeleteDialogState();
}

class _EntryDeleteDialogState extends State<EntryDeleteDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Delete Entry"),
      content: const Text("Are you sure you want to delete this entry?"),
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
            balanceSheetCrud.deleteBalanceSheet(widget.balanceSheetId);
            Navigator.pop(context);
            widget.onConfirmDelete();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Entry deleted successfully'),
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
