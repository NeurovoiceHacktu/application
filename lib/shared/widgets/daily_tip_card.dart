import 'package:flutter/material.dart';

class DailyTipCard extends StatelessWidget {
  final String tip;
  const DailyTipCard({super.key, required this.tip});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Daily Tip",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(tip),
          ],
        ),
      ),
    );
  }
}
