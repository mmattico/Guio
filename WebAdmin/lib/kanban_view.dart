import 'package:flutter/material.dart';
import 'get_tickets.dart';

class KanbanView extends StatelessWidget {
  final List<Ticket> tickets;

  KanbanView({required this.tickets});

  @override
  Widget build(BuildContext context) {
    Map<String, List<Ticket>> groupedTickets = {
      'ABIERTO': tickets.where((ticket) => ticket.estado == 'ABIERTO').toList(),
      'EN CURSO': tickets.where((ticket) => ticket.estado == 'EN CURSO').toList(),
      'FINALIZADO': tickets.where((ticket) => ticket.estado == 'FINALIZADO').toList(),
    };

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: groupedTickets.keys.map((status) {
            return Container(
              width: 300,
              child: Column(
                children: [
                  Text(status, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: groupedTickets[status]!
                          .map((ticket) => Card(
                        child: ListTile(
                          title: Text(ticket.id as String),
                          subtitle: Text('N°: ${ticket.id}\nFecha: ${ticket.fecha}'),
                          onTap: () {
                            // Acción al hacer clic en el ticket
                          },
                        ),
                      ))
                          .toList(),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}