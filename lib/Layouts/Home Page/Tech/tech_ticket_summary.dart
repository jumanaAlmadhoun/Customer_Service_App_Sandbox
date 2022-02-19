import 'package:flutter/material.dart';

class TechTicketSummary extends StatefulWidget {
  const TechTicketSummary({Key? key}) : super(key: key);

  @override
  _TechTicketSummaryState createState() => _TechTicketSummaryState();
}

class _TechTicketSummaryState extends State<TechTicketSummary> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ملخص الزيارة'),
      ),
    );
  }
}
