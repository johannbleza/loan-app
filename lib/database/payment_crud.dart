import 'package:jiffy/jiffy.dart';
import 'package:loan_app/database/database.dart';
import 'package:loan_app/models/client.dart';
import 'package:loan_app/models/payment.dart';
import 'package:finance_updated/finance_updated.dart';

class PaymentCrud {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // Create New Payment
  Future<void> createPayment(Payment payment) async {
    final db = await _databaseHelper.database;
    await db.insert('payment', payment.toMap());
  }

  // Generate Payments for Client
  Future<void> generatePayments(Client client) async {
    final db = await _databaseHelper.database;

    // Calculate Monthly Payment
    double monthlyPayment =
        (-Finance()
                    .pmt(
                      rate: client.interestRate / 100,
                      nper: client.loanTerm,
                      pv: client.loanAmount,
                    )
                    .toDouble() /
                10)
            .ceil()
            .toDouble() *
        10;

    // Principal Balance
    double principalBalance = client.loanAmount;

    for (int i = 0; i < client.loanTerm; i++) {
      // Date
      String paymentSchdule =
          Jiffy.parse(
            client.loanDate,
            pattern: 'MMM d, yyyy',
          ).add(months: i + 1).format(pattern: 'MMM d, yyyy').toString();

      // Calculate Interest Paid
      double interestPaid = principalBalance * (client.interestRate / 100);

      // Calculate Capital Payment
      double capitalPayment = monthlyPayment - interestPaid;

      Payment payment = Payment(
        paymentSchedule: paymentSchdule,
        principalBalance: principalBalance,
        monthlyPayment: monthlyPayment,
        interestPaid: interestPaid,
        capitalPayment: capitalPayment,
        clientId: client.clientId!,
        agentShare: interestPaid * (client.agentInterest / 100),
        remarks: 'Due',
      );

      principalBalance -= capitalPayment;

      await db.insert('payment', payment.toMap());
    }
  }

  // Get All Payments by Client ID with Interest Rate, Client Name,
  Future<List<Payment>> getAllPaymentsByClientId(int clientId) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      Select p.*, c.interestRate, c.clientName
      FROM PAYMENT AS p INNER JOIN CLIENT AS c
        ON p.clientId = c.clientId
      WHERE p.clientId = ?
    ''',
      [clientId],
    );

    return List.generate(maps.length, (index) {
      return Payment.fromMap(maps[index]);
    });
  }

  // Update Payment Remarks
  Future<void> updatePaymentRemarks(
    int paymentId,
    String paymentDate,
    String modeOfPayment,
    String remarks,
  ) async {
    final db = await _databaseHelper.database;
    await db.update(
      'payment',
      {
        'paymentDate': paymentDate,
        'modeOfPayment': modeOfPayment,
        'remarks': remarks,
      },
      where: 'paymentId = ?',
      whereArgs: [paymentId],
    );
  }

  // Update Remarks to Overdue if Payment Date is Past Due
  Future<void> updateOverduePayments() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT * FROM PAYMENT
      WHERE remarks = 'Due'
    ''');

    for (var map in maps) {
      String paymentSchdule = map['paymentSchedule'];
      String currentDate = Jiffy.now().format(pattern: 'MMM d, yyyy');

      if (Jiffy.parse(
        paymentSchdule,
        pattern: 'MMM d, yyyy',
      ).isBefore(Jiffy.parse(currentDate, pattern: 'MMM d, yyyy'))) {
        await db.update(
          'payment',
          {'remarks': 'Overdue'},
          where: 'paymentId = ?',
          whereArgs: [map['paymentId']],
        );
      }
    }
  }

  // Get Monthly Payments
  Future<List<Payment>> getMonthlyPayments() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      select p.*, c.clientName, a.agentName, c.agentId, c.loanAmount, c.loanTerm
      from payment as p inner join client as c
	      on p.clientId = c.clientId
		      inner join agent as a
		      on c.agentId = a.agentId
    ''');

    return List.generate(maps.length, (index) {
      return Payment.fromMap(maps[index]);
    });
  }

  // Get Payments Count by Client ID that are not 'Overdue' or 'Due'
  Future<int> getPaymentsCountByClientId(int clientId) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT COUNT(*) as count
      FROM PAYMENT
      WHERE clientId = ? AND remarks NOT IN ('Overdue', 'Due')
    ''',
      [clientId],
    );

    return maps[0]['count'];
  }

  // Get Overdue Payments
  Future<List<Payment>> getOverduePayments() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      select p.*, c.clientName, a.agentName, c.agentId, c.loanAmount, c.loanTerm
      from payment as p inner join client as c
	      on p.clientId = c.clientId
		      inner join agent as a
		      on c.agentId = a.agentId
      where p.remarks = 'Overdue'
    ''');

    return List.generate(maps.length, (index) {
      return Payment.fromMap(maps[index]);
    });
  }

  // Set payment remarks to 'Completed' by client ID where payment is 'Due' or "Overdue"
  Future<void> setPaymentRemarksToCompleted(int clientId) async {
    final db = await _databaseHelper.database;
    await db.update(
      'payment',
      {'remarks': 'Completed'},
      where: 'clientId = ? AND remarks IN ("Due", "Overdue")',
      whereArgs: [clientId],
    );
  }

  // Set payment remarks to 'Due' by client ID where payment is 'Completed'
  Future<void> setPaymentRemarksToDue(int clientId) async {
    final db = await _databaseHelper.database;
    await db.update(
      'payment',
      {'remarks': 'Due'},
      where: 'clientId = ? AND remarks = "Completed"',
      whereArgs: [clientId],
    );
  }
}
