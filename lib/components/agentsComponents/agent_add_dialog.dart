import 'package:flutter/material.dart';
import 'package:loan_app/models/agent.dart';
import 'package:loan_app/utils/globals.dart';

class AgentAddDialog extends StatefulWidget {
  final VoidCallback onAgentAdded;
  const AgentAddDialog({super.key, required this.onAgentAdded});

  @override
  State<AgentAddDialog> createState() => _AgentAddDialogState();
}

class _AgentAddDialogState extends State<AgentAddDialog> {
  // Text Controllers
  final TextEditingController _agentNameController = TextEditingController();
  final TextEditingController _agentEmailController = TextEditingController();
  final TextEditingController _agentContactNoController =
      TextEditingController();

  // Dispose Text Controllers
  void clearTextControllers() {
    _agentNameController.clear();
    _agentEmailController.clear();
    _agentContactNoController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add Agent"),
      actions: [
        // Cancel Button
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Cancel"),
        ),
        // Add Button
        TextButton(
          onPressed: () {
            if (_agentNameController.text.isEmpty) {
              // Show a SnackBar indicating that agent name is required
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Agent name is required'),
                  duration: Duration(seconds: 2),
                ),
              );
              return;
            }

            agentCrud.createAgent(
              Agent(
                agentName: _agentNameController.text,
                email: _agentEmailController.text,
                contactNo: _agentContactNoController.text,
              ),
            );

            clearTextControllers();
            Navigator.pop(context);
            widget.onAgentAdded();

            // Show a SnackBar indicating that agent was added successfully
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Agent added successfully'),
                duration: Duration(seconds: 2),
              ),
            );
          },
          child: Text("Add"),
        ),
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _agentNameController,
            decoration: InputDecoration(labelText: "Agent Name (Required)"),
          ),
          TextField(
            controller: _agentEmailController,
            decoration: InputDecoration(labelText: "Email (Optional)"),
          ),
          TextField(
            controller: _agentContactNoController,
            decoration: InputDecoration(labelText: "Contact No (Optional)"),
          ),
        ],
      ),
    );
  }
}
