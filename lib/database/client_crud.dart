import 'package:loan_app/database/database.dart';
import 'package:loan_app/models/client.dart';

class ClientCrud {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // Create New Client
  Future<void> createClient(Client client) async {
    final db = await _databaseHelper.database;
    await db.insert('client', client.toMap());
  }

  // Get Client by clientId
  Future<Client?> getClientByClientId(int clientId) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'client',
      where: 'clientId = ?',
      whereArgs: [clientId],
    );

    if (maps.isNotEmpty) {
      return Client.fromMap(maps[0]);
    }
    return null;
  }

  // Get All Clients
  Future<List<Client>> getAllClients() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('client');

    return List.generate(maps.length, (index) {
      return Client.fromMap(maps[index]);
    });
  }

  // Get All Clients with Agent Name
  Future<List<Client>> getAllClientsWithAgentName() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      Select c.*, a.agentName
      FROM CLIENT AS c INNER JOIN AGENT AS a
        ON c.agentId = a.agentId
    ''');

    return List.generate(maps.length, (index) {
      return Client.fromMap(maps[index]);
    });
  }

  // Get Clients with Agent Name by Agent ID
  Future<List<Client>> getClientsWithAgentNameByAgentId(int agentId) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      Select c.*, a.agentName
      FROM CLIENT AS c INNER JOIN AGENT AS a
        ON c.agentId = a.agentId
      WHERE c.agentId = ?
    ''',
      [agentId],
    );

    return List.generate(maps.length, (index) {
      return Client.fromMap(maps[index]);
    });
  }

  // Delete Client
  Future<void> deleteClient(int clientId) async {
    final db = await _databaseHelper.database;
    await db.delete('client', where: 'clientId = ?', whereArgs: [clientId]);
  }

  // Get Number of Clients by Agent ID
  Future<int> getNumberOfClientsByAgentId(int agentId) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT COUNT(*) AS clientCount
      FROM CLIENT
      WHERE agentId = ?
    ''',
      [agentId],
    );

    return maps[0]['clientCount'] as int;
  }

  // Get Most Recent Client
  Future<Client> getMostRecentClient() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'client',
      orderBy: 'clientId DESC',
      limit: 1,
    );

    return Client.fromMap(maps[0]);
  }

  // Get Client by ID with Agent Name
  Future<Client> getClientById(int clientId) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      Select c.*, a.agentName
      FROM CLIENT AS c INNER JOIN AGENT AS a
        ON c.agentId = a.agentId
      WHERE c.clientId = ?
    ''',
      [clientId],
    );

    return Client.fromMap(maps[0]);
  }
}
