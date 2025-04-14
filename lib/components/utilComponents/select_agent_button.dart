import 'package:flutter/material.dart';
import 'package:loan_app/models/agent.dart';
import 'package:loan_app/utils/globals.dart';

class SelectAgentButton extends StatefulWidget {
  final bool? showAllAgents;
  final Agent? currentAgent;
  final ValueChanged<int?> onAgentSelected;
  const SelectAgentButton({
    super.key,
    required this.onAgentSelected,
    this.currentAgent,
    this.showAllAgents,
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
      dropdownMenuEntries: [
        if (widget.showAllAgents == true)
          DropdownMenuEntry(label: "All Agents", value: null),
        ..._agents.map(
          (agent) =>
              DropdownMenuEntry(label: agent.agentName, value: agent.agentId),
        ),
      ],
    );
  }
}
