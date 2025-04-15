import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

class SelectMonthDropdown extends StatefulWidget {
  final ValueChanged<int> onMonthSelected;
  const SelectMonthDropdown({super.key, required this.onMonthSelected});

  @override
  State<SelectMonthDropdown> createState() => _SelectMonthDropdownState();
}

class _SelectMonthDropdownState extends State<SelectMonthDropdown> {
  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      width: 200,
      label: const Text("Select Month"),
      initialSelection: Jiffy.now().month,
      onSelected: (value) {
        widget.onMonthSelected.call(value as int);
      },
      dropdownMenuEntries: [
        DropdownMenuEntry(label: "January", value: 1),
        DropdownMenuEntry(label: "February", value: 2),
        DropdownMenuEntry(label: "March", value: 3),
        DropdownMenuEntry(label: "April", value: 4),
        DropdownMenuEntry(label: "May", value: 5),
        DropdownMenuEntry(label: "June", value: 6),
        DropdownMenuEntry(label: "July", value: 7),
        DropdownMenuEntry(label: "August", value: 8),
        DropdownMenuEntry(label: "September", value: 9),
        DropdownMenuEntry(label: "October", value: 10),
        DropdownMenuEntry(label: "November", value: 11),
        DropdownMenuEntry(label: "December", value: 12),
        DropdownMenuEntry(label: "All Months", value: null),
      ],
    );
  }
}
