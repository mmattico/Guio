import 'package:flutter/material.dart';
import 'home_page_web.dart';
import 'kanban_view.dart';
import 'ticket_dialog.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';  // For jsonEncode

Future<List<Ticket>> fetchAlertas(String ubicacionCodigo) async {
  final response = await http.get(Uri.https('guio-hgazcxb0cwgjhkev.eastus-01.azurewebsites.net', '/api/alerta/'));

  if (response.statusCode == 200) {
    List<dynamic> body = jsonDecode(response.body);
    print(json.decode(response.body));
    return body.map((dynamic item) => Ticket.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load alertas');
  }
}

class Ticket {
  final int id;
  //final String usuarioID;
  final String fecha;
  final String comentario;
  final String areaEmergencia;
  final String estado; // Ejemplo de campo adicional

  Ticket({
    required this.id,
    required this.fecha,
    required this.comentario,
    required this.areaEmergencia,
    required this.estado});

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['alertaID'],
      fecha: json['Fecha'],
      comentario: json['Comentario'],
      areaEmergencia: json['lugar_de_alerta'],
      estado: json['Estado'],
    );
  }
}

class TicketListPage extends StatefulWidget {
  @override
  _TicketListPageState createState() => _TicketListPageState();
}

class _TicketListPageState extends State<TicketListPage> {
  /*List<Ticket> tickets = [
    Ticket(number: '0000001', subject: 'New Ticket', creation: '14/07/2024 05:06:49 pm', timeSinceLastResponse: 'Hace 1 Hora',
        dni: '1111', name: 'Jose Perez', location: 'Traumatologia', numberPhone: '1122334455'),
    Ticket(number: '0000002', subject: 'New Ticket', creation: '14/07/2024 05:01:38 pm', timeSinceLastResponse: 'Hace 1 Hora',
        dni: '1111', name: 'Jose Perez', location: 'Traumatologia', numberPhone: '1122334455'),
    Ticket(number: '0000003', subject: 'New Ticket', creation: '14/07/2024 05:06:49 pm', timeSinceLastResponse: 'Hace 1 Hora',
        dni: '1111', name: 'Jose Perez', location: 'Traumatologia', numberPhone: '1122334455'),
    Ticket(number: '0000004', subject: 'New Ticket', creation: '14/07/2024 05:01:38 pm', timeSinceLastResponse: 'Hace 1 Hora',
        dni: '1111', name: 'Jose Perez', location: 'Traumatologia', numberPhone: '1122334455'),
    Ticket(number: '0000005', subject: 'New Ticket', creation: '14/07/2024 05:06:49 pm', timeSinceLastResponse: 'Hace 1 Hora',
        dni: '1111', name: 'Jose Perez', location: 'Traumatologia', numberPhone: '1122334455'),
    Ticket(number: '0000006', subject: 'New Ticket', creation: '14/07/2024 05:01:38 pm', timeSinceLastResponse: 'Hace 1 Hora',
        dni: '1111', name: 'Jose Perez', location: 'Traumatologia', numberPhone: '1122334455'),
  ];*/

  late Future<List<Ticket>> futureAlertas;
  bool _isKanbanView = false;

  @override
  void initState() {
    super.initState();
    futureAlertas = fetchAlertas('Prueba');
  }

  void _toggleView() {
    setState(() {
      _isKanbanView = !_isKanbanView;
    });
  }

  void _openTicketDetails(Ticket ticket) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return TicketDetailsDialog(ticket: ticket);
      },
    ).then((_) {
      setState(() {});
    });
  }

  void _updateTicketStatus(Ticket ticket, String newStatus) {
    setState(() {
      //ticket.estado = newStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('GUIO - Atención de Alertas de Usuarios'),
        actions: [
          IconButton(
            icon: Icon(_isKanbanView ? Icons.table_chart : Icons.view_kanban),
            onPressed: _toggleView,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('Usuario Admin'),
              accountEmail: Text(''),
              currentAccountPicture: CircleAvatar(
                child: Icon(Icons.person),
              ),
            ),
            ListTile(
              title: Text('Inicio'),
              leading: Icon(Icons.home),
              onTap: () {},
            ),
            ListTile(
              title: Text('Dashboard'),
              leading: Icon(Icons.bar_chart),
              selected: true,
              onTap: () {},
            ),
            ListTile(
              title: Text('Cerrar Sesion'),
              leading: Icon(Icons.exit_to_app),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<Ticket>>(
        future: futureAlertas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay alertas disponibles'));
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: _isKanbanView
                  ? KanbanView(tickets: snapshot.data!)
                  : HomePageWeb(
                tickets: snapshot.data!,
                onOpenTicketDetails: _openTicketDetails,
                onStatusChanged: _updateTicketStatus,
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _isKanbanView = !_isKanbanView;
          });
        },
        child: Icon(Icons.swap_horiz),
      ),
    );
  }


/*Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isKanbanView
            ? KanbanView(tickets: tickets)
            : HomePageWeb(tickets: tickets, onOpenTicketDetails: _openTicketDetails, onStatusChanged: _updateTicketStatus),
      ),*/
}
