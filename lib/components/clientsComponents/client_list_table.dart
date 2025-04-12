import 'package:flutter/material.dart';
import 'package:loan_app/components/clientsComponents/client_add_dialog.dart';
import 'package:loan_app/components/clientsComponents/client_delete_dialog.dart';
import 'package:loan_app/components/utilComponents/term_completed.dart';
import 'package:loan_app/models/agent.dart';
import 'package:loan_app/models/client.dart';
import 'package:loan_app/pages/client_page.dart';

class ClientListTable extends StatefulWidget {
  final VoidCallback refreshClientsTable;
  final Agent? currentAgent;
  final List<Client> clientsData;
  const ClientListTable({
    super.key,
    required this.refreshClientsTable,
    required this.clientsData,
    this.currentAgent,
  });

  @override
  State<ClientListTable> createState() => _ClientListTableState();
}

class _ClientListTableState extends State<ClientListTable> {
  @override
  Widget build(BuildContext context) {
    return DataTable(
      columnSpacing: 40,
      columns: [
        DataColumn(label: Text('')),
        DataColumn(label: Text('Client Name')),
        DataColumn(label: Text('Loan Amount')),
        DataColumn(label: Text('Term Completed')),
        DataColumn(label: Text('Interest Rate')),
        DataColumn(label: Text('Loan Date')),
        DataColumn(label: Text('Agent Name')),
        DataColumn(label: Text('Agent Share')),
        DataColumn(
          label: TextButton(
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.blue),
              foregroundColor: WidgetStatePropertyAll(Colors.white),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder:
                    (context) => ClientAddDialog(
                      currentAgent: widget.currentAgent,
                      onClientAdded: () {
                        widget.refreshClientsTable();
                      },
                    ),
              );
            },
            child: Text('Add Client +'),
          ),
        ),
      ],
      rows:
          widget.clientsData
              .map(
                (client) => DataRow(
                  cells: [
                    DataCell(
                      Text((widget.clientsData.indexOf(client) + 1).toString()),
                    ),
                    DataCell(
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ClientPage(client: client),
                            ),
                          ).whenComplete(() {
                            widget.refreshClientsTable();
                          });
                        },
                        child: Text(client.clientName),
                      ),
                    ),
                    DataCell(
                      Text(
                        '₱${client.loanAmount.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+\.)'), (Match m) => '${m[1]},')}',
                      ),
                    ),
                    DataCell(
                      Center(
                        child: TermCompleted(
                          clientId: client.clientId!,
                          key: ValueKey(
                            'term_${client.clientId}_${DateTime.now().millisecondsSinceEpoch}',
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      Text("${client.interestRate.toStringAsFixed(2)}%"),
                    ),
                    DataCell(Text(client.loanDate.toString())),
                    DataCell(Text(client.agentName!)),
                    DataCell(
                      Text("${client.agentInterest.toStringAsFixed(2)}%"),
                    ),
                    DataCell(
                      Center(
                        child: IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return ClientDeleteDialog(
                                  clientId: client.clientId!,
                                  onConfirmDelete: () {
                                    widget.refreshClientsTable();
                                  },
                                );
                              },
                            );
                          },
                          icon: Icon(Icons.delete),
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
