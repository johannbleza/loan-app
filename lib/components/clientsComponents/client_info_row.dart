import 'package:flutter/material.dart';
import 'package:loan_app/models/client.dart';

class ClientInfoRow extends StatefulWidget {
  final Client client;
  const ClientInfoRow({super.key, required this.client});

  @override
  State<ClientInfoRow> createState() => _ClientInfoRowState();
}

class _ClientInfoRowState extends State<ClientInfoRow> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(left: BorderSide(width: 8, color: Colors.indigo)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Client Name: "),
                Text(
                  widget.client.clientName,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            SizedBox(width: 40),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Loan Start Date:"),
                Text(
                  widget.client.loanDate,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            SizedBox(width: 40),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Loan Amount:"),
                Text(
                  "₱${widget.client.loanAmount.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            SizedBox(width: 40),
            Column(
              children: [
                Text("Loan Term:"),
                Text(
                  widget.client.loanTerm.toString(),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            SizedBox(width: 40),
            Column(
              children: [
                Text("Interest Rate:"),
                Text(
                  "${widget.client.interestRate.toStringAsFixed(2)}%",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            SizedBox(width: 40),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Agent Name:"),
                Text(
                  widget.client.agentName!,

                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            SizedBox(width: 40),
            Column(
              children: [
                Text("Agent Share:"),
                Text(
                  "${widget.client.agentInterest.toStringAsFixed(2)}%",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            SizedBox(width: 40),
          ],
        ),
      ),
    );
  }
}
