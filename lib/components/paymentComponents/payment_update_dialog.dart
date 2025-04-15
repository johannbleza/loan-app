import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jiffy/jiffy.dart';
import 'package:loan_app/components/utilComponents/select_date_button.dart';
import 'package:loan_app/models/balanceSheet.dart';
import 'package:loan_app/models/payment.dart';
import 'package:loan_app/utils/globals.dart';

class PaymentUpdateDialog extends StatefulWidget {
  final int? isFlexible;
  final List<Payment>? paymentsData;
  final VoidCallback onPaymentStatusUpdated;
  final Payment payment;
  final bool? showFullyPaidOption;
  const PaymentUpdateDialog({
    super.key,
    required this.payment,
    required this.onPaymentStatusUpdated,
    this.paymentsData,
    this.showFullyPaidOption,
    this.isFlexible,
  });

  @override
  State<PaymentUpdateDialog> createState() => _PaymentUpdateDialogState();
}

class _PaymentUpdateDialogState extends State<PaymentUpdateDialog> {
  // Text Editing Controllers
  final TextEditingController _modeOfPaymentController =
      TextEditingController();
  final TextEditingController _paymentDateController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();

  // Flexible payment text controllers
  final TextEditingController _interestPaidController = TextEditingController();
  final TextEditingController _capitalPaymentController =
      TextEditingController();

  @override
  void initState() {
    _modeOfPaymentController.text = widget.payment.modeOfPayment ?? '';
    _paymentDateController.text = widget.payment.paymentDate?.toString() ?? '';
    _remarksController.text = widget.payment.remarks!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Update Payment Status"),
      content: SizedBox(
        width: 250,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.isFlexible == 1) ...[
              TextField(
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                controller: _interestPaidController,
                decoration: const InputDecoration(labelText: 'Interest Paid'),
              ),
              TextField(
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                controller: _capitalPaymentController,
                decoration: const InputDecoration(labelText: 'Capital Payment'),
              ),
              SizedBox(height: 16),
            ],
            TextField(
              controller: _modeOfPaymentController,
              decoration: InputDecoration(labelText: "Mode of Payment"),
            ),
            SizedBox(height: 16),
            SelectDateButton(
              buttonText: "Select Payment Date",
              onDateSelected: (date) {
                setState(() {
                  _paymentDateController.text = date.toString();
                });
              },
            ),
            SizedBox(height: 16),
            DropdownMenu(
              controller: _remarksController,
              initialSelection: widget.payment.remarks,
              width: 250,
              dropdownMenuEntries:
                  widget.isFlexible == 1
                      ? [
                        DropdownMenuEntry(label: "Due", value: 'Due'),
                        DropdownMenuEntry(label: "Paid", value: 'Paid'),
                      ]
                      : widget.payment.interestPaid == 0
                      ? [
                        DropdownMenuEntry(label: "Due", value: 'Due'),
                        DropdownMenuEntry(label: "Paid", value: 'Paid'),
                        if (widget.showFullyPaidOption == true)
                          DropdownMenuEntry(
                            label: "Fully Paid",
                            value: 'Fully Paid',
                          ),
                      ]
                      : widget.payment.capitalPayment == 0
                      ? [
                        DropdownMenuEntry(label: "Due", value: 'Due'),
                        DropdownMenuEntry(label: "Paid", value: 'Paid'),
                        if (widget.showFullyPaidOption == true)
                          DropdownMenuEntry(
                            label: "Fully Paid",
                            value: 'Fully Paid',
                          ),
                      ]
                      : [
                        DropdownMenuEntry(label: "Due", value: 'Due'),
                        DropdownMenuEntry(
                          label: "Partial (Interest)",
                          value: 'Partial (Interest)',
                        ),
                        DropdownMenuEntry(
                          label: "Partial (Capital)",
                          value: 'Partial (Capital)',
                        ),
                        DropdownMenuEntry(label: "Paid", value: 'Paid'),
                        if (widget.showFullyPaidOption == true)
                          DropdownMenuEntry(
                            label: "Fully Paid",
                            value: 'Fully Paid',
                          ),
                      ],
              onSelected: (value) {
                setState(() {
                  _remarksController.text = value!;
                });
              },
            ),
            SizedBox(height: 16),
            // ResetPaymentScheduleButton(
            //   client: client,
            //   onReset: widget.onPaymentStatusUpdated,
            // ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Cancel"),
        ),
        TextButton(
          onPressed: () async {
            // Check if payment date is empty and remarks is not 'Due' or 'Overdue'
            if (_paymentDateController.text.isEmpty &&
                (_remarksController.text != 'Due' ||
                    _remarksController.text != 'Overdue')) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Please select a payment date."),
                  duration: Duration(seconds: 2),
                ),
              );
              return;
            }

            // Set to 'Overdue' if the payment is overdue
            if (_remarksController.text == 'Due') {
              String currentDate = Jiffy.now().format(pattern: 'MMM d, yyyy');
              if (Jiffy.parse(
                widget.payment.paymentSchedule,
                pattern: 'MMM d, yyyy',
              ).isBefore(Jiffy.parse(currentDate, pattern: 'MMM d, yyyy'))) {
                _remarksController.text = 'Overdue';
              }
              _paymentDateController.clear();
              _modeOfPaymentController.clear();
            }

            // Update Payment - paymentDate, modeOfPayment, remarks,
            paymentCrud.updatePaymentRemarks(
              widget.payment.paymentId!,
              _paymentDateController.text,
              _modeOfPaymentController.text,
              _remarksController.text,
            );

            // Delete Balance Sheet First to Avoid duplicates
            balanceSheetCrud.deleteBalanceSheetByPaymentId(
              widget.payment.paymentId!,
            );

            if (widget.isFlexible == 1) {
              // If empty set to 0
              _interestPaidController.text == ""
                  ? _interestPaidController.text = "0"
                  : _interestPaidController.text;
              _capitalPaymentController.text == ""
                  ? _capitalPaymentController.text = "0"
                  : _capitalPaymentController.text;

              // Update Flexible Payment
              double interestPaid = double.parse(_interestPaidController.text);
              double capitalPayment = double.parse(
                _capitalPaymentController.text,
              );
              double flexibleMonthlyPayment = interestPaid + capitalPayment;

              paymentCrud.updateFlexiblePayments(
                widget.payment.paymentId!,
                flexibleMonthlyPayment,
                interestPaid,
                capitalPayment,
                (flexibleMonthlyPayment) *
                    (widget.payment.agentInterest! / 100),
              );

              // Create balance sheet for flexible
              balanceSheetCrud.createBalanceSheet(
                BalanceSheet(
                  date: _paymentDateController.text,
                  inAmount: flexibleMonthlyPayment,
                  outAmount: 0,
                  balance: flexibleMonthlyPayment,
                  remarks:
                      '${widget.payment.clientName} - Payment for ${Jiffy.parse(widget.payment.paymentSchedule, pattern: 'MMM d, yyyy').format(pattern: 'MMM yyyy')}',
                  paymentId: widget.payment.paymentId,
                ),
              );

              // Add new payment if principal balance is not 0
              if (widget.payment.principalBalance - capitalPayment > 0) {
                String paymentSchdule =
                    Jiffy.parse(
                      widget.payment.paymentSchedule,
                      pattern: 'MMM d, yyyy',
                    ).add(months: 1).format(pattern: 'MMM d, yyyy').toString();

                paymentCrud.createPayment(
                  Payment(
                    paymentSchedule: paymentSchdule,
                    principalBalance:
                        widget.payment.principalBalance - capitalPayment,
                    monthlyPayment: 0,
                    interestPaid: 0,
                    capitalPayment: 0,
                    agentShare: 0,
                    clientId: widget.payment.clientId,
                    remarks: 'Due',
                  ),
                );
              }
            }

            // Import to Balance Sheet & Add offest payments
            if (_remarksController.text == 'Paid' && widget.isFlexible == 0) {
              balanceSheetCrud.createBalanceSheet(
                BalanceSheet(
                  date: _paymentDateController.text,
                  inAmount: widget.payment.monthlyPayment,
                  outAmount: 0,
                  balance: widget.payment.monthlyPayment,
                  remarks:
                      '${widget.payment.clientName} - Payment for ${Jiffy.parse(widget.payment.paymentSchedule, pattern: 'MMM d, yyyy').format(pattern: 'MMM yyyy')}',
                  paymentId: widget.payment.paymentId,
                ),
              );
            } else if (_remarksController.text == 'Partial (Interest)') {
              // Create Balance Sheet
              balanceSheetCrud.createBalanceSheet(
                BalanceSheet(
                  date: _paymentDateController.text,
                  inAmount: widget.payment.interestPaid,
                  outAmount: 0,
                  balance: widget.payment.interestPaid,
                  remarks:
                      '${widget.payment.clientName} - Partial (Interest) Payment for ${Jiffy.parse(widget.payment.paymentSchedule, pattern: 'MMM d, yyyy').format(pattern: 'MMM yyyy')}',
                  paymentId: widget.payment.paymentId,
                ),
              );

              // Update Monthly Payment to be Interest Paid
              paymentCrud.updateMonthlyCapitalPaymentAgentShare(
                widget.payment.paymentId!,
                widget.payment.interestPaid,
                0,
                widget.payment.interestPaid *
                    (widget.payment.agentInterest! / 100),
              );

              // Create New Payment to Offset
              paymentCrud.createPayment(
                Payment(
                  paymentSchedule:
                      Jiffy.parse(
                            widget.payment.paymentSchedule,
                            pattern: 'MMM d, yyyy',
                          )
                          .add(
                            months:
                                widget.paymentsData!.length -
                                widget.paymentsData!.indexOf(widget.payment),
                          )
                          .format(pattern: 'MMM d, yyyy')
                          .toString(),
                  principalBalance: widget.payment.principalBalance,
                  monthlyPayment: widget.payment.capitalPayment,
                  interestPaid: 0,
                  capitalPayment: widget.payment.capitalPayment,
                  agentShare:
                      widget.payment.capitalPayment *
                      (widget.payment.agentInterest! / 100),
                  clientId: widget.payment.clientId,
                  remarks: 'Due',
                ),
              );

              // Adjust Principal Balance
              for (Payment payment in widget.paymentsData!.sublist(
                widget.paymentsData!.indexOf(widget.payment),
              )) {
                await paymentCrud.updatePrincipalBalanceByPaymentId(
                  payment.paymentId! + 1,
                  payment.principalBalance,
                );
              }
              // // Adjust Balance
              // for (Payment payment in widget.paymentsData!.sublist(
              //   widget.paymentsData!.indexOf(widget.payment),
              // )) {
              //   await paymentCrud.updatePrincipalBalanceByPaymentId(
              //     payment.paymentId! + 1,
              //     payment.principalBalance,
              //   );
              // }
            } else if (_remarksController.text == 'Partial (Capital)') {
              balanceSheetCrud.createBalanceSheet(
                BalanceSheet(
                  date: _paymentDateController.text,
                  inAmount: widget.payment.capitalPayment,
                  outAmount: 0,
                  balance: widget.payment.capitalPayment,
                  remarks:
                      '${widget.payment.clientName} - Partial (Capital) Payment for ${Jiffy.parse(widget.payment.paymentSchedule, pattern: 'MMM d, yyyy').format(pattern: 'MMM yyyy')}',
                  paymentId: widget.payment.paymentId,
                ),
              );

              // Update Monthly Payment
              paymentCrud.updateMonthlyInterestPaymentAgentShare(
                widget.payment.paymentId!,
                widget.payment.capitalPayment,
                0,
                widget.payment.capitalPayment *
                    (widget.payment.agentInterest! / 100),
              );

              // Create New Payment
              paymentCrud.createPayment(
                Payment(
                  paymentSchedule:
                      Jiffy.parse(
                            widget.payment.paymentSchedule,
                            pattern: 'MMM d, yyyy',
                          )
                          .add(
                            months:
                                widget.paymentsData!.length -
                                widget.paymentsData!.indexOf(widget.payment),
                          )
                          .format(pattern: 'MMM d, yyyy')
                          .toString(),
                  principalBalance: 0,
                  monthlyPayment: widget.payment.interestPaid,
                  interestPaid: widget.payment.interestPaid,
                  capitalPayment: 0,
                  agentShare:
                      widget.payment.interestPaid *
                      (widget.payment.agentInterest! / 100),
                  clientId: widget.payment.clientId,
                  remarks: 'Due',
                ),
              );
            }

            // Fully Paid
            if (_remarksController.text == 'Fully Paid') {
              // Totals
              double interestPaidTotal = calculateTotals
                  .getRemainingInterestPaid(widget.paymentsData!);
              double capitalPaymentTotal = calculateTotals
                  .getRemainingCapitalPayments(widget.paymentsData!);
              double monthlyPaymentTotal =
                  interestPaidTotal + capitalPaymentTotal;
              await paymentCrud.updatePayment(
                Payment(
                  paymentId: widget.payment.paymentId,
                  paymentSchedule: widget.payment.paymentSchedule,
                  principalBalance: widget.payment.principalBalance,
                  monthlyPayment: monthlyPaymentTotal,
                  interestPaid: interestPaidTotal,
                  capitalPayment: capitalPaymentTotal,
                  agentShare:
                      monthlyPaymentTotal *
                      (widget.payment.agentInterest! / 100),
                  clientId: widget.payment.clientId,
                  paymentDate: _paymentDateController.text,
                  modeOfPayment: _modeOfPaymentController.text,
                  remarks: _remarksController.text,
                ),
              );

              balanceSheetCrud.createBalanceSheet(
                BalanceSheet(
                  date: _paymentDateController.text,
                  inAmount: monthlyPaymentTotal,
                  outAmount: 0,
                  balance: monthlyPaymentTotal,
                  remarks: '${widget.payment.clientName} - Fully Paid',
                  paymentId: widget.payment.paymentId,
                ),
              );

              await paymentCrud.setPaymentRemarksToCompleted(
                widget.payment.clientId,
              );
            }
            // Show snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Payment status updated successfully."),
                duration: Duration(seconds: 2),
              ),
            );

            widget.onPaymentStatusUpdated();
            Navigator.pop(context);
          },
          child: Text("Update"),
        ),
      ],
    );
  }
}
