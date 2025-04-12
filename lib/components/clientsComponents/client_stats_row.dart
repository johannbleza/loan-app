import 'package:flutter/material.dart';
import 'package:loan_app/models/partial.dart';
import 'package:loan_app/models/payment.dart';

class ClientStatsRow extends StatefulWidget {
  final List<Payment> paymentsData;
  final List<Partial> partialsData;

  const ClientStatsRow({
    super.key,
    required this.paymentsData,
    required this.partialsData,
  });

  @override
  State<ClientStatsRow> createState() => _ClientStatsRowState();
}

class _ClientStatsRowState extends State<ClientStatsRow> {
  bool isFullyPaid() {
    for (var payment in widget.paymentsData) {
      if (payment.remarks == "Fully Paid") {
        return true;
      }
    }
    return false;
  }

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

    for (var partial in widget.partialsData) {
      if (partial.remarks == "Paid") {
        total += partial.interestPaid + partial.capitalPayment;
      }
    }
    return total;
  }

  double getTotalInterestPaid() {
    double total = 0;
    for (var payment in widget.paymentsData) {
      if (payment.remarks == "Paid") {
        total += payment.interestPaid;
      } else if (payment.remarks == "Partial (Interest)") {
        total += payment.interestPaid;
      }
    }

    for (var partial in widget.partialsData) {
      if (partial.remarks == "Paid") {
        total += partial.interestPaid;
      }
    }
    return total;
  }

  double getTotalCapitalPayment() {
    double total = 0;
    for (var payment in widget.paymentsData) {
      if (payment.remarks == "Paid") {
        total += payment.capitalPayment;
      } else if (payment.remarks == "Partial (Capital)") {
        total += payment.capitalPayment;
      }
    }

    for (var partial in widget.partialsData) {
      if (partial.remarks == "Paid") {
        total += partial.capitalPayment;
      }
    }
    return total;
  }

  int getTotalTermsCompleted() {
    int total = 0;
    for (var payment in widget.paymentsData) {
      if (payment.remarks == "Paid" ||
          payment.remarks == "Partial (Interest)" ||
          payment.remarks == "Partial (Capital)") {
        total++;
      }
    }

    for (var partial in widget.partialsData) {
      if (partial.remarks == "Paid") {
        total++;
      }
    }
    return total;
  }

  double calculateTotalInterest() {
    return widget.paymentsData.fold<double>(
      0.0,
      (sum, payment) => sum + (payment.interestRate ?? 0.0),
    );
  }

  double calculateTotalAgentShare() {
    return widget.paymentsData.fold<double>(
      0.0,
      (sum, payment) => sum + (payment.agentShare),
    );
  }

  double calculateTotalMonthlyPayment() {
    return widget.paymentsData.fold<double>(
      0.0,
      (sum, payment) => sum + (payment.monthlyPayment),
    );
  }

  double calculateTotalCapitalPayment() {
    return widget.paymentsData.fold<double>(
      0.0,
      (sum, payment) => sum + (payment.capitalPayment),
    );
  }

  double calculateTotalInterestPaid() {
    return widget.paymentsData.fold<double>(
      0.0,
      (sum, payment) => sum + (payment.interestPaid),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              children: [
                Text("Total Balance Capital + Interest:"),
                Text(
                  "₱${calculateTotalMonthlyPayment().toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}",
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
                Text("Total Capital:"),
                Text(
                  "₱${calculateTotalCapitalPayment().toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}",
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
                Text("Total Interest:"),
                Text(
                  "₱${calculateTotalInterestPaid().toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}",
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
                Text("Terms Completed"),
                Text(
                  isFullyPaid()
                      ? "${widget.paymentsData.length + widget.partialsData.length}/${widget.paymentsData.length + widget.partialsData.length}"
                      : "${getTotalTermsCompleted().toString()}/${widget.paymentsData.length + widget.partialsData.length}",
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
