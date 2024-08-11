import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'get_tickets.dart';
import 'home_page_web.dart';

class TicketDetailsDialog extends StatefulWidget {
  final Ticket ticket;


  TicketDetailsDialog({
    required this.ticket,
  });

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
      title: Text('Numero de ticket: ${_ticket.id}'),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            const Text('Datos del usuario:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
            Text('Apellido y nombre: ${_ticket.apellido} ${_ticket.nombre}\nDNI: ${_ticket.dni} \nTelefono: ${_ticket.telefono}'),
            //Text(widget.ticket.name),
            //Text(widget.ticket.numberPhone),
            const SizedBox(height: 20),
            Text('Área de Emergencia:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
            Text('${_ticket.areaEmergencia}', style: TextStyle(fontSize: 22),),
            const SizedBox(height: 20),
            Text('Estado: ${_ticket.estado}'),
            const SizedBox(height: 20),
            Text('Fecha: ${DateFormat('dd-MM-yyyy – kk:mm').format(_ticket.fecha)}\n'),
            const Text('\nComentario:\n'),
            Text('${_ticket.comentario}'),
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