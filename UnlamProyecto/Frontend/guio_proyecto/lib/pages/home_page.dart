import 'package:flutter/material.dart';
import '../other/navigation_confirmation.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../other/emergency.dart';
import 'package:flutter/services.dart';
import '../other/search_homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'start_page.dart';

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
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    header(context),
                    const SizedBox(height: 8),
                    headerTexto(),
                    const SizedBox(height: 18),
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
                    const SizedBox(height: 10),
                    _services(context),
                    const SizedBox(height: 10),
                    _accesibilidad(context),
                    const SizedBox(height: 20),
                    Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                        _button(context),
                        const SizedBox(width: 10,),
                        emergencyButton(context),
                      ],
                    )
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
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
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
                    child: serviceIsDisabled && selectedIconIndexService != index
                        ? Image.asset(serviceDisabled[index])
                        : Image.asset(seriviceIcons[index]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    serviceTexts[index],
                    style: TextStyle(
                      fontSize: 18,
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
            fontSize: 22,
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
                    child: preferenceIsDisabled && selectedIconIndexPreference != index
                        ? Image.asset(accesibilityDisabled[index])
                        : Image.asset(accesibilityIcons[index]),
                  ),
                  const SizedBox(height: 4),
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

/*Widget header() {
  return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('         '),
        Image(image:
          AssetImage("assets/images/logo_GUIO.png"),
          width: 100,
        ),
        Icon(
          Icons.account_circle,
          color: Colors.white,
          size: 40,
        ),
      ]
  );
}*/

Widget header(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      const Text('         '),
      const Image(
        image: AssetImage("assets/images/logo_GUIO.png"),
        width: 100,
      ),
      PopupMenuButton<String>(
        icon: const Icon(
          Icons.account_circle,
          color: Colors.white,
          size: 40,
        ),
        onSelected: (String value) {
          if (value == '1') {
            // Navegar a la página de "Mi cuenta"
          } else if (value == '2') {
            // Manejar el cierre de sesión
            _logout(context);
          }
        },
        itemBuilder: (BuildContext context) => [
          const PopupMenuItem<String>(
            value: '1',
            child: Text('Mi cuenta'),
          ),
          const PopupMenuItem<String>(
            value: '2',
            child: Text('Cerrar Sesión'),
          ),
        ],
      ),
    ],
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
      Text(
        'Seleccione origen y destino para comenzar',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          //fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
}

Future<void> _logout(BuildContext context) async {
  // Eliminar datos de sesión del usuario
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('isLoggedIn');

  // Navegar a la pantalla de inicio de sesión
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (context) => StartPage()),
  );
}
