import 'package:flutter/material.dart';
import 'package:guio_web_admin/get_nodos.dart';
import 'package:guio_web_admin/other/user_session.dart';
import 'package:http/http.dart' as http;

class GridPage extends StatefulWidget {
  @override
  _GridPageState createState() => _GridPageState();
}

class _GridPageState extends State<GridPage> {
  late List<Nodo> _nodos = [];
  late List<Nodo> filteredItems = [];
  TextEditingController searchController = TextEditingController();
  late Future<List<Nodo>> futureNodos;
  bool isLoading = false;
  String _selectedStatus = '';

  Future<String?> graphCode = getGraphCode();

  @override
  void initState() {
    super.initState();
    futureNodos = fetchNodos(graphCode);
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
      filteredItems =
          _nodos.where((nodo) =>
          nodo.nombre.toLowerCase().contains(searchController.text.toLowerCase()))
          .toList();
    });
  }

  void _filterAreas() {
    _clearFilters();
    setState(() {
      filteredItems =
          filteredItems.where((nodo) =>
                nodo.tipo == 'extremo')
              .toList();
    });
  }

  void _filterPreferencias() {
    _clearFilters();
    setState(() {
      filteredItems =
          filteredItems.where((nodo) =>
          nodo.tipo == 'Escaleras' || nodo.tipo == 'Ascensor')
              .toList();
    });
  }

  void _filterBanio() {
    _clearFilters();
    setState(() {
      filteredItems =
          filteredItems.where((nodo) =>
          nodo.tipo == 'Baño')
              .toList();
    });
  }

  void _filterSnack() {
    _clearFilters();
    setState(() {
      filteredItems =
          filteredItems.where((nodo) =>
          nodo.tipo == 'Snack')
              .toList();
    });
  }

  void _clearFilters() {
    setState(() {
      filteredItems = _nodos;
      searchController.text = ''; // Limpiar la consulta de búsqueda
    });
  }

  Future<void> _refreshAreas() async {
    setState(() {
      isLoading = true;
    });

    try {
      List<Nodo> nuevasAlertas = await fetchNodos(graphCode);
      setState(() {
        setState(() {
          _nodos = nuevasAlertas;
          filteredItems = nuevasAlertas;
          isLoading = false;
        });

      });
    } catch (e) {
      print('Error al actualizar alertas: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0), // Altura total incluyendo el espacio
        child: Column(
        children: [
        SizedBox(height: 20.0),
        AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF1174ba),
          title: const Text('Gestión de Espacios',
                style: TextStyle(fontFamily: 'Oswald', fontSize: 50, fontWeight: FontWeight.bold),),
        ),
        ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.fromLTRB(500, 25, 500, 0),
            child:
            TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: 'Buscar por nombre de nodo',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          SizedBox(height: 28,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Filtrar por: '),
              SizedBox(width: 12,),
              ElevatedButton(
                onPressed: _filterAreas,
                child: Text('Áreas', style: TextStyle(color: Colors.black),),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color.lerp(Color.fromRGBO(17, 116, 186, 1), Colors.white, 0.75)),
                ),
              ),
              SizedBox(width: 12,),
              ElevatedButton(
                onPressed: _filterPreferencias,
                child: Text('Escaleras / Ascensores', style: TextStyle(color: Colors.black),),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color.lerp(Color.fromRGBO(17, 116, 186, 1), Colors.white, 0.75)),
                ),
              ),
              SizedBox(width: 12,),
              ElevatedButton(
                onPressed: _filterBanio,
                child: Text('Baños', style: TextStyle(color: Colors.black),),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color.lerp(Color.fromRGBO(17, 116, 186, 1), Colors.white, 0.75)),
                ),
              ),
              SizedBox(width: 12,),
              ElevatedButton(
                onPressed: _filterSnack,
                child: Text('Snacks', style: TextStyle(color: Colors.black),),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color.lerp(Color.fromRGBO(17, 116, 186, 1), Colors.white, 0.75)),
                ),
              ),
              SizedBox(width: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                onPressed: _clearFilters,
                child: Text('Eliminar Filtros',
                  style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
          Expanded(
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(), // Mostrar la ruedita cuando esté cargando
                  )
                : Padding(
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
                      //itemCount: snapshot.data!.length,
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  _selectedStatus = filteredItems[index].activo ? 'Habilitado' : 'Deshabilitado';
                                  return AlertDialog(
                                    backgroundColor: Colors.white,
                                    content: StatefulBuilder(
                                      builder: (BuildContext context, StateSetter setState) {
                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Icon(Icons.edit, size: 90, color: Colors.black,),
                                            const SizedBox(height: 10,),
                                            RichText(
                                              textAlign: TextAlign.center,
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: 'Modificar el estado de \n',
                                                    style: TextStyle(fontSize: 26, color: Colors.black), // Estilo para la primera parte
                                                  ),
                                                  TextSpan(
                                                    text: filteredItems[index].nombre.toUpperCase(), // Convertir a mayúsculas
                                                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black), // Negrita para el nombre en mayúsculas
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 10,),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text('Estado actual: ',
                                                  style: TextStyle(fontSize: 18,
                                                  ),),
                                                Text((filteredItems[index].activo ? 'HABILITADO' : 'DESHABILITADO'),
                                                  style: TextStyle(fontSize: 18,
                                                      color: (filteredItems[index].activo ? Colors.green : Colors.red),
                                                      fontWeight: FontWeight.bold
                                                  ),),
                                              ],
                                            ),
                                            const SizedBox(height: 30,),
                                              SizedBox(
                                              width: double.infinity,
                                              height: 55,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(18),
                                                  ),
                                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                                  backgroundColor: Color.fromRGBO(17, 116, 186, 1),
                                                ),
                                                child: Text((filteredItems[index].activo ? 'DESHABILITAR' : 'HABILITAR'),
                                                  style: TextStyle(fontSize: 22, color: Colors.white),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  _showDialog(context, filteredItems[index].nombre, filteredItems[index].activo, _selectedStatus);
                                                },
                                              ),
                                            ),
                                            const SizedBox(height: 10,),
                                            TextButton(
                                              child: const Text(
                                                "Cancelar",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Color.fromRGBO(17, 116, 186, 1),
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                            child: Card(
                              color: (filteredItems[index].activo ? Colors.green : Colors.grey),
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      (filteredItems[index].tipo == 'extremo' ? 'Area' : filteredItems[index].tipo) + '\n\n' +
                                          filteredItems[index].nombre + '\n' +
                                          'Estado: ' + (filteredItems[index].activo ? 'Habilitado' : 'Deshabilitado'),
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

  Future<void> _updateStatusNodo(String nodoNombre, String newStatus) async {
    final url;
    final graphCode = await getGraphCode();
    if (graphCode == null) {
      throw Exception('Graph code no proporcionado.');
    }

    if(newStatus == "Deshabilitado"){
      url = Uri.https('guio-hgazcxb0cwgjhkev.eastus-01.azurewebsites.net', '/api/nodos/activar/$nodoNombre/$graphCode');
    } else {
      url = Uri.https('guio-hgazcxb0cwgjhkev.eastus-01.azurewebsites.net', '/api/nodos/desactivar/$nodoNombre/$graphCode');
    };

    print('nuevo estado: ' + newStatus);
    print('nombre nodo: ' + nodoNombre);
    print('*******************************************************');

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print('Estado actualizado con éxito');
      print('*******************************************************');
    } else {
      print('Error al actualizar el ticket: ${response.statusCode}');
      print('Respuesta: ${response.body}');
      print('*******************************************************');
    }
  }

  void _showDialog(BuildContext context, String nodoNombre, bool estado, String newStatus) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min, // Para ajustar el tamaño del contenido a sus hijos
            children: [
              Icon(
                Icons.question_mark, // Puedes cambiar el ícono según tus necesidades
                color: Colors.black,
                size: 95,
              ),
              SizedBox(height: 16), // Espacio entre el ícono y el texto
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '¿Confirma que desea\n',
                      style: TextStyle(fontSize: 20, color: Colors.black,),
                    ),
                    TextSpan(
                      text: (estado ? 'DESHABILITAR' : 'HABILITAR'),
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: estado ? Colors.red : Colors.green),
                    ),
                    TextSpan(
                      text: '\nel área/servicio\n',
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                    TextSpan(
                      text: nodoNombre.toUpperCase(),
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    TextSpan(
                      text: '?', //
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30,),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    backgroundColor: Color.fromRGBO(17, 116, 186, 1),
                  ),
                  child: Text('CONFIRMAR',
                    style: TextStyle(fontSize: 22, color: Colors.white),
                  ),
                  onPressed: () {
                    print("#######################");
                    print(newStatus);
                    _updateStatusNodo(nodoNombre, newStatus);
                    Navigator.of(context).pop(); // Cierra el primer diálogo
                    _showConfirmationDialog(context, newStatus, nodoNombre);
                  },
                ),
              ),
              const SizedBox(height: 10,),
              TextButton(
                child: const Text(
                  "Cancelar",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromRGBO(17, 116, 186, 1),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showConfirmationDialog(BuildContext context, String newStatus, String nombreNodo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          icon: Icon(Icons.check_circle, color: Colors.green, size: 100),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '¡Se ha ',
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                    TextSpan(
                      text: (newStatus == "Habilitado" ? "DESHABILITADO" : "HABILITADO"),
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: newStatus == "Habilitado" ? Colors.red : Colors.green,
                      ),
                    ),
                    TextSpan(
                      text: '\nel área/servicio\n',
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                    TextSpan(
                      text: nombreNodo.toUpperCase(),
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    TextSpan(
                      text: '!',
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 45),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    backgroundColor: Color.fromRGBO(17, 116, 186, 1),
                  ),
                  child: Text(
                    'ACEPTAR',
                    style: TextStyle(fontSize: 22, color: Colors.white),
                  ),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await _refreshAreas();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

}
