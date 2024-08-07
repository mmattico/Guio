import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'home_page_web.dart';
import 'kanban_view.dart';
import 'ticket_dialog.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';  // For jsonEncode

Future<List<Ticket>> fetchAlertas(String ubicacionCodigo) async {
  final response = await http.get(Uri.https('guio-hgazcxb0cwgjhkev.eastus-01.azurewebsites.net', '/api/alerta/$ubicacionCodigo'));


  if (response.statusCode == 200) {
    final utf8DecodedBody = utf8.decode(response.bodyBytes);
    List<dynamic> body = jsonDecode(utf8DecodedBody);
    //List<dynamic> body = jsonDecode(response.body);
    print('JSON recibido: $body'); // Depuración

    if (body == null) {
      return [];
    }
    List<Ticket> alertas = body.map((dynamic item) => Ticket.fromJson(item)).toList();
    return alertas;
  } else {
    print('Error al obtener alertas: ${response.statusCode}');
    print('Cuerpo de la respuesta: ${response.body}');
    throw Exception('Failed to load alertas');
  }
}

class Ticket {
  final int id;
  //final String usuarioID;
  final DateTime fecha;
  final String comentario;
  final String areaEmergencia;
  final String estado;

  Ticket({
    required this.id,
    required this.fecha,
    required this.comentario,
    required this.areaEmergencia,
    required this.estado});

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['alertaID'] ?? 000,
      fecha: DateTime.parse(json['fecha']),
      comentario: json['comentario']?.toString() ?? '',
      areaEmergencia: json['lugarDeAlerta']?.toString() ?? '',
      estado: json['estado']?.toString() ?? '',
    );
  }

  @override
  String toString() {
    return 'Ticket(id: $id, comentario: $comentario, estado: $estado, areaEmergencia: $areaEmergencia, fecha: $fecha, comentario: $comentario)';
  }
}

class TicketListPage extends StatefulWidget {
  @override
  _TicketListPageState createState() => _TicketListPageState();
}

class _TicketListPageState extends State<TicketListPage> {

  late Future<List<Ticket>> futureAlertas;
  bool _isKanbanView = false;

  @override
  void initState() {
    super.initState();
    futureAlertas = fetchAlertas('PRUEBA');
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
            return Center(child: Text('No hay tickets disponibles'));
          } else {
            List<Ticket> tickets = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: _isKanbanView
                  ? KanbanView(tickets: tickets)
                  : HomePageWeb(
                      tickets: tickets,
                      onOpenTicketDetails: _openTicketDetails,
                      onStatusChanged: _updateTicketStatus,
              ),
            );
          }
        },
      ),
    );
  }
}





      /*FutureBuilder<List<Ticket>>(
        future: futureAlertas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay tickets disponibles'));
          } else {
            List<Ticket> tickets = snapshot.data!;

            // Imprimir los detalles de los tickets para depuración
            for (var i = 0; i < tickets.length; i++) {
              print('Ticket $i: ${tickets[i]}');
            }

            return ListView.builder(
              itemCount: tickets.length,
              itemBuilder: (context, index) {
                return TicketCard(ticket: tickets[index]);
              },
            );
          }
        },
      )
    );
  }
}*/

/*Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isKanbanView
            ? KanbanView(tickets: tickets)
            : HomePageWeb(tickets: tickets, onOpenTicketDetails: _openTicketDetails, onStatusChanged: _updateTicketStatus),
      ),*/


class TicketCard extends StatelessWidget {
  final Ticket ticket;

  TicketCard({required this.ticket});

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd-MM-yyyy – kk:mm').format(ticket.fecha);
    return Card(
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        contentPadding: EdgeInsets.all(16.0),
        title: Text(ticket.areaEmergencia, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Descripción: ${ticket.areaEmergencia}'),
            Text('Estado: ${ticket.estado}'),
            Text('Fecha: $formattedDate'),
            Text('Prioridad: ${ticket.areaEmergencia}'),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }
}