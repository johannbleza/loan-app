import 'package:flutter/material.dart';
import 'package:loan_app/components/agentsComponents/agent_add_dialog.dart';
import 'package:loan_app/components/agentsComponents/agent_delete_dialog.dart';
import 'package:loan_app/models/agent.dart';
import 'package:loan_app/pages/agent_page.dart';

class AgentListTable extends StatefulWidget {
  final VoidCallback refreshAgentsTable;
  final List<Agent> agentsData;
  const AgentListTable({
    super.key,
    required this.agentsData,
    required this.refreshAgentsTable,
  });

  @override
  State<AgentListTable> createState() => _AgentListTableState();
}

class _AgentListTableState extends State<AgentListTable> {
  @override
  Widget build(BuildContext context) {
    return DataTable(
      columnSpacing: 100,
      columns: [
        DataColumn(label: Text("")),
        DataColumn(label: Text("Agent Name")),
        DataColumn(label: Text("Email")),
        DataColumn(label: Text("Contact No")),
        DataColumn(label: Text("No of Clients")),
        DataColumn(
          label: TextButton(
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.blue),
              foregroundColor: WidgetStatePropertyAll(Colors.white),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  // Refreshes the agent list after adding a new agent
                  return AgentAddDialog(
                    onAgentAdded: () => widget.refreshAgentsTable(),
                  );
                },
              );
            },
            child: Text("Add Agent +"),
          ),
        ),
      ],
      rows:
          widget.agentsData
              .map(
                (agent) => DataRow(
                  cells: [
                    DataCell(
                      Text((widget.agentsData.indexOf(agent) + 1).toString()),
                    ),
                    DataCell(
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AgentPage(agent: agent),
                            ),
                          ).whenComplete(() {
                            widget.refreshAgentsTable();
                          });
                        },
                        child: Text(agent.agentName),
                      ),
                    ),
                    DataCell(Text(agent.email ?? "")),
                    DataCell(Text(agent.contactNo ?? "")),
                    DataCell(Text(agent.clientCount?.toString() ?? "0")),
                    // Delete Agent Button
                    DataCell(
                      Center(
                        child: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder:
                                  (context) => AgentDeleteDialog(
                                    agentId: agent.agentId!,
                                    onConfirmDelete:
                                        () => widget.refreshAgentsTable(),
                                  ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
    );
  }
}
