import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'get_tickets.dart';

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
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Buscar por ID...',
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
              rows: _filteredTickets.map((ticket) => DataRow(
                cells: [
                  DataCell(
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => widget.onOpenTicketDetails(ticket),
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
