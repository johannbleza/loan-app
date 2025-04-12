import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
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
  bool isFullyPaid() {
    for (var payment in widget.paymentsData) {
      if (payment.remarks == "Fully Paid") {
        return true;
      }
    }
    return false;
  }

  @override
  // Calculate Totals
  Widget build(BuildContext context) {
    final totalInterest = widget.paymentsData.fold<double>(
      0.0,
      (sum, payment) => sum + (payment.interestRate ?? 0.0),
    );
    final totalAgentShare = widget.paymentsData.fold<double>(
      0.0,
      (sum, payment) => sum + (payment.agentShare),
    );
    final totalMonthlyPayment = widget.paymentsData.fold<double>(
      0.0,
      (sum, payment) => sum + (payment.monthlyPayment),
    );
    final totalCapitalPayment = widget.paymentsData.fold<double>(
      0.0,
      (sum, payment) => sum + (payment.capitalPayment),
    );
    final totalInterestPaid = widget.paymentsData.fold<double>(
      0.0,
      (sum, payment) => sum + (payment.interestPaid),
    );

    double getTotalPayments() {
      double total = 0;
      for (var payment in widget.paymentsData) {
        if (payment.remarks == "Paid") {
          total += payment.monthlyPayment;
        } else if (payment.remarks == "Partial (Interest)") {
          total += payment.interestPaid;
        } else if (payment.remarks == "Partial (Capital)") {
          total += payment.capitalPayment;
        } else if (payment.remarks == "Fully Paid") {
          total += payment.principalBalance;
        }
      }

      for (var partial in widget.partialsData) {
        if (partial.remarks == "Paid") {
          total += partial.interestPaid + partial.capitalPayment;
        }
      }
      return total;
    }

    int getRemaningTerms() {
      int total = 0;
      for (var payment in widget.paymentsData) {
        if (payment.remarks == "Fully Paid" || payment.remarks == "Completed") {
          total++;
        }
      }

      return total;
    }

    double getTotalInterestPaid() {
      double total = 0;
      for (var payment in widget.paymentsData) {
        if (payment.remarks == "Paid") {
          total += payment.interestPaid;
        } else if (payment.remarks == "Partial (Interest)") {
          total += payment.interestPaid;
        }
      }

      for (var partial in widget.partialsData) {
        if (partial.remarks == "Paid") {
          total += partial.interestPaid;
        }
      }
      return total;
    }

    double getRemainingInterestPaid() {
      double total = 0;
      for (var payment in widget.paymentsData) {
        if (payment.remarks == "Completed" || payment.remarks == "Fully Paid") {
          total += payment.interestPaid;
        }
      }
      return total;
    }

    double getRemainingCapitalPayment() {
      double total = 0;
      for (var payment in widget.paymentsData) {
        if (payment.remarks == "Completed" || payment.remarks == "Fully Paid") {
          total += payment.capitalPayment;
        }
      }

      return total;
    }

    double getTotalCapitalPayment() {
      double total = 0;
      for (var payment in widget.paymentsData) {
        if (payment.remarks == "Paid") {
          total += payment.capitalPayment;
        } else if (payment.remarks == "Partial (Capital)") {
          total += payment.capitalPayment;
        } else if (payment.remarks == "Fully Paid") {
          total += payment.principalBalance;
        }
      }

      for (var partial in widget.partialsData) {
        if (partial.remarks == "Paid") {
          total += partial.capitalPayment;
        }
      }
      return total;
    }

    double getTotalAgentShare() {
      double total = 0;
      for (var payment in widget.paymentsData) {
        if (payment.remarks == "Paid") {
          total += payment.agentShare;
        } else if (payment.remarks == "Partial (Interest)") {
          total += payment.agentShare;
        }
      }

      for (var partial in widget.partialsData) {
        if (partial.remarks == "Paid") {
          total += partial.agentShare;
        }
      }
      return total;
    }

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
                  isFullyPaid() && payment.remarks == "Completed"
                      ? ""
                      : '₱${payment.principalBalance.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                ),
              ),
              DataCell(Text('${payment.interestRate!.toStringAsFixed(2)}%')),
              DataCell(
                Text(
                  isFullyPaid() && payment.remarks == "Completed"
                      ? ""
                      : payment.remarks == "Fully Paid"
                      ? '₱${(payment.monthlyPayment * getRemaningTerms()).toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}'
                      : '₱${payment.monthlyPayment.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                ),
              ),
              DataCell(
                Text(
                  payment.remarks == "Fully Paid"
                      ? '₱${getRemainingInterestPaid().toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}'
                      : isFullyPaid() && payment.remarks == "Completed"
                      ? ""
                      : payment.remarks != "Partial (Capital)" &&
                          payment.remarks != "Fully Paid"
                      ? '₱${payment.interestPaid.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}'
                      : "",
                  style: TextStyle(
                    color:
                        payment.remarks == "Partial (Interest)" ||
                                payment.remarks == "Paid" ||
                                payment.remarks == "Fully Paid"
                            ? Colors.green
                            : Colors.black,
                  ),
                ),
              ),
              DataCell(
                Text(
                  isFullyPaid() && payment.remarks == "Completed"
                      ? ""
                      : payment.remarks != "Partial (Interest)" &&
                          payment.remarks != "Fully Paid"
                      ? '₱${payment.capitalPayment.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}'
                      : payment.remarks == "Fully Paid"
                      ? '₱${getRemainingCapitalPayment().toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}'
                      : "",

                  style: TextStyle(
                    color:
                        payment.remarks == "Partial (Capital)" ||
                                payment.remarks == "Paid" ||
                                payment.remarks == "Fully Paid"
                            ? Colors.green
                            : Colors.black,
                  ),
                ),
              ),
              DataCell(
                Text(
                  payment.remarks == "Fully Paid" && payment.agentShare != 0
                      ? '₱${(totalAgentShare - getTotalAgentShare()).toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}'
                      : isFullyPaid() && payment.remarks == "Completed"
                      ? ""
                      : payment.agentShare == 0
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
                      payment.remarks == "Paid" ||
                              payment.remarks == "Fully Paid"
                          ? Colors.green
                          : (payment.remarks == "Partial (Interest)" ||
                              payment.remarks == "Partial (Capital)")
                          ? Colors.lightGreen
                          : payment.remarks == "Overdue"
                          ? Colors.red
                          : payment.remarks == "Completed"
                          ? Colors.blueGrey
                          : Colors.orange,
                    ),
                    foregroundColor: WidgetStatePropertyAll(Colors.white),
                  ),
                  onPressed: () {
                    if (isFullyPaid() &&
                        (payment.remarks == "Completed" ||
                            payment.remarks == "Paid")) {
                      return;
                    }
                    showDialog(
                      context: context,
                      builder:
                          (context) => PaymentUpdateDialog(
                            remainingCapitalPayment:
                                getRemainingCapitalPayment(),
                            remainingInterestPaid: getRemainingInterestPaid(),
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
        DataRow(
          cells: [
            DataCell(Text("")),
            DataCell(
              Text(
                widget.partialsData.isNotEmpty ? "Incomplete Payments" : "",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
            ),
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
        // Total Row
        ...widget.partialsData.map(
          (partial) => DataRow(
            cells: [
              DataCell(
                Text(
                  (widget.paymentsData.length +
                          widget.partialsData.indexOf(partial) +
                          1)
                      .toString(),
                ),
              ),
              DataCell(
                Text(
                  Jiffy.parse(
                    partial.paymentSchedule!,
                    pattern: 'MMM d, yyyy',
                  ).format(pattern: 'MMM d, yyyy').toString(),
                  style: TextStyle(color: Colors.red),
                ),
              ),
              DataCell(Text("")),
              DataCell(Text("")),
              DataCell(Text("")),
              DataCell(
                Text(
                  style: TextStyle(
                    color:
                        partial.remarks == 'Paid' ? Colors.green : Colors.red,
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
                        partial.remarks == 'Paid' ? Colors.green : Colors.red,
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
                '₱${(getTotalInterestPaid() + getRemainingInterestPaid()).toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
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
      ],
    );
  }
}
