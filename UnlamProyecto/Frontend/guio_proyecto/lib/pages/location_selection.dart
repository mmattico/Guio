import 'package:flutter/material.dart';
import 'package:guio_proyecto/other/user_session.dart';
import 'package:guio_proyecto/pages/home_page.dart';
import 'package:guio_proyecto/other/get_graphs.dart';

import 'home_page_accesible.dart';

class LocationSelection extends StatefulWidget {
  @override
  _LocationSelectionState createState() => _LocationSelectionState();
}

class _LocationSelectionState extends State<LocationSelection> {
  int? selectedLocation;
  String searchQuery = '';
  bool isAccesible = true;

  late Future<List<Grafo>> futureGrafos;
  List<Grafo> _grafos = [];

  @override
  void initState() {
    super.initState();
    loadUserAccessibility();
    // Obtener los grafos
    futureGrafos = fetchGrafos();
    futureGrafos.then((grafos) {
      setState(() {
        _grafos = grafos;
      });
    }).catchError((error) {
      print('Error al obtener grafos: $error');
    });
  }

  void loadUserAccessibility() async {
    final bool? userAccessibility = await getUserAccessibility();
    if (userAccessibility != null) {
      setState(() {
        isAccesible = userAccessibility;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filtrar grafos basados en la búsqueda
    List<Grafo> filteredGrafos = _grafos
        .where((grafo) =>
            grafo.nombre.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<List<Grafo>>(
        future: futureGrafos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay grafos disponibles'));
          } else {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 40.0),
                child: Column(
                  children: [
                    const Text(
                      'Elegí tu locación',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Buscar',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade200,
                      ),
                      onChanged: (query) {
                        setState(() {
                          searchQuery = query;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredGrafos.length,
                        itemBuilder: (context, index) {
                          final grafo = filteredGrafos[index];
                          final isSelected = selectedLocation == index;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedLocation = index;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.blue.shade50
                                    : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color.fromRGBO(17, 116, 186, .7)
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    isSelected
                                        ? Icons.check_circle
                                        : Icons.circle_outlined,
                                    color: isSelected
                                        ? const Color.fromRGBO(17, 116, 186, 1)
                                        : Colors.grey,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          grafo.nombre,
                                          // Mostrar el nombre del Grafo
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: isSelected
                                                ? const Color.fromRGBO(
                                                    17, 116, 186, 1)
                                                : Colors.black,
                                          ),
                                          softWrap: true,
                                          overflow: TextOverflow.visible,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          backgroundColor: selectedLocation == null
                              ? const Color.fromRGBO(17, 116, 186, .25)
                              : const Color.fromRGBO(17, 116, 186, 1),
                        ),
                        onPressed: selectedLocation == null
                            ? null
                            : () {
                          // Obtener el nombre del grafo seleccionado
                          final codigoGrafo = _grafos[selectedLocation!].codigo;
                          final nombreGrafo = _grafos[selectedLocation!].nombre;
                          final idGrafo = _grafos[selectedLocation!].grafoID;
                          saveGraphCode(codigoGrafo);
                          saveGraphName(nombreGrafo);
                          saveGraphID(idGrafo);
                          if(isAccesible){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AccesibleHome(),
                              ),
                            );
                          }else{
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomePage(),
                              ),
                            );
                          }

                        },
                        child: const Text(
                          'Continuar',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
