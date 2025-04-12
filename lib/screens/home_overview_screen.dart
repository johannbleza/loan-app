import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:loan_app/components/paymentComponents/payment_monthly_table.dart';
import 'package:loan_app/components/utilComponents/monthly_stats_row.dart';
import 'package:loan_app/models/payment.dart';
import 'package:loan_app/utils/globals.dart';

class HomeOverviewScreen extends StatefulWidget {
  const HomeOverviewScreen({super.key});

  @override
  State<HomeOverviewScreen> createState() => _HomeOverviewScreenState();
}

class _HomeOverviewScreenState extends State<HomeOverviewScreen> {
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
            return paymentDate.month == Jiffy.now().month &&
                paymentDate.year == Jiffy.now().year;
          }).toList()
          ..sort((a, b) {
            var dateA = Jiffy.parse(a.paymentSchedule, pattern: 'MMM d, yyyy');
            var dateB = Jiffy.parse(b.paymentSchedule, pattern: 'MMM d, yyyy');
            return dateA.date.compareTo(dateB.date);
          });
    payments =
        payments
            .where(
              (payment) =>
                  payment.remarks != "Completed" &&
                  payment.remarks != "Fully Paid",
            )
            .toList();

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
                    "This Month's Collection (${Jiffy.now().format(pattern: 'MMMM')})",
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600),
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
