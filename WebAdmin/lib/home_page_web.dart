import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'get_tickets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePageWeb extends StatefulWidget {
  final List<Ticket> tickets;
  final void Function(Ticket) onOpenTicketDetails;
  final void Function(Ticket, String) onStatusChanged;

  HomePageWeb({
    required this.tickets,
    required this.onOpenTicketDetails,
    required this.onStatusChanged,
  });

  @override
  _HomePageWebState createState() => _HomePageWebState();
}

class _HomePageWebState extends State<HomePageWeb> {
  late List<Ticket> _filteredTickets;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _filteredTickets = widget.tickets;
    _searchController = TextEditingController();
    _searchController.addListener(_filterTickets);
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Spacer(),
            Container(
              width: 500,
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  labelText: 'Buscar por número de Ticket...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                const DataColumn(label: Text('N° Ticket')),
                const DataColumn(label: Text('Fecha y Hora')),
                const DataColumn(label: Text('Ubicacion')),
                const DataColumn(label: Text('Estado')),
                const DataColumn(label: Text('Comentarios')),
                //DataColumn(label: Text('Prioridad')),
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
                            //'${ticket.id}',
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
                  DataCell(Text(ticket.areaEmergencia)),
                  DataCell(
                    DropdownButton<String>(
                      value: ticket.estado,
                      items: ['pendiente', 'en curso', 'cerrado']
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
        ),
      ],
    );
  }
}

Future<void> updateTicketStatus(int ticketId, String newStatus) async {
  final url = Uri.https('guio-hgazcxb0cwgjhkev.eastus-01.azurewebsites.net', '/api/alerta/$ticketId/estado'); // Reemplaza con la URL correcta

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
