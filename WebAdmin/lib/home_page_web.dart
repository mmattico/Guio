import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'get_tickets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePageWeb extends StatefulWidget {
  List<Ticket> tickets;
  final void Function(Ticket) onOpenTicketDetails;
  final void Function(Ticket, String) onStatusChanged;
  int cantidadAlertas = 0;


  HomePageWeb({
    required this.tickets,
    required this.onOpenTicketDetails,
    required this.onStatusChanged,
    required this.cantidadAlertas
  });

  @override
  _HomePageWebState createState() => _HomePageWebState();
}

class _HomePageWebState extends State<HomePageWeb> {
  late List<Ticket> _filteredTickets;
  late TextEditingController _searchController;
  late int cantidadAlertasPrev = 0;
  late int cantidadAlertasNuevas = 0;

  @override
  void initState() {
    super.initState();
    _filteredTickets = widget.tickets;
    _searchController = TextEditingController();
    _searchController.addListener(_filterTickets);
    cantidadAlertasPrev = widget.cantidadAlertas;
  }

  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterTickets() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredTickets = widget.tickets.where((ticket) {
        return ticket.id.toString().contains(query);
      }).toList();
    });
  }

  void _updateStatus(Ticket ticket, String newStatus) {
    try {
      setState(() {
        ticket.estado = newStatus;
        widget.onStatusChanged(ticket, newStatus);
      });
      updateTicketStatus(ticket.id, newStatus);

    } catch (e) {
      print('Error al actualizar el estado: $e');
    }
  }

  late List<Ticket> oldTickets;

  Future<void> _refreshAlertas() async {
    try {
      List<Ticket> nuevasAlertas = await fetchAlertas('PRUEBA');
      setState(() {
        oldTickets = _filteredTickets;
        cantidadAlertasNuevas = nuevasAlertas.length;
        setState(() {
          _filteredTickets = nuevasAlertas;
          cantidadAlertasPrev = oldTickets.length;
        });

      });
    } catch (e) {
      print('Error al actualizar alertas: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              const Spacer(),
              Text('Cantidad Alertas (previa): $cantidadAlertasPrev'),
              //boton de refresh
              IconButton(
                icon: Icon(Icons.refresh),
                iconSize: 35.0,
                color: Color.fromRGBO(17, 116, 186, 1),
                tooltip: 'Actualizar listado de alertas',
                onPressed: () async {
                  await _refreshAlertas();
                },
              ),
              Text('Cantidad Alertas (actual): $cantidadAlertasNuevas'),

              Flexible(child: SizedBox(
                  width: 500,
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Buscar por número de Ticket...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('N° Ticket')),
                DataColumn(label: Text('Fecha y Hora')),
                DataColumn(label: Text('Apellido y Nombre')),
                DataColumn(label: Text('Ubicacion')),
                DataColumn(label: Text('Estado')),
                DataColumn(label: Text('Comentarios')),
              ],
              rows: _filteredTickets.map((ticket) => DataRow(
                cells: [
                  DataCell(
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => widget.onOpenTicketDetails(ticket),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.blueAccent, width: 1.0),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            ticket.id.toString().padLeft(4, '0'),
                            style: const TextStyle(
                              color: Colors.blueAccent,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  DataCell(Text('${DateFormat('dd-MM-yyyy – kk:mm').format(ticket.fecha)}')),
                  DataCell(Text(ticket.apellido)),
                  DataCell(Text(ticket.areaEmergencia)),
                  DataCell(
                    DropdownButton<String>(
                      value: ticket.estado,
                      items: ['pendiente', 'en curso', 'finalizada', 'cancelada']
                          .map((status) => DropdownMenuItem<String>(
                        value: status,
                        child: Text(status),
                      ))
                          .toList(),
                      onChanged: (newStatus) {
                        if (newStatus != null) {
                          _updateStatus(ticket, newStatus);
                        }
                      },
                      dropdownColor: Colors.white,
                    ),
                  ),
                  DataCell(Text(ticket.comentario)),
                ],
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }

}

Future<void> updateTicketStatus(int ticketId, String newStatus) async {
  final url = Uri.https('guio-hgazcxb0cwgjhkev.eastus-01.azurewebsites.net', '/api/alerta/$ticketId/estado');

  print('nuevo estado: ' + newStatus);

  final response = await http.put(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: newStatus,
  );

  if (response.statusCode == 200) {
    print('Ticket actualizado con éxito');
  } else {
    print('Error al actualizar el ticket: ${response.statusCode}');
    print('Respuesta: ${response.body}');
  }
}