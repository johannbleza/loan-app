import 'package:flutter/material.dart';
import 'package:loan_app/components/utilComponents/select_agent_button.dart';
import 'package:loan_app/components/utilComponents/select_month_dropdown.dart';
import 'package:loan_app/components/utilComponents/select_year_dropdown.dart';

class MonthlyRowFilters extends StatefulWidget {
  final ValueChanged<dynamic> onMonthSelected;
  final ValueChanged<dynamic> onYearSelected;
  final ValueChanged<dynamic> onAgentSelected;
  const MonthlyRowFilters({
    super.key,
    required this.onMonthSelected,
    required this.onYearSelected,
    required this.onAgentSelected,
  });

  @override
  State<MonthlyRowFilters> createState() => _MonthlyRowFiltersState();
}

class _MonthlyRowFiltersState extends State<MonthlyRowFilters> {
  int? selectedAgent;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SelectMonthDropdown(
          onMonthSelected: (int? value) {
            setState(() {
              widget.onMonthSelected(value);
            });
          },
        ),
        SizedBox(width: 20),
        SelectYearDropdown(
          onYearSelected: (int? value) {
            setState(() {
              widget.onYearSelected(value);
            });
          },
        ),
        SizedBox(width: 20),
        SelectAgentButton(
          onAgentSelected: (value) {
            setState(() {
              selectedAgent = value;
              widget.onAgentSelected(value);
            });
          },
        ),
      ],
    );
  }
}
