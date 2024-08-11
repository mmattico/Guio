import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'get_tickets.dart';

class TicketDetailsDialog extends StatefulWidget {
  final Ticket ticket;

  TicketDetailsDialog({required this.ticket});

  @override
  _TicketDetailsDialogState createState() => _TicketDetailsDialogState();
}

class _TicketDetailsDialogState extends State<TicketDetailsDialog> {
  late Ticket _ticket;
  late String _status;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _ticket = widget.ticket;
    _status = _ticket.estado;
  }

  /*void _addComment() {
    setState(() {
      widget.ticket.comentario.add(_commentController.text);
      _commentController.clear();
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text('${_ticket.id}'),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            const Text('Datos del usuario:'),
            Text('ID: ${_ticket.id}'),
            //Text(widget.ticket.name),
            //Text(widget.ticket.numberPhone),
            const SizedBox(height: 20),
            Text('Área de Emergencia: ${_ticket.areaEmergencia}'),
            const SizedBox(height: 20),
            Text('Estado: ${_ticket.estado}'),
            DropdownButton<String>(
              dropdownColor: Colors.white,
              value: _status,
              items: ['pendiente', '{\"estado\":\"en curso\"}', 'Cerrado']
                  .map((status) => DropdownMenuItem<String>(
                value: status,
                child: Text(status),
              ))
                  .toList(),
              onChanged: (value) {
                /*setState(() {
                  _status = value!;
                  widget.ticket.estado = _status;
                });*/
              },
            ),
            const SizedBox(height: 20),
            Text('Fecha: ${DateFormat('dd-MM-yyyy – kk:mm').format(_ticket.fecha)}'),
            const Text('Comentarios:'),
            //...widget.ticket.comentario.map((comment) => Text(comment)).toList(),
            TextField(
              controller: _commentController,
              decoration: const InputDecoration(
                labelText: 'Agregar comentario',
              ),
            ),
            const SizedBox(height: 10),
           /* ElevatedButton(
              onPressed: _addComment,
              child: Text('Agregar'),
            ),*/
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cerrar'),
        ),
      ],
    );
  }
}