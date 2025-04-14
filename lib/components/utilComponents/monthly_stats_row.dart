import 'package:flutter/material.dart';
import 'package:loan_app/components/utilComponents/stats_card.dart';
import 'package:loan_app/models/payment.dart';
import 'package:loan_app/utils/globals.dart';

class MonthlyStatsRow extends StatefulWidget {
  final List<Payment> paymentsData;
  final bool? agentShare;
  const MonthlyStatsRow({
    super.key,
    required this.paymentsData,
    this.agentShare,
  });

  @override
  State<MonthlyStatsRow> createState() => _MonthlyStatsRowState();
}

class _MonthlyStatsRowState extends State<MonthlyStatsRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        StatsCard(
          title: "Total Payments Amount Paid:",
          value: calculateTotals.getTotalAmountPaid(widget.paymentsData),
        ),
        SizedBox(width: 24),
        StatsCard(
          title: "Total Amount to be Collected:",
          value:
              calculateTotals.getTotalMonthlyPayments(widget.paymentsData) -
              calculateTotals.getTotalAmountPaid(widget.paymentsData),
        ),
        SizedBox(width: 24),
        widget.agentShare == true
            ? StatsCard(
              title: "Less Agent Share (${widget.paymentsData[0].agentName}):",
              value: calculateTotals.getTotalAgentShareCollected(
                widget.paymentsData,
              ),
            )
            : SizedBox(),
        SizedBox(width: 24),
        widget.agentShare == true
            ? StatsCard(
              title: "Balance to Remit:",
              value:
                  calculateTotals.getTotalAmountPaid(widget.paymentsData) -
                  calculateTotals.getTotalAgentShareCollected(
                    widget.paymentsData,
                  ),
            )
            : SizedBox(),
      ],
    );
  }
}
