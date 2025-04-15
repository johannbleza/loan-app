import 'package:flutter/material.dart';
import 'package:loan_app/components/clientsComponents/client_page_button.dart';
import 'package:loan_app/components/paymentComponents/payment_update_button.dart';
import 'package:loan_app/components/utilComponents/money_text.dart';
import 'package:loan_app/components/utilComponents/term_completed.dart';
import 'package:loan_app/models/payment.dart';
import 'package:loan_app/utils/globals.dart';

class PaymentMonthlyTable extends StatefulWidget {
  final bool? isOverdue;
  final VoidCallback refreshMonthlyPaymentTable;
  final List<Payment> paymentData;
  const PaymentMonthlyTable({
    super.key,
    required this.paymentData,
    required this.refreshMonthlyPaymentTable,
    this.isOverdue,
  });

  @override
  State<PaymentMonthlyTable> createState() => _PaymentMonthlyTableState();
}

class _PaymentMonthlyTableState extends State<PaymentMonthlyTable> {
  @override
  Widget build(BuildContext context) {
    return DataTable(
      columnSpacing: 20,
      columns: [
        DataColumn(label: Text('')),
        DataColumn(label: Text('Client Name')),
        DataColumn(label: Text('Due Date')),
        DataColumn(label: Text('Term Completed')),
        DataColumn(label: Text('Amount Taken')),
        DataColumn(label: Text('Monthly Payment')),
        DataColumn(label: Text('Interest')),
        DataColumn(label: Text('Capital')),
        DataColumn(label: Text('Agent Name')),
        DataColumn(label: Text('Interest Agent')),
        DataColumn(label: Text('Interest Lending')),
        DataColumn(label: Text('Remarks')),
      ],
      rows: [
        ...widget.paymentData.map(
          (payment) => DataRow(
            cells: [
              DataCell(
                Text((widget.paymentData.indexOf(payment) + 1).toString()),
              ),
              DataCell(
                ClientPageButton(
                  payment: payment,
                  whenComplete: widget.refreshMonthlyPaymentTable,
                ),
              ),
              DataCell(Text(payment.paymentSchedule)),
              DataCell(
                Center(
                  child: TermCompleted(
                    clientId: payment.clientId,
                    key: ValueKey(
                      'term_${payment.clientId}_${DateTime.now().millisecondsSinceEpoch}',
                    ),
                  ),
                ),
              ),
              DataCell(MoneyText(amount: payment.loanAmount!)),
              DataCell(MoneyText(amount: payment.monthlyPayment)),
              DataCell(MoneyText(amount: payment.interestPaid)),
              DataCell(MoneyText(amount: payment.capitalPayment)),
              DataCell(Text(payment.agentName!)),
              DataCell(MoneyText(amount: payment.agentShare)),
              DataCell(
                MoneyText(amount: payment.monthlyPayment - payment.agentShare),
              ),
              DataCell(
                PaymentUpdateButton(
                  payment: payment,
                  paymentsData: widget.paymentData,
                  onPaymentStatusUpdated: widget.refreshMonthlyPaymentTable,
                ),
              ),
            ],
          ),
        ),
        DataRow(
          color: WidgetStatePropertyAll(Colors.indigo),
          cells: [
            DataCell(Text("")),
            DataCell(Text("")),
            DataCell(Text("")),
            DataCell(Text("Total:", style: TextStyle(color: Colors.white))),
            DataCell(
              widget.isOverdue == true
                  ? Text("")
                  : MoneyText(
                    amount: calculateTotals.getTotalAmountTaken(
                      widget.paymentData,
                    ),
                    color: Colors.white,
                  ),
            ),
            DataCell(
              MoneyText(
                amount: calculateTotals.getTotalMonthlyPayments(
                  widget.paymentData,
                ),
                color: Colors.white,
              ),
            ),
            DataCell(
              MoneyText(
                amount: calculateTotals.getTotalInterestPaid(
                  widget.paymentData,
                ),
                color: Colors.white,
              ),
            ),
            DataCell(
              MoneyText(
                amount: calculateTotals.getTotalCapitalPayments(
                  widget.paymentData,
                ),
                color: Colors.white,
              ),
            ),
            DataCell(Text("")),
            DataCell(
              MoneyText(
                amount: calculateTotals.getTotalAgentShare(widget.paymentData),
                color: Colors.white,
              ),
            ),
            DataCell(
              MoneyText(
                amount:
                    calculateTotals.getTotalMonthlyPayments(
                      widget.paymentData,
                    ) -
                    calculateTotals.getTotalAgentShare(widget.paymentData),
                color: Colors.white,
              ),
            ),
            DataCell(Text("")),
          ],
        ),
      ],
    );
  }
}
