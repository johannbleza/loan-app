class BalanceSheet {
  final int? balanceSheetId;
  final String date;
  final double inAmount;
  final double outAmount;
  final double balance;
  final String? remarks;
  final int? paymentId;
  final int? clientId;
  final int? partialId;

  BalanceSheet({
    this.balanceSheetId,
    required this.date,
    required this.inAmount,
    required this.outAmount,
    required this.balance,
    this.remarks,
    this.paymentId,
    this.clientId,
    this.partialId,
  });

  Map<String, dynamic> toMap() {
    return {
      'balanceSheetId': balanceSheetId,
      'date': date,
      'inAmount': inAmount,
      'outAmount': outAmount,
      'balance': balance,
      'remarks': remarks,
      'paymentId': paymentId,
      'clientId': clientId,
      'partialId': partialId,
    };
  }

  factory BalanceSheet.fromMap(Map<String, dynamic> map) {
    return BalanceSheet(
      balanceSheetId: map['balanceSheetId'],
      date: map['date'],
      inAmount: map['inAmount'],
      outAmount: map['outAmount'],
      balance: map['balance'],
      remarks: map['remarks'],
      paymentId: map['paymentId'],
      clientId: map['clientId'],
      partialId: map['partialId'],
    );
  }
}
