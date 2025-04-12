import 'package:flutter/material.dart';
import 'package:loan_app/utils/globals.dart';

class AgentDeleteDialog extends StatefulWidget {
  final VoidCallback onConfirmDelete;
  final int agentId;
  const AgentDeleteDialog({
    super.key,
    required this.onConfirmDelete,
    required this.agentId,
  });

  @override
  State<AgentDeleteDialog> createState() => _AgentDeleteDialogState();
}

class _AgentDeleteDialogState extends State<AgentDeleteDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Delete Agent"),
      content: const Text(
        "Are you sure you want to delete this agent and their clients?",
      ),
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
            agentCrud.deleteAgent(widget.agentId);
            Navigator.pop(context);
            widget.onConfirmDelete();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Agent deleted successfully'),
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
