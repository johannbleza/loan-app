import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loan_app/components/utilComponents/select_agent_button.dart';
import 'package:loan_app/components/utilComponents/select_date_button.dart';
import 'package:loan_app/models/agent.dart';
import 'package:loan_app/models/balanceSheet.dart';
import 'package:loan_app/models/client.dart';
import 'package:loan_app/utils/globals.dart';

class ClientAddDialog extends StatefulWidget {
  final VoidCallback onClientAdded;
  final Agent? currentAgent;
  const ClientAddDialog({
    super.key,
    required this.onClientAdded,
    this.currentAgent,
  });

  @override
  State<ClientAddDialog> createState() => _ClientAddDialogState();
}

class _ClientAddDialogState extends State<ClientAddDialog> {
  final TextEditingController _clientNameController = TextEditingController();
  final TextEditingController _loanAmountController = TextEditingController();
  final TextEditingController _termController = TextEditingController();
  final TextEditingController _interestRateController = TextEditingController();
  final TextEditingController _loanDateController = TextEditingController();
  final TextEditingController _agentIdController = TextEditingController();
  final TextEditingController _agentInterestController =
      TextEditingController();
  int isFlexible = 0;

  @override
  void initState() {
    widget.currentAgent != null
        ? _agentIdController.text = widget.currentAgent!.agentId.toString()
        : _agentIdController.text = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add Client"),
      content: SizedBox(
        width: 280,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _clientNameController,
              decoration: const InputDecoration(labelText: 'Client Name'),
            ),
            TextField(
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              controller: _loanAmountController,
              decoration: const InputDecoration(labelText: 'Loan Amount'),
            ),
            TextField(
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              controller: _termController,
              decoration: const InputDecoration(labelText: 'Term (Months)'),
            ),
            TextField(
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              controller: _interestRateController,
              decoration: const InputDecoration(labelText: 'Interest Rate (%)'),
            ),
            TextField(
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              controller: _agentInterestController,
              decoration: const InputDecoration(labelText: 'Agent Share (%)'),
            ),
            SizedBox(height: 16),
            SelectAgentButton(
              currentAgent: widget.currentAgent,
              onAgentSelected: (selectedAgent) {
                _agentIdController.text = selectedAgent.toString();
              },
            ),
            SizedBox(height: 16),
            SelectDateButton(
              buttonText: 'Select Loan Date',
              onDateSelected: (selectedDate) {
                _loanDateController.text = selectedDate.toString();
              },
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Flexible Payment', style: TextStyle(fontSize: 16)),
                SizedBox(width: 12),
                Switch(
                  value: isFlexible == 1,
                  onChanged: (value) {
                    setState(() {
                      isFlexible = value ? 1 : 0;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        // Cancel Button
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),
        // Add Button
        TextButton(
          onPressed: () async {
            if (_agentIdController.text.isEmpty ||
                _clientNameController.text.isEmpty ||
                _loanAmountController.text.isEmpty ||
                _termController.text.isEmpty ||
                _interestRateController.text.isEmpty ||
                _loanDateController.text.isEmpty ||
                _agentInterestController.text.isEmpty) {
              // Show a SnackBar indicating that all fields are required
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All fields are required'),
                  duration: Duration(seconds: 2),
                ),
              );
              return;
            }
            Client client = Client(
              clientName: _clientNameController.text,
              loanAmount: double.parse(_loanAmountController.text),
              loanTerm: int.parse(_termController.text),
              interestRate: double.parse(_interestRateController.text),
              loanDate: _loanDateController.text,
              agentId: int.parse(_agentIdController.text),
              agentInterest: double.parse(_agentInterestController.text),
              isFlexible: isFlexible,
            );

            // Create the client
            clientCrud.createClient(client);

            // Get Most Recent Client
            Client recent = await clientCrud.getMostRecentClient();

            //Generate Payment Schedule for Client
            if (isFlexible == 1) {
              // await paymentCrud.generateFlexiblePayments(recent);
              await paymentCrud.generateFlexiblePayment(recent);
            } else {
              await paymentCrud.generatePayments(recent);
            }

            // Import to Balance Sheet
            await balanceSheetCrud.createBalanceSheet(
              BalanceSheet(
                date: _loanDateController.text,
                inAmount: 0,
                outAmount: double.parse(_loanAmountController.text),
                balance: 0 - double.parse(_loanAmountController.text),
                remarks: 'Loan for ${_clientNameController.text}',
                clientId: recent.clientId!,
              ),
            );

            // Set to Overdue Past Due Date
            await paymentCrud.updateOverduePayments();

            Navigator.pop(context);

            // Refresh the client list
            widget.onClientAdded();

            // Add snackbar to show success message
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Client added successfully'),
                duration: Duration(seconds: 2),
              ),
            );
          },
          child: const Text("Add"),
        ),
      ],
    );
  }
}
