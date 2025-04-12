import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:loan_app/components/paymentComponents/payment_monthly_table.dart';
import 'package:loan_app/components/utilComponents/monthly_row_filters.dart';
import 'package:loan_app/components/utilComponents/monthly_stats_row.dart';
import 'package:loan_app/models/payment.dart';
import 'package:loan_app/utils/globals.dart';

class MonthlyReportScreen extends StatefulWidget {
  const MonthlyReportScreen({super.key});

  @override
  State<MonthlyReportScreen> createState() => _MonthlyReportScreenState();
}

class _MonthlyReportScreenState extends State<MonthlyReportScreen> {
  int selectedMonth = Jiffy.now().month;
  int selectedYear = Jiffy.now().year;
  int? selectedAgentId;
  List<Payment> paymentsData = [];

  getPayments() async {
    var payments = await paymentCrud.getMonthlyPayments();

    // Filter payments for the current month
    payments =
        payments.where((payment) {
            var paymentDate = Jiffy.parse(
              payment.paymentSchedule,
              pattern: 'MMM d, yyyy',
            );
            return paymentDate.month == selectedMonth &&
                paymentDate.year == selectedYear;
          }).toList()
          ..sort((a, b) {
            var dateA = Jiffy.parse(a.paymentSchedule, pattern: 'MMM d, yyyy');
            var dateB = Jiffy.parse(b.paymentSchedule, pattern: 'MMM d, yyyy');
            return dateA.date.compareTo(dateB.date);
          });

    // Filter payments by agentId
    if (selectedAgentId != null) {
      payments =
          payments
              .where((payment) => payment.agentId == selectedAgentId)
              .toList();
    }

    setState(() {
      paymentsData = payments;
    });
  }

  @override
  void initState() {
    getPayments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: ListView(
        children: [
          Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24),
                  Text(
                    "Monthly Report",
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 20),
                  MonthlyRowFilters(
                    onMonthSelected: (value) {
                      setState(() {
                        selectedMonth = value;
                        getPayments();
                      });
                    },
                    onYearSelected: (value) {
                      setState(() {
                        selectedYear = value;
                        getPayments();
                      });
                    },
                    onAgentSelected: (value) {
                      setState(() {
                        selectedAgentId = value;
                        getPayments();
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  paymentsData.isEmpty
                      ? SizedBox()
                      : MonthlyStatsRow(paymentsData: paymentsData),
                  SizedBox(height: 20),
                  Text(
                    "Collection List"
                    " (${paymentsData.length})",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 20),
                  PaymentMonthlyTable(
                    paymentData: paymentsData,
                    refreshMonthlyPaymentTable: () {
                      getPayments();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
