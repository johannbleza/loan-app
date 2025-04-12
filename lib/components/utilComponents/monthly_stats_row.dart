import 'package:flutter/material.dart';
import 'package:loan_app/models/payment.dart';

class MonthlyStatsRow extends StatefulWidget {
  final List<Payment> paymentsData;
  const MonthlyStatsRow({super.key, required this.paymentsData});

  @override
  State<MonthlyStatsRow> createState() => _MonthlyStatsRowState();
}

class _MonthlyStatsRowState extends State<MonthlyStatsRow> {
  double getTotalPayments() {
    double total = 0;
    for (var payment in widget.paymentsData) {
      if (payment.remarks == "Paid") {
        total += payment.monthlyPayment;
      } else if (payment.remarks == "Partial (Interest)") {
        total += payment.interestPaid;
      } else if (payment.remarks == "Partial (Capital)") {
        total += payment.capitalPayment;
      }
    }

    return total;
  }

  double getAgentShare() {
    double total = 0;
    for (var payment in widget.paymentsData) {
      if (payment.remarks == "Paid") {
        total += payment.agentShare;
      } else if (payment.remarks == "Partial (Interest)") {
        total += payment.agentShare;
      } else if (payment.remarks == "Partial (Capital)") {
        total += payment.agentShare;
      }
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              children: [
                Text("Total Payments Collected:"),
                Text(
                  "₱${getTotalPayments().toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 24),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              children: [
                Text("Less Agent Share (${widget.paymentsData[0].agentName}):"),
                Text(
                  "₱${getAgentShare().toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 24),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              children: [
                Text("Balance to Remit:"),
                Text(
                  "₱${(getTotalPayments() - getAgentShare()).toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
