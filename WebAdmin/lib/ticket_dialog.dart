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
      title: Text('${_ticket.id}'),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            Text('Datos del usuario:'),
            Text('ID: ${_ticket.id}'),
            //Text(widget.ticket.name),
            //Text(widget.ticket.numberPhone),
            SizedBox(height: 20),
            Text('Área de Emergencia: ${_ticket.areaEmergencia}'),
            SizedBox(height: 20),
            Text('Estado: ${_ticket.estado}'),
            DropdownButton<String>(
              value: _status,
              items: ['pendiente', 'En curso', 'Cerrado']
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
            SizedBox(height: 20),
            Text('Fecha: ${DateFormat('dd-MM-yyyy – kk:mm').format(_ticket.fecha)}'),
            Text('Comentarios:'),
            //...widget.ticket.comentario.map((comment) => Text(comment)).toList(),
            TextField(
              controller: _commentController,
              decoration: InputDecoration(
                labelText: 'Agregar comentario',
              ),
            ),
            SizedBox(height: 10),
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
          child: Text('Cerrar'),
        ),
      ],
    );
  }
}