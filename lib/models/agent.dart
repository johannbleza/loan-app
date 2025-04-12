class Agent {
  final int? agentId;
  final String agentName;
  final String? email;
  final String? contactNo;

  int? clientCount;

  Agent({
    this.agentId,
    required this.agentName,
    this.email,
    this.contactNo,
    this.clientCount,
  });

  Map<String, dynamic> toMap() {
    return {
      'agentId': agentId,
      'agentName': agentName,
      'email': email,
      'contactNo': contactNo,
    };
  }

  factory Agent.fromMap(Map<String, dynamic> map) {
    return Agent(
      agentId: map['agentId'],
      agentName: map['agentName'],
      email: map['email'],
      contactNo: map['contactNo'],
      clientCount: map['clientCount'],
    );
  }
}
