import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

class SelectYearDropdown extends StatefulWidget {
  final ValueChanged<int> onYearSelected;
  const SelectYearDropdown({super.key, required this.onYearSelected});

  @override
  State<SelectYearDropdown> createState() => _SelectYearDropdownState();
}

class _SelectYearDropdownState extends State<SelectYearDropdown> {
  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      width: 200,
      label: const Text("Select Year"),
      initialSelection: Jiffy.now().year,
      onSelected: (value) {
        widget.onYearSelected.call(value as int);
      },
      dropdownMenuEntries: [
        for (int i = Jiffy.now().year - 5; i < Jiffy.now().year + 5; i++)
          DropdownMenuEntry(label: i.toString(), value: i),
      ],
    );
  }
}
