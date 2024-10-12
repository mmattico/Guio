import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guio_proyecto/other/user_session.dart';
import '../other/button_back.dart';
import '../other/navigation_confirmation.dart';
import 'package:flutter/services.dart';
import '../other/search_homepage.dart';
import '../other/header_homepage.dart';
import '../other/emergency_homepage.dart';
import '../other/get_nodos.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedArea = '';
  String selectedService = '';
  String selectedOrigin = '';
  String selectedPreference = '';

  bool areaIsDisabled = false;
  int? selectedIconIndexArea;

  bool serviceIsDisabled = false;
  int? selectedIconIndexService;

  bool preferenceIsDisabled = false;
  int? selectedIconIndexPreference;

  void onIconPressedArea(int index) {
    setState(() {
      if (selectedIconIndexArea == index) {
        areaIsDisabled = !areaIsDisabled;
      } else {
        areaIsDisabled = false;
        selectedIconIndexArea = index;
      }

      if (!areaIsDisabled) {
        selectedIconIndexArea = null;
      }
    });
  }

  void onIconPressedService(int index) {
    setState(() {
      if (selectedIconIndexService == index) {
        selectedService = '';
        selectedIconIndexService = null;
        serviceIsDisabled = false;
      } else {
        selectedIconIndexService = index;
        selectedService = serviceTexts[index];
        serviceIsDisabled = true;
      }
    });
    print('Selected service: $selectedService');
  }

  void onIconPressedAccesibility(int index) {
    setState(() {
      if (selectedIconIndexPreference == index) {
        selectedPreference = '';
        selectedIconIndexPreference = null;
        preferenceIsDisabled = false;
      } else {
        selectedIconIndexPreference = index;
        selectedPreference = accesibilityTexts[index];
        preferenceIsDisabled = true;
      }
    });
    print('Selected preference: $selectedPreference');
  }


  List<String> accesibilityTexts = ['Escaleras', 'Ascensor', 'Indiferente'];

  List<String> accesibilityIcons = [
    "assets/images/escalera.png",
    "assets/images/elevator.png",
    "assets/images/thumbs-up.png"
  ];

  List<String> accesibilityDisabled = [
    "assets/images/escalera-bw.png",
    "assets/images/elevator-bw.png",
    "assets/images/thumbs-up-bw.png"
  ];

  List<String> serviceTexts = ['Baño', 'Snack', 'Ventanilla'];

  List<String> seriviceIcons = [
    "assets/images/toilet.png",
    "assets/images/snack.png",
    "assets/images/receptionist.png"
  ];

  List<String> serviceDisabled = [
    "assets/images/toilet-bw.png",
    "assets/images/snack-bw.png",
    "assets/images/receptionist-bw.png"
  ];

  double _customPaintHeight = 360;

  late Future<List<Nodo>> futureNodos;
  List<Nodo> _nodos = [];

  Future<String?> graphCode = getGraphCode();

  @override
  void initState() {
    super.initState();
    futureNodos = fetchNodosExtremos(graphCode);
    futureNodos.then((nodos) {
      setState(() {
        _nodos = nodos;
      });
    }).catchError((error) {
      print('Error al obtener nodos homepage: $error');
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    return DoubleBackToExit (
      child: Scaffold(
        backgroundColor: Colors.white,
        body: FutureBuilder<List<Nodo>>(
          future: futureNodos,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No hay nodos disponibles'));
            } else {
              return Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: CustomPaint(
                      painter: BluePainter(),
                      child: Container(
                        height: _customPaintHeight,
                      ),
                    ),
                  ),
                  SafeArea(
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (scrollInfo) {
                        setState(() {
                          _customPaintHeight = (360 - scrollInfo.metrics.pixels)
                              .clamp(0.0, 360.0);
                        });
                        return true;
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 25, 16, 12),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 12),
                              HeaderTexto(),
                              const SizedBox(height: 12),
                              _fromTo(context),
                              const SizedBox(height: 4),
                              if ((selectedArea == selectedOrigin) &&
                                  (selectedArea.isNotEmpty || selectedOrigin.isNotEmpty))
                                const Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Text(
                                    'El lugar de origen y destino deben ser diferentes',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 8),
                              _services(context),
                              const SizedBox(height: 4),
                              _accesibilidad(context),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  _button(context),
                                  const SizedBox(width: 10),
                                  emergencyButtonHome(context),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),),
    );
  }

//Tarjetas de origen y destino
  _fromTo(context){
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: Colors.green,
                  size: 35,
                ),
                //const SizedBox(width: 1),
                Row(
                  children: [
                    _origin(context),
                    if (selectedOrigin.isNotEmpty)
                      Row(
                        children: [
                          SizedBox(
                            width: 115.0,
                            child: Text(
                              selectedOrigin,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.blue,
                              size: 25,
                            ),
                            onPressed: () {
                              setState(() {
                                selectedOrigin = '';
                              });
                            },
                          )
                        ],
                      ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 4),
            const Divider(),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: Colors.blue,
                  size: 35,
                ),
                //const SizedBox(width: 4),
                Row(
                  children: [
                    _destino(context),
                    if (selectedArea.isNotEmpty)
                      Row(
                        children: [
                          SizedBox(
                            width: 105.0,
                            child: Text(
                              selectedArea,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.blue,
                              size: 25,
                            ),
                            onPressed: () {
                              setState(() {
                                selectedArea = '';
                              });
                            },
                          )
                        ],
                      )
                  ],
                ),
                const Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //Selección de origen
  _origin(context){
    return TextButton(
      onPressed: () async {
        final resultOrigin =
        await showSearch<String>(
          context: context,
          delegate: CustomSearchDelegate(nodos: _nodos),
        );
        if (resultOrigin != null && resultOrigin.isNotEmpty) {
          setState(() {
            selectedOrigin = resultOrigin;
          });
        }
      },
      child: const Text(
        'Origen',
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
        ),
      ),
    );
  }

  //Selección de destino
  _destino(context){
    return TextButton(
      onPressed: () async {
        final result = await showSearch<String>(
          context: context,
          delegate: CustomSearchDelegate(nodos: _nodos),
        );
        if (result != null &&
            result.isNotEmpty) {
          setState(() {
            selectedArea = result;
          });
        }
      },
      child: const Text(
        'Destino',
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
        ),
      ),
    );
  }

  _services(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          ' Servicios',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 1,
          mainAxisSpacing: 4,
          childAspectRatio: 1 / 1.0,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: List.generate(serviceTexts.length, (index) {
            return InkWell(
              onTap: () => onIconPressedService(index),
              child: Column(
                children: [
                  SizedBox(
                    height: 80,
                    width: 80,
                    child: selectedIconIndexService == null || selectedIconIndexService == index
                        ? Image.asset(seriviceIcons[index]) // Mostrar ícono en color si no hay selección o si está seleccionado
                        : Image.asset(serviceDisabled[index]), // Mostrar ícono grisado si no está seleccionado
                  ),
                  const SizedBox(height: 2),
                  Text(
                    serviceTexts[index],
                    style: TextStyle(
                      fontSize: 16,
                      color: selectedIconIndexService == null || selectedIconIndexService == index
                          ? Colors.black // Mostrar texto en negro si no hay selección o si está seleccionado
                          : Colors.grey, // Texto gris si el ícono no está seleccionado
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }



  _accesibilidad(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          ' Preferencias',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 5,
          childAspectRatio: 1 / 1.1,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: List.generate(accesibilityTexts.length, (index) {
            return InkWell(
              onTap: () => onIconPressedAccesibility(index),
              child: Column(
                children: [
                  SizedBox(
                    height: 80,
                    width: 80,
                    child: selectedIconIndexPreference == null || selectedIconIndexPreference == index
                        ? Image.asset(accesibilityIcons[index]) // Mostrar ícono en color si no hay selección o si está seleccionado
                        : Image.asset(accesibilityDisabled[index]), // Mostrar ícono grisado si no está seleccionado
                  ),
                  const SizedBox(height: 3),
                  Text(
                    accesibilityTexts[index],
                    style: TextStyle(
                      fontSize: 18,
                      color: selectedIconIndexPreference == null || selectedIconIndexPreference == index
                          ? Colors.black // Mostrar texto en negro si no hay selección o si está seleccionado
                          : Colors.grey, // Texto gris si el ícono no está seleccionado
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }



  //Botón IR
  _button(context){
    return Center(
      child: SizedBox(
        width: 230,
        height: 60,
        child: ElevatedButton(
          onPressed: (selectedOrigin.isEmpty ||
              (selectedService.isEmpty && selectedArea.isEmpty) ||
              (selectedOrigin == selectedArea) ||
              selectedPreference.isEmpty)
              ? null
              : () {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  content:
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //const SizedBox(height: 25),
                      const Icon(Icons.check_circle, color: Colors.green, size: 100,),
                      //const SizedBox(height: 3),
                      NavigationConfirmation(
                        selectedOrigin: selectedOrigin,
                        selectedArea: selectedArea,
                        selectedService: selectedService,
                        selectedPreference: selectedPreference,
                      ),
                    ],
                  ),
                );
              },
            );
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Color.fromRGBO(17, 116, 186, 1),
          ),
          child: const Text(
            "IR",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
