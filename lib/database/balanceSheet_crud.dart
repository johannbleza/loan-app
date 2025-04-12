import 'package:loan_app/database/database.dart';
import 'package:loan_app/models/balanceSheet.dart';

class BalanceSheetCrud {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // Create New Balance Sheet
  Future<void> createBalanceSheet(BalanceSheet balanceSheet) async {
    final db = await _databaseHelper.database;
    await db.insert('balanceSheet', balanceSheet.toMap());
  }

  // Delete All Balance Sheet by paymentId
  Future<void> deleteBalanceSheetByPaymentId(int paymentId) async {
    final db = await _databaseHelper.database;
    await db.delete(
      'balanceSheet',
      where: 'paymentId = ?',
      whereArgs: [paymentId],
    );
  }

  // Delete All Balance Sheet by partialId
  Future<void> deleteBalanceSheetByPartialId(int partialId) async {
    final db = await _databaseHelper.database;
    await db.delete(
      'balanceSheet',
      where: 'partialId = ?',
      whereArgs: [partialId],
    );
  }

  // Get All Balance Sheets
  Future<List<BalanceSheet>> getAllBalanceSheets() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('balanceSheet');

    return List.generate(maps.length, (index) {
      return BalanceSheet.fromMap(maps[index]);
    });
  }

  // Delete Balance Sheet by ID
  Future<void> deleteBalanceSheet(int balanceSheetId) async {
    final db = await _databaseHelper.database;
    await db.delete(
      'balanceSheet',
      where: 'balanceSheetId = ?',
      whereArgs: [balanceSheetId],
    );
  }

  // Update Balance Sheet
  Future<void> updateBalanceSheet(BalanceSheet balanceSheet) async {
    final db = await _databaseHelper.database;
    await db.update(
      'balanceSheet',
      balanceSheet.toMap(),
      where: 'balanceSheetId = ?',
      whereArgs: [balanceSheet.balanceSheetId],
    );
  }
}
