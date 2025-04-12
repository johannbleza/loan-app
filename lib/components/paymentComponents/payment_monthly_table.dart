import 'package:flutter/material.dart';
import 'package:loan_app/components/paymentComponents/payment_update_dialog.dart';
import 'package:loan_app/components/utilComponents/term_completed.dart';
import 'package:loan_app/models/payment.dart';
import 'package:loan_app/pages/client_page.dart';
import 'package:loan_app/utils/globals.dart';

class PaymentMonthlyTable extends StatefulWidget {
  final VoidCallback refreshMonthlyPaymentTable;
  final List<Payment> paymentData;
  const PaymentMonthlyTable({
    super.key,
    required this.paymentData,
    required this.refreshMonthlyPaymentTable,
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
                TextButton(
                  onPressed: () async {
                    final client = await clientCrud.getClientById(
                      payment.clientId,
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ClientPage(client: client),
                      ),
                    ).whenComplete(() {
                      widget.refreshMonthlyPaymentTable();
                    });
                  },
                  child: Text(payment.clientName!),
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
              DataCell(
                Text(
                  '₱${payment.loanAmount?.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                ),
              ),
              DataCell(
                Text(
                  '₱${payment.monthlyPayment.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                  style: TextStyle(
                    color:
                        payment.remarks == "Fully Paid"
                            ? Colors.green
                            : Colors.black,
                  ),
                ),
              ),
              DataCell(
                Text(
                  style: TextStyle(
                    color:
                        payment.remarks == "Partial (Interest)" ||
                                payment.remarks == "Paid"
                            ? Colors.green
                            : Colors.black,
                  ),

                  '₱${payment.interestPaid.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                ),
              ),
              DataCell(
                Text(
                  style: TextStyle(
                    color:
                        payment.remarks == "Partial (Capital)" ||
                                payment.remarks == "Paid"
                            ? Colors.green
                            : Colors.black,
                  ),
                  '₱${payment.capitalPayment.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                ),
              ),
              DataCell(Text(payment.agentName!)),
              DataCell(
                Text(
                  '₱${payment.agentShare.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                ),
              ),
              DataCell(
                Text(
                  '₱${(payment.interestPaid - payment.agentShare).toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                ),
              ),
              DataCell(
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      payment.remarks == "Paid" ||
                              payment.remarks == "Fully Paid"
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
                            onPaymentStatusUpdated:
                                widget.refreshMonthlyPaymentTable,
                          ),
                    );
                  },
                  child: Text(payment.remarks!),
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
              Text(
                '₱${widget.paymentData.fold(0.0, (sum, payment) => sum + (payment.loanAmount ?? 0)).toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                style: TextStyle(color: Colors.white),
              ),
            ),
            DataCell(
              Text(
                '₱${widget.paymentData.fold(0.0, (sum, payment) => sum + payment.monthlyPayment).toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                style: TextStyle(color: Colors.white),
              ),
            ),
            DataCell(
              Text(
                '₱${widget.paymentData.fold(0.0, (sum, payment) => sum + payment.interestPaid).toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                style: TextStyle(color: Colors.white),
              ),
            ),
            DataCell(
              Text(
                '₱${widget.paymentData.fold(0.0, (sum, payment) => sum + payment.capitalPayment).toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                style: TextStyle(color: Colors.white),
              ),
            ),
            DataCell(Text("", style: TextStyle(color: Colors.white))),
            DataCell(
              Text(
                '₱${widget.paymentData.fold(0.0, (sum, payment) => sum + payment.agentShare).toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                style: TextStyle(color: Colors.white),
              ),
            ),
            DataCell(
              Text(
                '₱${widget.paymentData.fold(0.0, (sum, payment) => sum + (payment.interestPaid - payment.agentShare)).toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                style: TextStyle(color: Colors.white),
              ),
            ),
            DataCell(Text("")),
          ],
        ),
      ],
    );
  }
}
