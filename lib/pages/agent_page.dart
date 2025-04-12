import 'package:flutter/material.dart';
import 'package:loan_app/components/clientsComponents/client_list_table.dart';
import 'package:loan_app/models/agent.dart';
import 'package:loan_app/models/client.dart';
import 'package:loan_app/utils/globals.dart';

class AgentPage extends StatefulWidget {
  final Agent agent;
  const AgentPage({super.key, required this.agent});

  @override
  State<AgentPage> createState() => _AgentPageState();
}

class _AgentPageState extends State<AgentPage> {
  List<Client> clientsData = [];

  // Get all clients from the database
  getAllClients() async {
    List<Client> clients = await clientCrud.getClientsWithAgentNameByAgentId(
      widget.agent.agentId!,
    );
    setState(() {
      clientsData = clients;
    });
  }

  @override
  initState() {
    getAllClients();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Agent Details",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 24),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(width: 8, color: Colors.indigo),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Agent Name:"),
                              Text(
                                widget.agent.agentName,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 40),
                          Column(
                            children: [
                              Text("No of Clients:"),
                              Text(
                                clientsData.length.toString(),
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  Text(
                    "Client List (${clientsData.length})",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ClientListTable(
                      refreshClientsTable: getAllClients,
                      clientsData: clientsData,
                      currentAgent: widget.agent,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
