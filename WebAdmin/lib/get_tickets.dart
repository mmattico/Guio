import 'package:flutter/material.dart';
import 'package:guio_web_admin/area_management.dart';
import 'package:guio_web_admin/login_admin.dart';
import 'package:guio_web_admin/AlertsPage.dart';
import 'package:guio_web_admin/other/user_session.dart';
import 'kanban_view.dart';
import 'ticket_dialog.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For jsonEncode

Future<List<Ticket>> fetchAlertas(Future<String?> ubicacionCodigo) async {
  final graphCode = await ubicacionCodigo;
  if (graphCode == null) {
    throw Exception('Graph code no proporcionado.');
  }
  print(Uri.https('guio-hgazcxb0cwgjhkev.eastus-01.azurewebsites.net',
      '/api/alerta/$graphCode'));
  final response = await http.get(Uri.https(
      'guio-hgazcxb0cwgjhkev.eastus-01.azurewebsites.net',
      '/api/alerta/$graphCode'));

  if (response.statusCode == 200) {
    final utf8DecodedBody = utf8.decode(response.bodyBytes);
    List<dynamic> body = jsonDecode(utf8DecodedBody);
    //List<dynamic> body = jsonDecode(response.body);
    print('JSON recibido: $body'); // Depuración

    if (body == null) {
      return [];
    }
    List<Ticket> alertas =
        body.map((dynamic item) => Ticket.fromJson(item)).toList();
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
  String estado;
  final String apellido;
  final String telefono;
  final String dni;
  final String nombre;

  Ticket(
      {required this.id,
      required this.fecha,
      required this.comentario,
      required this.areaEmergencia,
      required this.estado,
      required this.apellido,
      required this.telefono,
      required this.dni,
      required this.nombre});

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
        id: json['alertaID'] ?? 000,
        fecha: DateTime.parse(json['fecha']),
        comentario: json['comentario']?.toString() ?? '',
        areaEmergencia: json['lugarDeAlerta']?.toString() ?? '',
        estado: json['estado']?.toString() ?? '',
        apellido: json['apellido']?.toString() ?? '',
        telefono: json['telefono']?.toString() ?? '',
        dni: json['dni']?.toString() ?? '',
        nombre: json['nombre']?.toString() ?? '');
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
  List<Ticket>? _tickets;
  bool _isKanbanView = false;
  Future<String?> graphCode = getGraphCode();

  @override
  void initState() {
    super.initState();

    futureAlertas = fetchAlertas(graphCode);
    futureAlertas.then((tickets) {
      setState(() {
        _tickets = tickets;
      });
    });
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

  int cantidadAlertas = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: Column(
          children: [
            SizedBox(height: 20.0),
            AppBar(
              automaticallyImplyLeading: false,
              elevation: 0,
              scrolledUnderElevation: 0,
              centerTitle: true,
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF1174ba),
              title: const Text(
                'Gestión de Alertas de Usuarios',
                style: TextStyle(
                    fontFamily: 'Oswald',
                    fontSize: 50,
                    fontWeight: FontWeight.bold),
              ),
              actions: [
                IconButton(
                  icon: Icon(
                      _isKanbanView ? Icons.table_chart : Icons.view_kanban),
                  onPressed: _toggleView,
                ),
              ],
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<Ticket>>(
        future: futureAlertas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay tickets disponibles'));
          } else {
            List<Ticket> tickets = snapshot.data!;
            cantidadAlertas = tickets.length;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: _isKanbanView
                  ? KanbanView(tickets: tickets)
                  : Alerts(
                      tickets: tickets,
                      onOpenTicketDetails: _openTicketDetails,
                      onStatusChanged: _updateTicketStatus,
                      cantidadAlertas: cantidadAlertas,
                    ),
            );
          }
        },
      ),
    );
  }
}
