import 'package:flutter/material.dart';

class StatsCard extends StatefulWidget {
  final String title;
  final double value;
  const StatsCard({super.key, required this.title, required this.value});

  @override
  State<StatsCard> createState() => _StatsCardState();
}

class _StatsCardState extends State<StatsCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Text(widget.title),
            SizedBox(height: 8),
            Text(
              widget.value == 0
                  ? "₱ 0.00"
                  : "₱ ${widget.value.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
