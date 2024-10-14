import 'package:flutter/material.dart';
import 'package:guio_proyecto/pages/start_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'dart:async';
import '../other/text_to_voice.dart';
import '../other/navigation_confirmation.dart';
import '../other/user_session.dart';
import '../other/get_nodos.dart';
import '../other/emergency_homepageaccesible.dart';
import '../other/header_homepageaccesible.dart';
import 'change_password.dart';
import 'location_selection.dart';
import 'my_data.dart';

class AccesibleHome extends StatefulWidget {
  @override
  _AccesibleHome createState() => _AccesibleHome();
}

class _AccesibleHome extends State<AccesibleHome> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _origen = '';
  String _destino = '';
  String _servicio = '';
  String _preferencia = '';
  String _emergencia = '';
  Timer? _timer;
  bool _isButtonEnabled = false;

  late Future<List<Nodo>> futureNodos;
  List<Nodo> _nodos = [];

  Future<String?> graphCode = getGraphCode();

  List<String> areasPermitidas = ['Cardiología', 'Dermatología', 'Ginecología'];
  final List<String> preferenciasPermitidas = [
    'Escaleras',
    'Ascensor',
    'Indiferente'
  ];
  final List<String> serviciosPermitidos = ['Baño', 'Snack', 'Ventanilla'];

  int _selectedTextFieldIndex = 0;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    futureNodos = fetchNodosExtremos(graphCode);
    futureNodos.then((nodos) {
      setState(() {
        _nodos = nodos;
        areasPermitidas = getNodosActivos(_nodos);
      });
    }).catchError((error) {
      print('Error al obtener nodos homepage: $error');
    });
    speak(
        "Bienvenido, Los datos a ingresar serán únicamente por voz, por favor complete los campos que encontrara en el medio de la pantalla para poder ayudarlo, luego presione aceptar, posee la opción por botón de enviar una alerta si lo necesita");
  }

  @override
  void dispose() {
    _timer?.cancel();
    _speech.stop();
    super.dispose();
  }

  List<String> getNodosActivos(List<Nodo> nodos) {
    return nodos
        .where((nodo) => nodo.activo)
        .map((nodo) => nodo.nombre)
        .toList();
  }

  Future<void> _listen(int textFieldIndex, String label) async {
    speak("Seleccionó  $label");
    _selectedTextFieldIndex = textFieldIndex;

    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) {
          if (status == 'notListening') {
            _stopListening();
            Future.delayed(Duration(milliseconds: 500), () {
              _validarExistenciaSegunCampo(_selectedTextFieldIndex);
            });
          }
        },
        onError: (error) => print('onError: $error'),
      );

      await Future.delayed(Duration(milliseconds: 1800), () {});

      if (available) {
        setState(() {
          _isListening = true;
        });
        detenerReproduccion();
        _speech.listen(
            onResult: (result) {
              setState(() {
                switch (_selectedTextFieldIndex) {
                  case 1:
                    _origen = colocarMayusculas(result.recognizedWords);
                    break;
                  case 2:
                    _destino = colocarMayusculas(result.recognizedWords);
                    break;
                  case 3:
                    _servicio = colocarMayusculas(result.recognizedWords);
                    break;
                  case 4:
                    _preferencia = colocarMayusculas(result.recognizedWords);
                    break;
                  case 5:
                    _emergencia = colocarMayusculas(result.recognizedWords);
                    break;
                }
                _updateButtonState();
              });
            },
            listenFor: const Duration(seconds: 4));
      }
    } else {
      _stopListening();
    }
  }

  void _stopListening() {
    setState(() {
      _isListening = false;
    });
    _speech.stop();
  }

  String colocarMayusculas(String text) {
    if (text.isEmpty) return text;
    return text.split(' ').map((word) {
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  void _validarExistenciaSegunCampo(int textFieldIndex) {
    switch (textFieldIndex) {
      case 1:
        _validarExistencia(_origen, 'ORIGEN', areasPermitidas, 1);
        break;
      case 2:
        _validarExistencia(_destino, 'DESTINO', areasPermitidas, 2);
        break;
      case 3:
        _validarExistencia(_servicio, 'SERVICIO', serviciosPermitidos, 3);
        break;
      case 4:
        _validarExistencia(
            _preferencia, 'PREFERENCIA', preferenciasPermitidas, 4);
        break;
      case 5:
        _validarExistencia(_emergencia, 'EMERGENCIA', areasPermitidas, 5);
        break;
    }
  }

  void _validarExistencia(String escucha, String campo,
      List<String> listaChequeo, int textFieldIndex) {
    if (!listaChequeo.contains(escucha)) {
      speak(
          "Disculpe, no he entendido. Las opciones válidas son: ${listaChequeo.join(', ')}");
      setState(() {
        switch (textFieldIndex) {
          case 1:
            _origen = '';
            break;
          case 2:
            _destino = '';
            break;
          case 3:
            _servicio = '';
            break;
          case 4:
            _preferencia = '';
            break;
          case 5:
            _emergencia = '';
            break;
        }
      });
    } else {
      speak("$campo cargado");
    }
  }

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled = (_origen.isNotEmpty &&
              _destino.isNotEmpty &&
              _preferencia.isNotEmpty) ||
          (_origen.isNotEmpty &&
              _servicio.isNotEmpty &&
              _preferencia.isNotEmpty) ||
          !(_origen == _destino) ||
          (_preferencia.isNotEmpty);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width, 300),
            painter: BluePainter(),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50.0, left: 16.0, right: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //header(context),  // Llamamos al header que importamos
                SizedBox(height: 20),
                HeaderTextoAccesible(),
                SizedBox(height: 20),
                _buildIcons(context),
                //qSizedBox(height: 20),
                Expanded(
                  child: ListView(
                    children: [
                      _buildLabelAndField('ORIGEN', 1, _origen),
                      SizedBox(height: 20),
                      _buildLabelAndField('DESTINO', 2, _destino),
                      SizedBox(height: 20),
                      _buildLabelAndField('SERVICIO', 3, _servicio),
                      SizedBox(height: 20),
                      _buildLabelAndField('PREFERENCIA', 4, _preferencia),
                      SizedBox(height: 40),
                      _buildButtons(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabelAndField(String label, int index, String text) {
    String ayudita = colocarMayusculas(label);
    return Row(
      children: [
        SizedBox(width: 10),
        Expanded(
          flex: 3,
          child: GestureDetector(
            onTap: () => _listen(index, label),
            child: AbsorbPointer(
              child: TextFormField(
                key: ValueKey(text),
                initialValue: text.isNotEmpty ? text : '',
                readOnly: false,
                enableInteractiveSelection: false,
                decoration: InputDecoration(
                  hintText: ayudita,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                  fillColor: const Color.fromRGBO(65, 105, 225, 0.1),
                  filled: true,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButtons() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: SizedBox(
                height: 60,
                child: ElevatedButton(
                  onPressed: _isButtonEnabled
                      ? () {
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Colors.white,
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    //const SizedBox(height: 25),
                                    const Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                      size: 100,
                                    ),
                                    //const SizedBox(height: 3),
                                    NavigationConfirmation(
                                      selectedOrigin: _origen,
                                      selectedArea: _destino,
                                      selectedService: _servicio,
                                      selectedPreference: _preferencia,
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                          /*
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NavigationConfirmation(
                          selectedOrigin: _origen,
                          selectedArea: _destino,
                          selectedService: _servicio,
                          selectedPreference: _preferencia,
                        ),
                      ),
                    );*/
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'ACEPTAR',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: SizedBox(
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    _triggerSOSAction();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'S.O.S.',
                    style: TextStyle(fontSize: 20, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _triggerSOSAction() async {
    detenerReproduccion();
    await _listen(5, "Area de Emergencia");
    await Future.delayed(Duration(milliseconds: 5000), () {});

    if (_emergencia.isEmpty) {
      speak("Se cancela el S.O.S.");
    } else {
      confirmacionAreaAccesible(context, _emergencia);
      speak("S.O.S. activado, por favor confirme.");
    }
  }
}

class CurvedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - 100);
    var controlPoint = Offset(size.width / 2, size.height);
    var endPoint = Offset(size.width, size.height - 100);
    path.quadraticBezierTo(
        controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

Widget _buildIcons(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      _buildButtonMenu('¿Como usar?', Icons.help, () {
        detenerReproduccion();
        speak(
            "Complete el campo origen y preferencia, el servicio y/o destino luego presionar aceptar. Posee un botón de S.O.S si lo precisa.");
      }),
      _buildButtonMenu('Cambiar Ubicación', Icons.location_on, () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LocationSelection()),
          (Route<dynamic> route) => false,
        );
      }),
      _buildButtonMenu('Mi Cuenta', Icons.account_circle, () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MyDataPage()),
          (Route<dynamic> route) => false,
        );
      }),
      _buildButtonMenu('Cambiar Contraseña', Icons.lock, () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const ChangePassword()),
          (Route<dynamic> route) => false,
        );
      }),
      _buildButtonMenu('Cerrar Sesión', Icons.logout, () {
        _logout(context);
      }),
    ],
  );
}

Widget _buildButtonMenu(String label, IconData icon, VoidCallback onPressed) {
  return Expanded(
    child: SizedBox(
      height: 80,
      child: Semantics(
        label: label,
        button: true,
        child: InkWell(
          onTap: onPressed,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 30),
              SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.white),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Future<void> _logout(context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await deleteUserSession();
  await prefs.remove('isLoggedIn');

  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.logout,
                color: Colors.grey,
                size: 80,
              ),
              SizedBox(height: 10),
              Text(
                '¿Cerrar sesión?',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
            ],
          ),
          actions: <Widget>[
            SizedBox(
              width: 95,
              height: 55,
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const StartPage()),
                    (Route<dynamic> route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  backgroundColor: Color.fromRGBO(17, 116, 186, 1),
                ),
                child: const Text(
                  "SI",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
            TextButton(
              child: const Text(
                'NO',
                style: TextStyle(
                    color: Color.fromRGBO(17, 116, 186, 1), fontSize: 16),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      });
}
