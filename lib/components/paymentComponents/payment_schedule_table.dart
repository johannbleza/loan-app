import 'package:flutter/material.dart';
import 'package:loan_app/components/partialComponents/partial_update_dialog.dart';
import 'package:loan_app/components/paymentComponents/payment_update_dialog.dart';
import 'package:loan_app/models/partial.dart';
import 'package:loan_app/models/payment.dart';
import 'package:loan_app/utils/globals.dart';

class PaymentScheduleTable extends StatefulWidget {
  final VoidCallback refreshPaymentScheduleTable;
  final List<Payment> paymentsData;
  final List<Partial> partialsData;

  const PaymentScheduleTable({
    super.key,
    required this.paymentsData,
    required this.refreshPaymentScheduleTable,
    required this.partialsData,
  });

  @override
  State<PaymentScheduleTable> createState() => _PaymentScheduleTableState();
}

class _PaymentScheduleTableState extends State<PaymentScheduleTable> {
  @override
  // Calculate Totals
  Widget build(BuildContext context) {
    final totalInterest = widget.paymentsData.fold<double>(
      0.0,
      (sum, payment) => sum + (payment.interestRate ?? 0.0),
    );
    final totalMonthlyPayment = widget.paymentsData.fold<double>(
      0.0,
      (sum, payment) => sum + (payment.monthlyPayment),
    );
    final totalInterestPaid = widget.paymentsData.fold<double>(
      0.0,
      (sum, payment) => sum + (payment.interestPaid),
    );
    final totalCapitalPayment = widget.paymentsData.fold<double>(
      0.0,
      (sum, payment) => sum + (payment.capitalPayment),
    );
    final totalAgentShare = widget.paymentsData.fold<double>(
      0.0,
      (sum, payment) => sum + (payment.agentShare),
    );

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
        ...widget.paymentsData.map(
          (payment) => DataRow(
            cells: [
              DataCell(
                Text((widget.paymentsData.indexOf(payment) + 1).toString()),
              ),
              DataCell(Text(payment.paymentSchedule)),
              DataCell(
                Text(
                  '₱${payment.principalBalance.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                ),
              ),
              DataCell(Text('${payment.interestRate!.toStringAsFixed(2)}%')),
              DataCell(
                Text(
                  '₱${payment.monthlyPayment.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                ),
              ),
              DataCell(
                Text(
                  '₱${payment.interestPaid.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                  style: TextStyle(
                    color:
                        payment.remarks == "Partial (Interest)" ||
                                payment.remarks == "Paid"
                            ? Colors.green
                            : Colors.black,
                  ),
                ),
              ),
              DataCell(
                Text(
                  '₱${payment.capitalPayment.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                  style: TextStyle(
                    color:
                        payment.remarks == "Partial (Capital)" ||
                                payment.remarks == "Paid"
                            ? Colors.green
                            : Colors.black,
                  ),
                ),
              ),
              DataCell(
                Text(
                  payment.agentShare == 0
                      ? ""
                      : '₱${payment.agentShare.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                ),
              ),
              DataCell(Text(payment.paymentDate ?? "")),
              DataCell(Text(payment.modeOfPayment ?? "")),
              DataCell(
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      payment.remarks == "Paid"
                          ? Colors.green
                          : (payment.remarks == "Partial (Interest)" ||
                              payment.remarks == "Partial (Capital)")
                          ? Colors.lightGreen
                          : payment.remarks == "Overdue"
                          ? Colors.red
                          : Colors.orange,
                    ),
                    foregroundColor: WidgetStatePropertyAll(Colors.white),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder:
                          (context) => PaymentUpdateDialog(
                            payment: payment,
                            onPaymentStatusUpdated: () {
                              paymentCrud.updateOverduePayments();
                              widget.refreshPaymentScheduleTable();
                            },
                          ),
                    );
                  },
                  child: Text(payment.remarks!),
                ),
              ),
            ],
          ),
        ),
        // Total Row
        DataRow(
          color: WidgetStatePropertyAll(Colors.indigo),
          cells: [
            DataCell(Text("")),
            DataCell(Text("")),
            DataCell(Text("Total", style: TextStyle(color: Colors.white))),
            DataCell(
              Text(
                '${totalInterest.toStringAsFixed(2)}%',
                style: TextStyle(color: Colors.white),
              ),
            ),
            DataCell(
              Text(
                '₱${totalMonthlyPayment.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                style: TextStyle(color: Colors.white),
              ),
            ),
            DataCell(
              Text(
                '₱${totalInterestPaid.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                style: TextStyle(color: Colors.white),
              ),
            ),
            DataCell(
              Text(
                '₱${totalCapitalPayment.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                style: TextStyle(color: Colors.white),
              ),
            ),
            DataCell(
              Text(
                '₱${totalAgentShare.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                style: TextStyle(color: Colors.white),
              ),
            ),
            DataCell(Text("")),
            DataCell(Text("")),
            DataCell(Text("")),
          ],
        ),
        DataRow(
          cells: [
            DataCell(Text("")),
            DataCell(Text("")),
            DataCell(Text("")),
            DataCell(Text("")),
            DataCell(Text("")),
            DataCell(Text("")),
            DataCell(Text("")),
            DataCell(Text("")),
            DataCell(Text("")),
            DataCell(Text("")),
            DataCell(Text("")),
          ],
        ),
        DataRow(
          cells: [
            DataCell(Text("")),
            DataCell(
              Text(
                "Incomplete Payments",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            DataCell(Text("")),
            DataCell(Text("")),
            DataCell(Text("")),
            DataCell(
              Text(
                "Interest Paid",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            DataCell(
              Text(
                "Capital Payment",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            DataCell(Text("")),
            DataCell(
              Text(
                "Payment Date",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            DataCell(
              Text(
                "Mode of Payment",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            DataCell(
              Text("Remarks", style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ],
        ),
        ...widget.partialsData.map(
          (partial) => DataRow(
            cells: [
              DataCell(
                Text((widget.partialsData.indexOf(partial) + 1).toString()),
              ),
              DataCell(Text(partial.paymentSchedule!)),
              DataCell(Text("")),
              DataCell(Text("")),
              DataCell(Text("")),
              DataCell(
                Text(
                  style: TextStyle(
                    color:
                        partial.remarks == 'Paid' ? Colors.green : Colors.black,
                  ),
                  partial.interestPaid != 0
                      ? '₱${partial.interestPaid.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}'
                      : "",
                ),
              ),
              DataCell(
                Text(
                  style: TextStyle(
                    color:
                        partial.remarks == 'Paid' ? Colors.green : Colors.black,
                  ),
                  partial.capitalPayment != 0
                      ? '₱${partial.capitalPayment.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}'
                      : "",
                ),
              ),
              DataCell(Text("")),
              DataCell(Text(partial.paymentDate ?? "")),
              DataCell(Text(partial.modeOfPayment ?? "")),
              DataCell(
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      partial.remarks == "Unpaid" ? Colors.red : Colors.green,
                    ),
                    foregroundColor: WidgetStatePropertyAll(Colors.white),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder:
                          (context) => PartialUpdateDialog(
                            partial: partial,
                            onPartialStatusUpdated:
                                widget.refreshPaymentScheduleTable,
                          ),
                    );
                  },
                  child: Text(partial.remarks!),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
