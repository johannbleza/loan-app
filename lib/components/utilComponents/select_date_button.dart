import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

class SelectDateButton extends StatefulWidget {
  final String buttonText;
  final String? initialDate;
  final ValueChanged<String> onDateSelected;
  const SelectDateButton({
    super.key,
    required this.onDateSelected,
    this.initialDate,
    required this.buttonText,
  });

  @override
  State<SelectDateButton> createState() => _SelectDateButtonState();
}

class _SelectDateButtonState extends State<SelectDateButton> {
  String? date;
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: ButtonStyle(minimumSize: WidgetStatePropertyAll(Size(300, 60))),
      onPressed: () {
        showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        ).then((selectedDate) {
          if (selectedDate != null) {
            setState(() {
              date = Jiffy.parse(selectedDate.toString()).yMMMd;
              widget.onDateSelected(date!);
            });
          }
        });
      },
      child: Text(date == null ? widget.buttonText : date.toString()),
    );
  }
}
