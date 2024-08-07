import 'package:flutter/material.dart';
import 'get_tickets.dart';

void main() {
  runApp(TicketSystemApp());
}

class TicketSystemApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TicketListPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

