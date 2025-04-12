import 'package:loan_app/database/database.dart';
import 'package:loan_app/models/agent.dart';

class AgentCrud {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // Create New Agent
  Future<void> createAgent(Agent agent) async {
    final db = await _databaseHelper.database;
    await db.insert('agent', agent.toMap());
  }

  // Get All Agents
  Future<List<Agent>> getAllAgents() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('agent');

    return List.generate(maps.length, (index) {
      return Agent.fromMap(maps[index]);
    });
  }

  // Delete Agent By agentId
  Future<void> deleteAgent(int agentId) async {
    final db = await _databaseHelper.database;
    await db.delete('agent', where: 'agentId = ?', whereArgs: [agentId]);
  }
}
