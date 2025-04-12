import 'package:flutter/material.dart';
import 'package:loan_app/models/agent.dart';
import 'package:loan_app/utils/globals.dart';

class SelectAgentButton extends StatefulWidget {
  final Agent? currentAgent;
  final ValueChanged<int?> onAgentSelected;
  const SelectAgentButton({
    super.key,
    required this.onAgentSelected,
    this.currentAgent,
  });

  @override
  State<SelectAgentButton> createState() => _SelectAgentButtonState();
}

class _SelectAgentButtonState extends State<SelectAgentButton> {
  int? selectedAgentId;
  late List<Agent> _agents =
      widget.currentAgent != null ? [widget.currentAgent!] : [];

  getAgents() async {
    List<Agent> agents = await agentCrud.getAllAgents();
    setState(() {
      _agents = agents;
    });
  }

  @override
  void initState() {
    getAgents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      initialSelection: widget.currentAgent?.agentId,
      width: 280,
      label: Text('Select Agent'),
      onSelected: (value) {
        setState(() {
          selectedAgentId = value;
          widget.onAgentSelected(value);
        });
      },
      dropdownMenuEntries:
          _agents
              .map(
                (agent) => DropdownMenuEntry(
                  label: agent.agentName,
                  value: agent.agentId,
                ),
              )
              .toList(),
    );
  }
}
