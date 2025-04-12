import 'package:flutter/material.dart';
import 'package:loan_app/models/partial.dart';
import 'package:loan_app/models/payment.dart';
import 'package:loan_app/utils/globals.dart';

class TermCompleted extends StatefulWidget {
  final int clientId;
  const TermCompleted({super.key, required this.clientId});

  @override
  State<TermCompleted> createState() => _TermCompletedState();
}

class _TermCompletedState extends State<TermCompleted> {
  List<Payment> paymentsData = [];
  List<Partial> partialsData = [];
  bool isFullyPaid() {
    for (var payment in paymentsData) {
      if (payment.remarks == "Fully Paid") {
        return true;
      }
    }
    return false;
  }

  getPayments() async {
    var payments = await paymentCrud.getAllPaymentsByClientId(widget.clientId);
    var partials = await partialCrud.getAllPartialsByClientId(widget.clientId);

    setState(() {
      paymentsData = payments;
      partialsData = partials;
    });
  }

  int getTotalTermsCompleted() {
    int total = 0;
    for (var payment in paymentsData) {
      if (payment.remarks == "Paid" ||
          payment.remarks == "Partial (Interest)" ||
          payment.remarks == "Partial (Capital)") {
        total++;
      }
    }

    for (var partial in partialsData) {
      if (partial.remarks == "Paid") {
        total++;
      }
    }
    return total;
  }

  @override
  void initState() {
    getPayments();
    getTotalTermsCompleted();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      isFullyPaid()
          ? "${paymentsData.length + partialsData.length}/${paymentsData.length + partialsData.length}"
          : "${getTotalTermsCompleted().toString()}/${paymentsData.length + partialsData.length}",
    );
  }
}
