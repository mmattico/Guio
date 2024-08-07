import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'get_tickets.dart';

class HomePageWeb extends StatelessWidget {
  final List<Ticket> tickets;
  final void Function(Ticket) onOpenTicketDetails;
  final void Function(Ticket, String) onStatusChanged;

  HomePageWeb({
    required this.tickets,
    required this.onOpenTicketDetails,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Spacer(),
            Container(
              width: 500,
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Buscar...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(label: Text('N° Ticket')),
                DataColumn(label: Text('Fecha y Hora')),
                DataColumn(label: Text('Ubicacion')),
                DataColumn(label: Text('Estado')),
                DataColumn(label: Text('Comentarios')),
                //DataColumn(label: Text('Prioridad')),
              ],
              rows: tickets.map((ticket) => DataRow(
                cells: [
                  DataCell(
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => onOpenTicketDetails(ticket),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.blueAccent, width: 1.0),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            '000${ticket.id}',
                            style: TextStyle(
                              color: Colors.blueAccent,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  DataCell(Text('${DateFormat('dd-MM-yyyy – kk:mm').format(ticket.fecha)}')),
                  DataCell(Text(ticket.areaEmergencia)),
                  DataCell(Text(ticket.estado)),
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
