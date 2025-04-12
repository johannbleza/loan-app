class Client {
  final int? clientId;
  final String clientName;
  final double loanAmount;
  final int loanTerm;
  final double interestRate;
  final String loanDate;
  final int agentId;
  final double agentInterest;

  final String? agentName;

  Client({
    this.clientId,
    required this.clientName,
    required this.loanAmount,
    required this.loanTerm,
    required this.interestRate,
    required this.loanDate,
    required this.agentId,
    required this.agentInterest,
    this.agentName,
  });

  Map<String, dynamic> toMap() {
    return {
      'clientId': clientId,
      'clientName': clientName,
      'loanAmount': loanAmount,
      'loanTerm': loanTerm,
      'interestRate': interestRate,
      'loanDate': loanDate,
      'agentId': agentId,
      'agentInterest': agentInterest,
    };
  }

  factory Client.fromMap(Map<String, dynamic> map) {
    return Client(
      clientId: map['clientId'],
      clientName: map['clientName'],
      loanAmount: map['loanAmount'],
      loanTerm: map['loanTerm'],
      interestRate: map['interestRate'],
      loanDate: map['loanDate'],
      agentId: map['agentId'],
      agentInterest: map['agentInterest'],
      agentName: map['agentName'],
    );
  }
}
