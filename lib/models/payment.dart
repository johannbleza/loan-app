class Payment {
  final int? paymentId;
  final String paymentSchedule;
  final double principalBalance;
  final double monthlyPayment;
  final double interestPaid;
  final double capitalPayment;
  final double agentShare;
  final String? paymentDate;
  final String? modeOfPayment;
  final String? remarks;
  final int clientId;
  final double? interestRate;

  final String? clientName;
  final String? agentName;
  final int? agentId;
  final int? loanTerm;
  final double? loanAmount;

  final double? agentInterest;
  final int? isFlexible;

  Payment({
    this.paymentId,
    required this.paymentSchedule,
    required this.principalBalance,
    required this.monthlyPayment,
    required this.interestPaid,
    required this.capitalPayment,
    required this.agentShare,
    this.paymentDate,
    this.modeOfPayment,
    this.remarks,
    required this.clientId,
    this.interestRate,
    this.clientName,
    this.agentName,
    this.agentId,
    this.loanTerm,
    this.loanAmount,
    this.agentInterest,
    this.isFlexible,
  });

  Map<String, dynamic> toMap() {
    return {
      'paymentId': paymentId,
      'paymentSchedule': paymentSchedule,
      'principalBalance': principalBalance,
      'monthlyPayment': monthlyPayment,
      'interestPaid': interestPaid,
      'capitalPayment': capitalPayment,
      'agentShare': agentShare,
      'paymentDate': paymentDate,
      'modeOfPayment': modeOfPayment,
      'remarks': remarks,
      'clientId': clientId,
    };
  }

  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      paymentId: map['paymentId'],
      paymentSchedule: map['paymentSchedule'],
      principalBalance: map['principalBalance'],
      monthlyPayment: map['monthlyPayment'],
      interestPaid: map['interestPaid'],
      capitalPayment: map['capitalPayment'],
      agentShare: map['agentShare'],
      paymentDate: map['paymentDate'],
      modeOfPayment: map['modeOfPayment'],
      remarks: map['remarks'],
      clientId: map['clientId'],
      interestRate: map['interestRate'],
      clientName: map['clientName'],
      agentName: map['agentName'],
      agentId: map['agentId'],
      loanTerm: map['loanTerm'],
      loanAmount: map['loanAmount'],
      agentInterest: map['agentInterest'],
      isFlexible: map['isFlexible'],
    );
  }
}
