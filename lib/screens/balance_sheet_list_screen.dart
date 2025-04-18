import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:loan_app/components/balanceSheetComponents/balance_sheet_table.dart';
import 'package:loan_app/components/utilComponents/balance_sheet_order.dart';
import 'package:loan_app/models/balanceSheet.dart';
import 'package:loan_app/utils/globals.dart';

class BalanceSheetListScreen extends StatefulWidget {
  const BalanceSheetListScreen({super.key});

  @override
  State<BalanceSheetListScreen> createState() => _BalanceSheetListScreenState();
}

class _BalanceSheetListScreenState extends State<BalanceSheetListScreen> {
  List<BalanceSheet> balanceSheetData = [];
  String orderBy = "entry";

  getBalanceSheet() async {
    var balanceSheet = await balanceSheetCrud.getAllBalanceSheets();

    // Sort by ascending order of date
    if (orderBy == "dateASC") {
      balanceSheet.sort((a, b) {
        DateTime dateA = Jiffy.parse(a.date, pattern: 'MMM d, yyyy').dateTime;
        DateTime dateB = Jiffy.parse(b.date, pattern: 'MMM d, yyyy').dateTime;
        return dateA.compareTo(dateB);
      });
    } else if (orderBy == "dateDESC") {
      balanceSheet.sort((a, b) {
        DateTime dateA = Jiffy.parse(a.date, pattern: 'MMM d, yyyy').dateTime;
        DateTime dateB = Jiffy.parse(b.date, pattern: 'MMM d, yyyy').dateTime;
        return dateB.compareTo(dateA);
      });
    }

    setState(() {
      balanceSheetData = balanceSheet;
    });
  }

  @override
  void initState() {
    getBalanceSheet();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: ListView(
        children: [
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 24),
                Text(
                  "Balance Sheet",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 20),
                BalanceSheetOrder(
                  onOrderSelected: (value) {
                    setState(() {
                      orderBy = value;
                      getBalanceSheet();
                    });
                  },
                ),
                SizedBox(height: 20),
                Text(
                  'Entries List (${balanceSheetData.length})',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 20),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: BalanceSheetTable(
                    balanceSheetData: balanceSheetData,
                    refreshBalanceSheetTable: () {
                      getBalanceSheet();
                    },
                  ),
                ),
                SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
