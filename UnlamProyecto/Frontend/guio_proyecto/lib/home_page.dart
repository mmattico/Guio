import 'package:flutter/material.dart';
import '/navigation_confirmation.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomPaint(
            painter: BluePainter(),
            child: Container(
              height: 400,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    header(),
                    const SizedBox(height: 10),
                    headerTexto(),
                    const SizedBox(height: 28),
                    _fromTo(context),
                    const SizedBox(height: 5),
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
                    const SizedBox(height: 20),
                    _services(context),
                    const SizedBox(height: 20),
                    _accesibilidad(context),
                    const SizedBox(height: 30),
                    _button(context),
                    const SizedBox(height: 20),
                    Center(
                      child: _emergencyButton(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
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
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: Colors.green,
                  size: 35,
                ),
                const SizedBox(width: 4),
                Row(
                  children: [
                    _origin(context),
                    if (selectedOrigin.isNotEmpty)
                      Row(
                        children: [
                          Text(
                            selectedOrigin,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
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
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: Colors.blue,
                  size: 35,
                ),
                const SizedBox(width: 4),
                Row(
                  children: [
                    _destino(context),
                    if (selectedArea.isNotEmpty)
                      Row(
                        children: [
                          Text(
                            selectedArea,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                          //SizedBox(width: 8),
                          //Icon(Icons.close, color: Colors.blue, size: 35,),
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
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 5,
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
                    child: Image.asset(seriviceIcons[index]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    serviceTexts[index],
                    style: TextStyle(
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

  //Sección accesibilidad
  _accesibilidad(context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'Accesibilidad',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 5,
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
                    child: Image.asset(accesibilityIcons[index]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    accesibilityTexts[index],
                    style: TextStyle(
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
        width: 250,
        height: 60,
        child: ElevatedButton(
          onPressed: (selectedOrigin.isEmpty ||
              (selectedService.isEmpty && selectedArea.isEmpty) ||
              (selectedOrigin == selectedArea) ||
              selectedPreference.isEmpty)
              ? null
              : () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  content:
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 30),
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
            backgroundColor: Colors.blue[100],
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

//*********** HEADER ***********

class BluePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = const Color.fromRGBO(137, 182, 235, 1)
      ..style = PaintingStyle.fill;

    Path path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height * 0.80)
      ..quadraticBezierTo(size.width * 0.5, size.height, 0, size.height * 0.80)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

Widget header() {
  return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('         '),
        Image(image:
        NetworkImage('https://cdn.logo.com/hotlink-ok/logo-social.png'),
          width: 100,
        ),
        Icon(
          Icons.account_circle,
          color: Colors.white,
          size: 40,
        ),
      ]
  );
}

Widget headerTexto() {
  return const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Bienvenido',
        style: TextStyle(
          color: Colors.white,
          fontSize: 45,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: 5),
      Text(
        'Seleccione su origen y destino para comenzar a navegar',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
}

//*********** BARRA DE BÚSQUEDA -origen y destino- ***********

class CustomSearchDelegate extends SearchDelegate<String> {
  //Definición de áreas
  List<String> searchTerms = [
    "Cardiología",
    "Traumatología",
    "Oftalmología",
    "Clinica Médica",
    "Obstetricia",
    "Cirujía",
    "Internaciones",
    "Dermatología"
  ];

  // Ícono para volver hacia atras, salir de la barra de búsqueda
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, ''); // Devuelve una cadena vacía en lugar de null
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  //Ícono de micrófono, para tomar comandos por voz
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      Padding(padding: const EdgeInsets.fromLTRB(1,1,25,1),
        child:  IconButton(
          onPressed: () {
            //Agregar funcionalidad para que tome voz.
          },
          icon: const Icon(Icons.mic_rounded,
            size: 35,),
        ),
      )

    ];
  }

  //Para la búsqueda por teclado de un área
  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var fruit in searchTerms) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
          onTap: () {
            close(context,
                result
            ); // Devuelve el valor seleccionado y cierra el buscador
          },
        );
      },
    );
  }

  // Para la búsqueda por teclado de un área
  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var fruit in searchTerms) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
          onTap: () {
            close(context,
                result
            ); // Devuelve el valor seleccionado y cierra el buscador
          },
        );
      },
    );
  }
}

//*************** BOTÓN DE EMERGENCIA ***************

Widget _emergencyButton(BuildContext context) {
  return Column(
    children: [
      SizedBox(
        width: 250,
        height: 60,
        child: ElevatedButton(
          onPressed: () {
            _emergencyPopUp(context);
          },
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.red,
          ),
          child: const Text(
            "EMERGENCIA",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
    ],
  );
}

Future<void> _emergencyPopUp(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Column(
          children: <Widget>[
            Icon(
              Icons.info_outline, // Icono grande
              size: 80, // Tamaño del icono
              color: Colors.red,
            ),
            SizedBox(height: 10), // Espacio entre el icono y el título
            Text(
              'ALERTA ENVIADA',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        content: const Text(
          '¡Por favor, quédate en la\n'
          'misma ubicación hasta recibir asistencia!\n',
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          Container(
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text('Emergencia Solucionada'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text('Cancelar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}
