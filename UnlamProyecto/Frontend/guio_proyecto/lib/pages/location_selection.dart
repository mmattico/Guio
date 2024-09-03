import 'package:flutter/material.dart';
import 'package:guio_proyecto/other/user_session.dart';
import 'package:guio_proyecto/pages/home_page.dart';

class LocationSelection extends StatefulWidget {
  @override
  _LocationSelectionState createState() => _LocationSelectionState();
}

class _LocationSelectionState extends State<LocationSelection> {
  int? selectedLocation;
  String searchQuery = '';

  final List<Map<String, dynamic>> locations = [
    {'location': 'Universidad Nacional de la Matanza (UNLaM)'},
    {'location': 'Hospital Italiano'},
    {'location': 'Universidad de Morón (UM)'},
    {'location': 'Hospital Posadas'},
    {'location': 'Universidad de San Martín (UNSAM)'}
  ];

  @override
  void initState() {
    super.initState();
    // Ordenar los niveles alfabéticamente por nombre al inicio
    locations.sort((a, b) => a['location'].compareTo(b['location']));
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredLevels = locations
        .where((level) => level['location']
        .toLowerCase()
        .contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child:
        Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40.0),
        child: Column(
          children: [
            Text(
              'Elegí tu locación',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 24),
            TextField(
              decoration: InputDecoration(
                hintText: 'Buscar',
                prefixIcon: Icon(Icons.search),
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
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: filteredLevels.length,
                itemBuilder: (context, index) {
                  final level = filteredLevels[index];
                  final isSelected = selectedLocation == index;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedLocation = index;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue.shade50 : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? Color.fromRGBO(17, 116, 186, .7) : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isSelected ? Icons.check_circle : Icons.circle_outlined,
                            color: isSelected ? Color.fromRGBO(17, 116, 186, 1) : Colors.grey,
                            size: 24,
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  level['location'],
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected ? Color.fromRGBO(17, 116, 186, 1) : Colors.black,
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
            SizedBox(height: 16),
            Container(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  backgroundColor: selectedLocation == null
                      ? const Color.fromRGBO(17, 116, 186, .25) // Cambia el color del botón cuando está deshabilitado
                      : const Color.fromRGBO(17, 116, 186, 1),
                ),
                onPressed: selectedLocation == null
                    ? null
                    : () {
                  // Acción al presionar "continuar"
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()),);
                  //Navigator.push(context, MaterialPageRoute(builder: (context) => AccesibleHome()),);
                    },
                child: Text(
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
    ),);
  }
}
