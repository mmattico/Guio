import 'package:flutter/material.dart';
import 'package:guio_web_admin/home_page_web.dart';
import 'package:guio_web_admin/login_admin.dart';
import 'get_tickets.dart';

void main() {
  runApp(TicketSystemApp());
}

class TicketSystemApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //home: TicketListPage(),
      //home: LoginPage(),
      //home: TicketListPage(),
      home: WebHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

