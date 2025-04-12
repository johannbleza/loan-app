import 'package:flutter/material.dart';
import 'package:loan_app/components/agentsComponents/agent_list_table.dart';
import 'package:loan_app/models/agent.dart';
import 'package:loan_app/utils/globals.dart';

class AgentListScreen extends StatefulWidget {
  const AgentListScreen({super.key});

  @override
  State<AgentListScreen> createState() => _AgentListScreenState();
}

class _AgentListScreenState extends State<AgentListScreen> {
  // List of agents
  List<Agent> agentsData = [];

  // Get all agents from the database
  getAllAgents() async {
    final agents = await agentCrud.getAllAgents();

    // Get the number of clients for each agent
    for (var agent in agents) {
      var clients = await clientCrud.getClientsWithAgentNameByAgentId(
        agent.agentId!,
      );
      agent.clientCount = clients.length;
    }

    setState(() {
      agentsData = agents;
    });
  }

  @override
  void initState() {
    getAllAgents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: ListView(
        children: [
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 24),
                Text(
                  "Agent List (${agentsData.length})",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 20),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: AgentListTable(
                    agentsData: agentsData,
                    refreshAgentsTable: getAllAgents,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
