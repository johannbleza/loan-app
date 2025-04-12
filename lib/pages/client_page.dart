import 'package:flutter/material.dart';
import 'package:loan_app/components/clientsComponents/client_info_row.dart';
import 'package:loan_app/components/clientsComponents/client_stats_row.dart';
import 'package:loan_app/components/paymentComponents/payment_schedule_table.dart';
import 'package:loan_app/models/client.dart';
import 'package:loan_app/models/partial.dart';
import 'package:loan_app/models/payment.dart';
import 'package:loan_app/utils/globals.dart';

class ClientPage extends StatefulWidget {
  final Client client;
  const ClientPage({super.key, required this.client});

  @override
  State<ClientPage> createState() => _ClientPageState();
}

class _ClientPageState extends State<ClientPage> {
  List<Payment> paymentsData = [];
  List<Partial> partialsData = [];

  getAllPaymentsByClientId() async {
    final payments = await paymentCrud.getAllPaymentsByClientId(
      widget.client.clientId!,
    );
    getAllPartialsByClientId();

    setState(() {
      paymentsData = payments;
    });
  }

  getAllPartialsByClientId() async {
    final partials = await partialCrud.getAllPartialsByClientId(
      widget.client.clientId!,
    );

    setState(() {
      partialsData = partials;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getAllPaymentsByClientId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Client Details",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 24),
                    ClientInfoRow(client: widget.client),
                    SizedBox(height: 24),
                    ClientStatsRow(
                      paymentsData: paymentsData,
                      partialsData: partialsData,
                    ),
                    SizedBox(height: 24),
                    PaymentScheduleTable(
                      paymentsData: paymentsData,
                      partialsData: partialsData,
                      refreshPaymentScheduleTable: getAllPaymentsByClientId,
                    ),
                    SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
