import 'package:flutter/material.dart';
import 'package:loan_app/components/balanceSheetComponents/entry_add_dialog.dart';
import 'package:loan_app/components/balanceSheetComponents/entry_delete_dialog.dart';
import 'package:loan_app/components/balanceSheetComponents/entry_update_dialog.dart';
import 'package:loan_app/components/balanceSheetComponents/remarks_link_button.dart';
import 'package:loan_app/components/utilComponents/money_text.dart';
import 'package:loan_app/models/balanceSheet.dart';

class BalanceSheetTable extends StatefulWidget {
  final VoidCallback refreshBalanceSheetTable;
  final List<BalanceSheet> balanceSheetData;
  const BalanceSheetTable({
    super.key,
    required this.balanceSheetData,
    required this.refreshBalanceSheetTable,
  });

  @override
  State<BalanceSheetTable> createState() => _BalanceSheetTableState();
}

class _BalanceSheetTableState extends State<BalanceSheetTable> {
  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: [
        DataColumn(label: Text("")),
        DataColumn(label: Text("Date")),
        DataColumn(label: Text("IN")),
        DataColumn(label: Text("OUT")),
        DataColumn(label: Text("Balance")),
        DataColumn(label: Text("Remarks")),
        DataColumn(
          label: TextButton(
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.blue),
              foregroundColor: WidgetStatePropertyAll(Colors.white),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder:
                    (context) => EntryAddDialog(
                      onEntryAdded: () {
                        widget.refreshBalanceSheetTable();
                      },
                    ),
              );
            },
            child: Text("Add Entry +"),
          ),
        ),
      ],
      rows: [
        ...widget.balanceSheetData.map(
          (sheet) => DataRow(
            cells: [
              DataCell(
                Text((widget.balanceSheetData.indexOf(sheet) + 1).toString()),
              ),
              DataCell(Text(sheet.date.toString())),
              DataCell(MoneyText(amount: sheet.inAmount)),
              DataCell(MoneyText(amount: sheet.outAmount)),
              DataCell(MoneyText(amount: sheet.balance)),
              DataCell(
                sheet.clientId != null
                    ? RemarksLinkButton(
                      remarks: sheet.remarks!,
                      clientId: sheet.clientId!,
                      whenComplete: () {
                        widget.refreshBalanceSheetTable();
                      },
                    )
                    : TextButton(
                      style: ButtonStyle(
                        foregroundColor: WidgetStatePropertyAll(Colors.black),
                      ),
                      onPressed: () {},
                      child: Text(sheet.remarks!),
                    ),
              ),
              DataCell(
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder:
                                (context) => EntryUpdateDialog(
                                  onEntryUpdated: () {
                                    widget.refreshBalanceSheetTable();
                                  },
                                  balanceSheet: sheet,
                                ),
                          );
                        },
                        icon: Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder:
                                (context) => EntryDeleteDialog(
                                  onConfirmDelete:
                                      widget.refreshBalanceSheetTable,
                                  balanceSheetId: sheet.balanceSheetId!,
                                ),
                          );
                        },
                        icon: Icon(Icons.delete),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        DataRow(
          color: WidgetStatePropertyAll(Colors.indigo),
          cells: [
            DataCell(Text("")),
            DataCell(Text("Total:", style: TextStyle(color: Colors.white))),
            DataCell(
              Text(
                '₱ ${widget.balanceSheetData.fold(0.0, (sum, sheet) => sum + sheet.inAmount).toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                style: TextStyle(color: Colors.white),
              ),
            ),
            DataCell(
              Text(
                '₱ ${widget.balanceSheetData.fold(0.0, (sum, sheet) => sum + sheet.outAmount).toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                style: TextStyle(color: Colors.white),
              ),
            ),
            DataCell(
              Text(
                '₱ ${widget.balanceSheetData.fold(0.0, (sum, sheet) => sum + sheet.balance).toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                style: TextStyle(color: Colors.white),
              ),
            ),
            DataCell(Text("")),
            DataCell(Text("")),
          ],
        ),
      ],
    );
  }
}
