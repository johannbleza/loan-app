import 'package:flutter/material.dart';
import 'package:loan_app/components/utilComponents/stats_card.dart';
import 'package:loan_app/models/payment.dart';
import 'package:loan_app/utils/globals.dart';

class ClientStatsRow extends StatefulWidget {
  final List<Payment> paymentsData;

  const ClientStatsRow({super.key, required this.paymentsData});

  @override
  State<ClientStatsRow> createState() => _ClientStatsRowState();
}

class _ClientStatsRowState extends State<ClientStatsRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        StatsCard(
          title: "Total Amount Collected:",
          value: calculateTotals.getTotalAmountPaid(widget.paymentsData),
        ),
        SizedBox(width: 24),
        StatsCard(
          title: "Total Interest Collected:",
          value: calculateTotals.getTotalInterestPaidCollected(
            widget.paymentsData,
          ),
        ),
        SizedBox(width: 24),
        StatsCard(
          title: "Total Capital Collected:",
          value: calculateTotals.getTotalCapitalPaymentsCollected(
            widget.paymentsData,
          ),
        ),
        SizedBox(width: 24),
        StatsCard(
          title: "Total Agent Share Collected:",
          value: calculateTotals.getTotalAgentShareCollected(
            widget.paymentsData,
          ),
        ),
      ],
    );
  }
}
