class Partial {
  final int? partialId;
  final double interestPaid;
  final double capitalPayment;
  final double agentShare;
  final String? paymentDate;
  final String? modeOfPayment;
  final String? remarks;
  final int paymentId;
  final String? paymentSchedule;
  final String? clientName;

  Partial({
    this.partialId,
    required this.interestPaid,
    required this.capitalPayment,
    required this.agentShare,
    this.paymentDate,
    this.modeOfPayment,
    this.remarks,
    required this.paymentId,
    this.paymentSchedule,
    this.clientName,
  });

  Map<String, dynamic> toMap() {
    return {
      'partialId': partialId,
      'interestPaid': interestPaid,
      'capitalPayment': capitalPayment,
      'agentShare': agentShare,
      'paymentDate': paymentDate,
      'modeOfPayment': modeOfPayment,
      'remarks': remarks,
      'paymentId': paymentId,
    };
  }

  factory Partial.fromMap(Map<String, dynamic> map) {
    return Partial(
      partialId: map['partialId'],
      interestPaid: map['interestPaid'],
      capitalPayment: map['capitalPayment'],
      agentShare: map['agentShare'],
      paymentDate: map['paymentDate'],
      modeOfPayment: map['modeOfPayment'],
      remarks: map['remarks'],
      paymentId: map['paymentId'],
      paymentSchedule: map['paymentSchedule'],
      clientName: map['clientName'],
    );
  }
}
