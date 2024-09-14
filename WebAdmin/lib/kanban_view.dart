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
      'FINALIZADO': tickets.where((ticket) => ticket.estado == 'finalizada').toList(),
      'CANCELADA': tickets.where((ticket) => ticket.estado == 'cancelada').toList(),
    };

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width,
        ),
        child: Row(
          children: [
            const SizedBox(width: 150,),
            Row(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: groupedTickets.keys.map((status) {
                return Container(
                  padding: EdgeInsets.all(8.0),
                  color: Colors.white,
                  width: 300,
                  child: Column(
                    children: [
                      Text(status, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8,),
                      Expanded(
                        child: ListView(
                          shrinkWrap: true,
                          children: groupedTickets[status]!
                              .map((ticket) => Card(
                            //color: Colors.white, Ponerle color azul clarito // Color.fromRGBO(17, 116, 186, 1)
                            child: ListTile(
                              title: Text(ticket.id.toString().padLeft(4, '0'),),
                              subtitle: Text('Usuario: ${ticket.nombre}\nFecha: ${DateFormat('dd-MM-yyyy – kk:mm').format(ticket.fecha)}'),
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
          ],
        )
      ),
    );
  }
}