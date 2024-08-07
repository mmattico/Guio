import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'get_tickets.dart';

class KanbanView extends StatelessWidget {
  final List<Ticket> tickets;

  KanbanView({required this.tickets});

  @override
  Widget build(BuildContext context) {
    Map<String, List<Ticket>> groupedTickets = {
      'ABIERTO': tickets.where((ticket) => ticket.estado == 'pendiente').toList(),
      'EN CURSO': tickets.where((ticket) => ticket.estado == 'en curso').toList(),
      'FINALIZADO': tickets.where((ticket) => ticket.estado == 'cerrado').toList(),
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
                        //color: Colors.white, Ponerle color azul clarito
                        child: ListTile(
                          title: Text('ID: ${ticket.id}'),
                          subtitle: Text('N°: ${ticket.id}\nFecha: ${DateFormat('dd-MM-yyyy – kk:mm').format(ticket.fecha)}'),
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