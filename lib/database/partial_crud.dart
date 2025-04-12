import 'package:loan_app/database/database.dart';
import 'package:loan_app/models/partial.dart';

class PartialCrud {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // Create New Partial
  Future<void> createPartial(Partial partial) async {
    final db = await _databaseHelper.database;
    await db.insert('partial', partial.toMap());
  }

  // Get All Partials by Client ID with Payment Schedule
  Future<List<Partial>> getAllPartialsByClientId(int clientId) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT p.*, pm.paymentSchedule, c.clientName
      FROM partial as p inner join payment as pm
        on p.paymentId = pm.paymentId 
        inner join client as c
          on pm.clientId = c.clientId
      WHERE pm.clientId = ?
      ORDER BY p.paymentId 
      
    ''',
      [clientId],
    );

    return List.generate(maps.length, (index) {
      return Partial.fromMap(maps[index]);
    });
  }

  // Update Partial Remarks
  Future<void> updatePartialRemarks(
    int partialId,
    String paymentDate,
    String modeOfPayment,
    String remarks,
  ) async {
    final db = await _databaseHelper.database;
    await db.update(
      'partial',
      {
        'paymentDate': paymentDate,
        'modeOfPayment': modeOfPayment,
        'remarks': remarks,
      },
      where: 'partialId = ?',
      whereArgs: [partialId],
    );
  }

  // Delete Partial by Payment ID
  Future<void> deletePartial(int paymentId) async {
    final db = await _databaseHelper.database;
    await db.delete('partial', where: 'paymentId = ?', whereArgs: [paymentId]);
  }

  // Get partial count by client ID
  Future<int> getPartialCountByClientId(int clientId) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT COUNT(*) as count
      FROM partial
      WHERE clientId = ?
    ''',
      [clientId],
    );

    return maps[0]['count'] ?? 0;
  }
}
