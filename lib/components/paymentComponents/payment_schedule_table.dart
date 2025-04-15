import 'package:flutter/material.dart';
import 'package:loan_app/components/paymentComponents/payment_update_button.dart';
import 'package:loan_app/components/utilComponents/money_text.dart';
import 'package:loan_app/models/payment.dart';
import 'package:loan_app/utils/globals.dart';

class PaymentScheduleTable extends StatefulWidget {
  final VoidCallback refreshPaymentScheduleTable;
  final List<Payment> paymentsData;
  final int loanTerm;

  const PaymentScheduleTable({
    super.key,
    required this.paymentsData,
    required this.refreshPaymentScheduleTable,
    required this.loanTerm,
  });

  @override
  State<PaymentScheduleTable> createState() => _PaymentScheduleTableState();
}

class _PaymentScheduleTableState extends State<PaymentScheduleTable> {
  // Helper method to determine the color
  Color _getCellColor(int paymentIndex, int isFlexible) {
    return widget.loanTerm < paymentIndex + 1 && isFlexible != 1
        ? Colors.red
        : Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columnSpacing: 16,
      columns: [
        DataColumn(label: Text('Term')),
        DataColumn(label: Text('Due Date')),
        DataColumn(label: Text('Principal Balance')),
        DataColumn(label: Text('Interest')),
        DataColumn(label: Text('Monthly Payment')),
        DataColumn(label: Text('Interest Paid')),
        DataColumn(label: Text('Capital Payment')),
        DataColumn(label: Text('Agent Share')),
        DataColumn(label: Text('Payment Date')),
        DataColumn(label: Text('Mode of Payment')),
        DataColumn(label: Text('Remarks')),
      ],
      rows: [
        ...widget.paymentsData.map((payment) {
          final paymentIndex = widget.paymentsData.indexOf(payment);
          return DataRow(
            cells: [
              DataCell(
                Text(
                  (paymentIndex + 1).toString(),
                  style: TextStyle(
                    color: _getCellColor(paymentIndex, payment.isFlexible!),
                  ),
                ),
              ),
              DataCell(
                Text(
                  payment.paymentSchedule,
                  style: TextStyle(
                    color: _getCellColor(paymentIndex, payment.isFlexible!),
                  ),
                ),
              ),
              DataCell(
                MoneyText(
                  amount: payment.principalBalance,
                  color: _getCellColor(paymentIndex, payment.isFlexible!),
                ),
              ),
              DataCell(
                Text(
                  '${payment.interestRate!.toStringAsFixed(2)}%',
                  style: TextStyle(
                    color: _getCellColor(paymentIndex, payment.isFlexible!),
                  ),
                ),
              ),
              DataCell(
                MoneyText(
                  amount: payment.monthlyPayment,
                  color: _getCellColor(paymentIndex, payment.isFlexible!),
                ),
              ),
              DataCell(
                MoneyText(
                  amount: payment.interestPaid,
                  color: _getCellColor(paymentIndex, payment.isFlexible!),
                ),
              ),
              DataCell(
                MoneyText(
                  amount: payment.capitalPayment,
                  color: _getCellColor(paymentIndex, payment.isFlexible!),
                ),
              ),
              DataCell(
                MoneyText(
                  amount: payment.agentShare,
                  color: _getCellColor(paymentIndex, payment.isFlexible!),
                ),
              ),
              DataCell(
                Text(
                  payment.paymentDate ?? "",
                  style: TextStyle(
                    color: _getCellColor(paymentIndex, payment.isFlexible!),
                  ),
                ),
              ),
              DataCell(
                Text(
                  payment.modeOfPayment ?? "",
                  style: TextStyle(
                    color: _getCellColor(paymentIndex, payment.isFlexible!),
                  ),
                ),
              ),
              DataCell(
                PaymentUpdateButton(
                  showFullyPaidOption: true,
                  payment: payment,
                  paymentsData: widget.paymentsData,
                  onPaymentStatusUpdated: () {
                    widget.refreshPaymentScheduleTable();
                  },
                ),
              ),
            ],
          );
        }),
        // Total Row
        DataRow(
          color: WidgetStatePropertyAll(Colors.indigo),
          cells: [
            DataCell(Text("")),
            DataCell(Text("")),
            DataCell(Text("Total", style: TextStyle(color: Colors.white))),
            DataCell(Text("", style: TextStyle(color: Colors.white))),
            DataCell(
              MoneyText(
                amount: calculateTotals.getTotalMonthlyPayments(
                  widget.paymentsData,
                ),
                color: Colors.white,
              ),
            ),
            DataCell(
              MoneyText(
                amount: calculateTotals.getTotalInterestPaid(
                  widget.paymentsData,
                ),
                color: Colors.white,
              ),
            ),
            DataCell(
              MoneyText(
                amount: calculateTotals.getTotalCapitalPayments(
                  widget.paymentsData,
                ),
                color: Colors.white,
              ),
            ),
            DataCell(
              MoneyText(
                amount: calculateTotals.getTotalAgentShare(widget.paymentsData),
                color: Colors.white,
              ),
            ),
            DataCell(Text("")),
            DataCell(Text("")),
            DataCell(Text("")),
          ],
        ),
      ],
    );
  }
}
