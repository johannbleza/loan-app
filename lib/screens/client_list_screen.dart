import 'package:flutter/material.dart';
import 'package:loan_app/components/clientsComponents/client_list_table.dart';
import 'package:loan_app/models/client.dart';
import 'package:loan_app/utils/globals.dart';

class ClientListScreen extends StatefulWidget {
  const ClientListScreen({super.key});

  @override
  State<ClientListScreen> createState() => _ClientListScreenState();
}

class _ClientListScreenState extends State<ClientListScreen> {
  List<Client> clientsData = [];

  getAllClients() async {
    final clients = await clientCrud.getAllClientsWithAgentName();
    setState(() {
      clientsData = clients;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getAllClients();
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
                  "Client List (${clientsData.length})",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 20),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ClientListTable(
                    clientsData: clientsData,
                    refreshClientsTable: getAllClients,
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
