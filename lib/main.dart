import 'package:flutter/material.dart';
import 'package:loan_app/database/agent_crud.dart';
// import 'package:loan_app/database/agent_crud.dart';
import 'package:loan_app/database/database.dart';
import 'package:loan_app/models/agent.dart';
import 'package:loan_app/screens/agent_list_screen.dart';
import 'package:loan_app/screens/balance_sheet_list_screen.dart';
import 'package:loan_app/screens/client_list_screen.dart';
import 'package:loan_app/screens/home_overview_screen.dart';
import 'package:loan_app/screens/monthly_report_screen.dart';
import 'package:loan_app/screens/overdue_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // sqfliteFfiInit();
  // databaseFactory = databaseFactoryFfi;
  await DatabaseHelper().database;
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AgentCrud agentCrud = AgentCrud();
  // Navigation rail index
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loan Management System',
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await agentCrud.createAgent(Agent(agentName: 'Bleza'));
          },
        ),
        body: Row(
          children: [
            NavigationRail(
              leading: SizedBox(height: 80),
              // minWidth: 100,
              labelType: NavigationRailLabelType.all,
              elevation: 10,

              // Change Index
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              // Show selected index
              destinations: [
                NavigationRailDestination(
                  icon: Icon(Icons.home),
                  label: Text('Home'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.person),
                  label: Text('Agent'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.people),
                  label: Text('Clients'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.calendar_month),
                  label: Text('Monthly\nReport', textAlign: TextAlign.center),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.error),
                  label: Text('Overdue\nPayments', textAlign: TextAlign.center),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.monetization_on_outlined),
                  label: Text('Balance\nSheet', textAlign: TextAlign.center),
                ),
              ],
              selectedIndex: _selectedIndex,
            ),
            Expanded(child: _buildScreen()),
          ],
        ),
      ),
    );
  }

  Widget _buildScreen() {
    switch (_selectedIndex) {
      case 0:
        return HomeOverviewScreen();
      case 1:
        return AgentListScreen();
      case 2:
        return ClientListScreen();
      case 3:
        return MonthlyReportScreen();
      case 4:
        return OverdueListScreen();
      case 5:
        return BalanceSheetListScreen();
      default:
        return HomeOverviewScreen();
    }
  }
}
