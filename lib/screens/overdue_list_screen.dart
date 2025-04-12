import 'package:flutter/material.dart';
import 'package:loan_app/components/paymentComponents/payment_monthly_table.dart';
import 'package:loan_app/models/payment.dart';
import 'package:loan_app/utils/globals.dart';

class OverdueListScreen extends StatefulWidget {
  const OverdueListScreen({super.key});

  @override
  State<OverdueListScreen> createState() => _OverdueListScreenState();
}

class _OverdueListScreenState extends State<OverdueListScreen> {
  List<Payment> paymentsData = [];

  getPayments() async {
    var payments = await paymentCrud.getOverduePayments();

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 24),
                Text(
                  "Overdue Payments (${paymentsData.length})",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 20),
                SizedBox(height: 20),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: PaymentMonthlyTable(
                    paymentData: paymentsData,
                    refreshMonthlyPaymentTable: () {
                      getPayments();
                    },
                  ),
                ),
                // Add your widgets here
              ],
            ),
          ),
        ],
      ),
    );
  }
}
