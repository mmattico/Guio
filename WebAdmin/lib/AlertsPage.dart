import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'get_tickets.dart';
import 'package:http/http.dart' as http;
import "string_extension.dart";

class Alerts extends StatefulWidget {
  List<Ticket> tickets;
  final void Function(Ticket) onOpenTicketDetails;
  final void Function(Ticket, String) onStatusChanged;
  int cantidadAlertas = 0;

  Alerts(
      {required this.tickets,
      required this.onOpenTicketDetails,
      required this.onStatusChanged,
      required this.cantidadAlertas});

  @override
  _AlertsState createState() => _AlertsState();
}

class _AlertsState extends State<Alerts> {
  late List<Ticket> _filteredTickets;
  late TextEditingController _searchController;
  late int cantidadAlertasPrev = 0;
  late int cantidadAlertasNuevas = 0;
  bool isLoading = false;

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
  int qtyAlertasNuevas = 0;

  Future<void> _refreshAlertas() async {
    setState(() {
      isLoading = true;
    });

    try {
      List<Ticket> nuevasAlertas = await fetchAlertas('PRUEBA');
      setState(() {
        oldTickets = _filteredTickets;
        cantidadAlertasNuevas = nuevasAlertas.length;
        setState(() {
          _filteredTickets = nuevasAlertas;
          cantidadAlertasPrev = oldTickets.length;
          qtyAlertasNuevas = cantidadAlertasNuevas - cantidadAlertasPrev;
          isLoading = false;
        });
      });
    } catch (e) {
      print('Error al actualizar alertas: $e');
    }
  }

  void _filterStatusOpen() {
    _clearFilters();
    setState(() {
      _filteredTickets = _filteredTickets
          .where((ticket) => ticket.estado == 'pendiente')
          .toList();
    });
  }

  void _filterStatusEnCurso() {
    _clearFilters();
    setState(() {
      _filteredTickets = _filteredTickets
          .where((ticket) => ticket.estado == 'en curso')
          .toList();
    });
  }

  void _filterStatusFinalizada() {
    _clearFilters();
    setState(() {
      _filteredTickets = _filteredTickets
          .where((ticket) => ticket.estado == 'finalizada')
          .toList();
    });
  }

  void _filterStatusCancelada() {
    _clearFilters();
    setState(() {
      _filteredTickets = _filteredTickets
          .where((ticket) => ticket.estado == 'cancelada')
          .toList();
    });
  }

  void _clearFilters() {
    setState(() {
      _filteredTickets = widget.tickets;
      _searchController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    int enCurso = widget.tickets.where((alerta) => alerta.estado == 'en curso').length;
    int pendientes = widget.tickets.where((alerta) => alerta.estado == 'pendiente').length;
    int canceladas = widget.tickets.where((alerta) => alerta.estado == 'cancelada').length;
    int finalizadas = widget.tickets.where((alerta) => alerta.estado == 'finalizada').length;
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  _filterStatusOpen();
                },
                child:
                SizedBox(
                  height: 100,
                  width: 180,
                  child:
                Card(
                  color: Color.lerp(Color.fromRGBO(17, 116, 186, 1), Colors.white, 0.75)!,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(6, 10, 6, 6),
                    child: Column(
                      children: [
                        Text("Pendientes", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        Text("$pendientes", style: TextStyle(fontSize: 24)),
                      ],
                    ),),
                  ),
                ),
              ),
              SizedBox(
                width: 12,
              ),
              InkWell(
                onTap: () {
                  _filterStatusEnCurso();
                },
                child:
                SizedBox(
                  height: 100,
                  width: 180,
                  child:
                  Card(
                    color: Color.lerp(Color.fromRGBO(17, 116, 186, 1), Colors.white, 0.75)!,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(6, 10, 6, 6),
                      child: Column(
                        children: [
                          Text("En curso", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          Text("$enCurso", style: TextStyle(fontSize: 24)),
                        ],
                      ),
                    ),),
                  ),
              ),
              SizedBox(
                width: 12,
              ),
              InkWell(
                onTap: () {
                  _filterStatusFinalizada();
                },
                child:
                SizedBox(
                height: 100,
                width: 180,
                child:
                Card(
                  color: Color.lerp(Color.fromRGBO(17, 116, 186, 1), Colors.white, 0.75)!,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(6, 10, 6, 6),
                    child: Column(
                      children: [
                        Text("Finalizadas", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        Text("$finalizadas", style: TextStyle(fontSize: 24)),
                      ],
                    ),
                  ),
                ),),
              ),
              SizedBox(
                width: 12,
              ),
              InkWell(
                onTap: () {
                  _filterStatusCancelada();
                },
                child:
                    SizedBox(
                      height: 100,
                      width: 180,
                      child: Card(
                        color: Color.lerp(Color.fromRGBO(17, 116, 186, 1), Colors.white, 0.75)!,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(6, 10, 6, 6),
                          child: Column(
                            children: [
                              Text("Canceladas", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              SizedBox(height: 10),
                              Text("$canceladas", style: TextStyle(fontSize: 24)),
                            ],
                          ),
                        ),
                      ),
                    ),
              ),
              SizedBox(width: 12),
            ],
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
            onPressed: _clearFilters,
            child: Text(
              'Eliminar Filtros',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const SizedBox(
                width: 250,
              ),
              Flexible(
                child: SizedBox(
                  width: 300,
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Buscar por número de Ticket...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 430,
              ),
              //boton de refresh
              IconButton(
                icon: const Icon(Icons.refresh),
                iconSize: 45.0,
                color: const Color.fromRGBO(17, 116, 186, 1),
                tooltip: 'Actualizar listado de alertas',
                onPressed: () async {
                  await _refreshAlertas();
                },
              ),
              const SizedBox(
                width: 10.0,
              ),
              Container(
                  child: qtyAlertasNuevas > 0
                      ? Row(
                    children: [
                      const Icon(
                        Icons.notification_add,
                        color: Colors.red,
                        size: 25,
                      ),
                      Text('Hay alertas nuevas: $qtyAlertasNuevas',
                          style: const TextStyle(
                              color: Colors.red, fontSize: 16))
                    ],
                  )
                      : const Row(
                    children: [
                      Icon(
                        Icons.check,
                        color: Colors.green,
                        size: 25,
                      ),
                      Text(
                        'No hay alertas nuevas',
                        style:
                        TextStyle(color: Colors.green, fontSize: 16),
                      ),
                    ],
                  )),
              const SizedBox(width: 30),
            ],
          ),
          SizedBox(
            height: 28,
          ),
          isLoading
              ? Center(
                  child:
                      CircularProgressIndicator(), // Mostrar la ruedita cuando esté cargando
                )
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('N° Alerta')),
                      DataColumn(label: Text('Fecha')),
                      DataColumn(label: Text('Hora')),
                      DataColumn(label: Text('Apellido y Nombre')),
                      DataColumn(label: Text('Ubicacion')),
                      DataColumn(label: Text('Estado')),
                      DataColumn(label: Text('Comentarios')),
                    ],
                    rows: _filteredTickets
                        .map((ticket) => DataRow(
                              cells: [
                                DataCell(
                                  MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                      onTap: () =>
                                          widget.onOpenTicketDetails(ticket),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 28.0, vertical: 4.0),
                                        decoration: BoxDecoration(
                                          color: Color(0xFF1174ba),
                                          border: Border.all(
                                              color: Color(0xFF1174ba),
                                              width: 1.0),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        child: Text(
                                          ticket.id.toString().padLeft(3, '0'),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(Text(
                                    '${DateFormat('dd-MM-yyyy').format(ticket.fecha)}')),
                                DataCell(Text(
                                    '${DateFormat('kk:mm').format(ticket.fecha)}')),
                                DataCell(Text(ticket.areaEmergencia)),
                                DataCell(Text(ticket.apellido.capitalize() +
                                    ' ' +
                                    ticket.nombre.capitalize())),
                                DataCell(
                                  DropdownButton<String>(
                                    value: ticket.estado,
                                    items: [
                                      'pendiente',
                                      'en curso',
                                      'finalizada',
                                      'cancelada'
                                    ]
                                        .map((status) =>
                                            DropdownMenuItem<String>(
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
                            ))
                        .toList(),
                  ),
                ),
        ],
      ),
    );
  }
}

Future<void> updateTicketStatus(int ticketId, String newStatus) async {
  final url = Uri.https('guio-hgazcxb0cwgjhkev.eastus-01.azurewebsites.net',
      '/api/alerta/$ticketId/estado');

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
