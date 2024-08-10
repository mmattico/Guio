import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../other/navigation_confirmation.dart';
import 'package:flutter/services.dart';
import '../other/search_homepage.dart';
import '/other/header_homepage.dart';
import '../other/emergency_homepage.dart';

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
        areaIsDisabled = true;
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
        serviceIsDisabled = !serviceIsDisabled;
        if (selectedService.isEmpty) {
          selectedService = serviceTexts[index];
        } else {
          selectedService = '';
        }
      } else {
        serviceIsDisabled = true;
        selectedIconIndexService = index;
        selectedService = serviceTexts[index];
      }

      if (!serviceIsDisabled) {
        selectedIconIndexService = null;
      }
    });
    print('Selected service: $selectedService');
  }

  void onIconPressedAccesibility(int index) {
    setState(() {
      if (selectedIconIndexPreference == index) {
        preferenceIsDisabled = !preferenceIsDisabled;
        if (selectedPreference.isEmpty) {
          selectedPreference = accesibilityTexts[index];
        } else {
          selectedPreference = '';
        }
      } else {
        preferenceIsDisabled = true;
        selectedIconIndexPreference = index;
        selectedPreference = accesibilityTexts[index];
      }

      if (!preferenceIsDisabled) {
        selectedIconIndexPreference = null;
      }
    });
    print('Selected service: $selectedPreference');
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

  List<String> areaTexts = [
    'Cardiología',
    'Neurología',
    'Dermatología',
    'Pediatría',
    'Clinica Medica',
    'Ginecología'
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

  double _customPaintHeight = 380;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
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
                  _customPaintHeight = (380 - scrollInfo.metrics.pixels).clamp(0.0, 380.0);
                });
                return true;
              },
              child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 25, 16, 12),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    header(context),
                    const SizedBox(height: 10),
                    headerTexto(),
                    const SizedBox(height: 20),
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
                    const SizedBox(height: 15),
                    _services(context),
                    const SizedBox(height: 18),
                    _accesibilidad(context),
                    const SizedBox(height: 25),
                    Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                        _button(context),
                        const SizedBox(width: 10,),
                        emergencyButtonHome(context),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),),
        ],
      ),
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
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
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
            const SizedBox(height: 6),
            const Divider(),
            const SizedBox(height: 6),
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
          delegate: CustomSearchDelegate(),
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
          delegate: CustomSearchDelegate(),
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

  //Sección Servicios
  _services(context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'Servicios',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        GridView.count(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 4,
            childAspectRatio: 1/1.1,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: List.generate(serviceTexts.length, (index) {
              return InkWell(
                onTap: serviceIsDisabled && selectedIconIndexService != index
                    ? null
                    : () => onIconPressedService(index),
                child: Column(
                  children: [
                    SizedBox(
                      height: 80,
                      width: 80,
                      child: serviceIsDisabled && selectedIconIndexService != index
                          ? Image.asset(serviceDisabled[index])
                          : Image.asset(seriviceIcons[index]),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      serviceTexts[index],
                      style: TextStyle(
                        fontSize: 16,
                        color: serviceIsDisabled && selectedIconIndexService != index
                            ? Colors.grey
                            : Colors.black,
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

  //Sección preferencias
  _accesibilidad(context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'Preferencias',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 5,
          childAspectRatio: 1/1.1,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children:
          List.generate(accesibilityTexts.length, (index) {
            return InkWell(
              onTap: preferenceIsDisabled && selectedIconIndexPreference != index
                  ? null
                  : () => onIconPressedAccesibility(index),
              child: Column(
                children: [
                  SizedBox(
                    height: 80,
                    width: 80,
                    child: preferenceIsDisabled && selectedIconIndexPreference != index
                        ? Image.asset(accesibilityDisabled[index])
                        : Image.asset(accesibilityIcons[index]),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    accesibilityTexts[index],
                    style: TextStyle(
                      fontSize: 18,
                      color: preferenceIsDisabled && selectedIconIndexPreference != index
                          ? Colors.grey
                          : Colors.black,
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
        width: 200,
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
            shape: const StadiumBorder(),
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