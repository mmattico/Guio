import 'package:flutter/material.dart';
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
                DataColumn(label: Text('N°')),
                DataColumn(label: Text('Asunto')),
                DataColumn(label: Text('Fecha')),
                DataColumn(label: Text('Estado')),
                DataColumn(label: Text('Ubicación')),
                //DataColumn(label: Text('Acciones')),
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
                            color: Colors.white,  // Color de fondo del rectángulo
                            border: Border.all(color: Colors.blueAccent, width: 1.0),  // Color y ancho del borde
                            borderRadius: BorderRadius.circular(8.0),  // Bordes redondeados
                          ),
                          child: Text(
                            ticket.id as String,
                            style: TextStyle(
                              color: Colors.blueAccent,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  DataCell(Text(ticket.areaEmergencia)),
                  DataCell(Text(ticket.fecha)),
                  DataCell(
                    DropdownButton<String>(
                      dropdownColor: Colors.white,
                      value: ticket.estado,
                      items: ['ABIERTO', 'EN CURSO', 'FINALIZADO']
                          .map((status) => DropdownMenuItem<String>(
                        value: status,
                        child: Text(status),
                      ))
                          .toList(),
                      onChanged: (newStatus) {
                        if (newStatus != null) {
                          onStatusChanged(ticket, newStatus);
                        }
                      },
                    ),
                  ),
                  DataCell(Text(ticket.areaEmergencia)),
                ],
              )).toList(),
            ),
          ),
        ),
      ],
    );
  }
}