import 'package:flutter/material.dart';

class BalanceSheetOrder extends StatefulWidget {
  final ValueChanged<String> onOrderSelected;
  const BalanceSheetOrder({super.key, required this.onOrderSelected});

  @override
  State<BalanceSheetOrder> createState() => _BalanceSheetOrderState();
}

class _BalanceSheetOrderState extends State<BalanceSheetOrder> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Order by:", style: TextStyle(fontSize: 20)),
        SizedBox(width: 12),
        DropdownMenu(
          initialSelection: "entry",
          width: 200,
          dropdownMenuEntries: [
            DropdownMenuEntry(label: "Entry Added", value: "entry"),
            DropdownMenuEntry(label: "Date ASC", value: "dateASC"),
            DropdownMenuEntry(label: "Date DESC", value: "dateDESC"),
          ],
          onSelected: (value) {
            widget.onOrderSelected.call(value!);
          },
        ),
      ],
    );
  }
}
