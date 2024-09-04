import 'package:flutter/material.dart';
import 'package:guio_web_admin/get_nodos.dart';

class GridPage extends StatefulWidget {
  @override
  _GridPageState createState() => _GridPageState();
}

class _GridPageState extends State<GridPage> {
  late List<Nodo> _nodos = [];
  late List<Nodo> filteredItems = [];
  TextEditingController searchController = TextEditingController();
  late Future<List<Nodo>> futureNodos;

  @override
  void initState() {
    super.initState();
    futureNodos = fetchNodos();
    futureNodos.then((nodos) {
      setState(() {
        _nodos = nodos;
        filteredItems = _nodos;
      });
    }).catchError((error) {
      print('Error al obtener nodos homepage: $error');
    });

    searchController.addListener(_filterItems);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _filterItems() {
    setState(() {
      filteredItems = _nodos
          .where((nodo) =>
          nodo.nombre.toLowerCase().contains(searchController.text.toLowerCase()))
          .toList();
    });
  }

  String _selectedStatus = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Gestión de Espacios'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(150, 50, 1000, 0),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: 'Buscar por nombre de nodo',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(150, 15, 150, 15),
              child: FutureBuilder<List<Nodo>>(
                future: futureNodos,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No hay datos disponibles'));
                  } else {
                    return GridView.builder(
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 300.0,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        childAspectRatio: 2.0,
                      ),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  _selectedStatus = snapshot.data![index].activo ? 'Habilitado' : 'Deshabilitado';
                                  return AlertDialog(
                                    title: Text('Modificar estado de \n' + snapshot.data![index].nombre, textAlign: TextAlign.center,),
                                    backgroundColor: Colors.white,
                                    content: StatefulBuilder(
                                      builder: (BuildContext context, StateSetter setState) {
                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            const SizedBox(height: 10,),
                                            Text('Estado actual: ' + (_nodos[index].activo ? 'Habilitado' : 'Deshabilitado')),
                                            const SizedBox(height: 10,),
                                            const Text('Nuevo estado:'),
                                            DropdownButton<String>(
                                              value: _selectedStatus,
                                              items: ['Habilitado', 'Deshabilitado']
                                                  .map((status) => DropdownMenuItem<String>(
                                                value: status,
                                                child: Text(status),
                                              ))
                                                  .toList(),
                                              onChanged: (status) {
                                                if (status != null) {
                                                  setState(() {
                                                    _selectedStatus = status;
                                                  });
                                                  _updateStatusNodo(snapshot.data![index].nodoId, status);
                                                }
                                              },
                                              dropdownColor: Colors.white,
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                    actions: [
                                      ElevatedButton(
                                        child: const Text('Continuar'),
                                        onPressed: () {
                                          _showDialog(context, snapshot.data![index].nombre);
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Card(
                              color: Colors.blueAccent,
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'TIPO: ' + _nodos[index].tipo + '\n\n' +
                                          _nodos[index].nombre + '\n' +
                                          'Estado: ' + (_nodos[index].activo ? 'Habilitado' : 'Deshabilitado'),
                                      style: const TextStyle(color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _updateStatusNodo(int nodoId, String newStatus) {

  }

  void _showDialog(BuildContext context, String nodo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('¿Confirma el cambio de estado para \nel área/servicio ' + nodo + '?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confirmar'),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el primer diálogo
                _showConfirmationDialog(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: Icon(Icons.check_circle),
          title: Text('¡Se ha cambiado el estado del nodo!'),
          actions: <Widget>[
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GridPage()),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
