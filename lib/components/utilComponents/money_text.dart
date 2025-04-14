import 'package:flutter/material.dart';

class MoneyText extends StatefulWidget {
  final Color? color;

  final double amount;
  const MoneyText({super.key, required this.amount, this.color});

  @override
  State<MoneyText> createState() => _MoneyTextState();
}

class _MoneyTextState extends State<MoneyText> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.amount == 0
          ? ""
          : '₱ ${widget.amount.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
      style: TextStyle(color: widget.color ?? Colors.black),
    );
  }
}
