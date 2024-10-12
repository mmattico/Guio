import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'dart:async';
import '../other/text_to_voice.dart';
import '../other/navigation_confirmation.dart';
import '../other/user_session.dart';
import '../other/get_nodos.dart';
import '../other/emergency_homepageaccesible.dart';
import '../other/header_homepage.dart';  // Asegúrate de importar el header

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
  final List<String> preferenciasPermitidas = ['Escaleras', 'Ascensor', 'Indiferente'];
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
    speak("Bienvenido, Los datos a ingresar serán únicamente por voz, por favor complete los campos que encontrara a la derecha de la pantalla para poder ayudarlo, luego presione aceptar, posee la opción por botón de enviar una alerta si lo necesita");
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
        _speech.listen(onResult: (result) {
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
        }, listenFor: const Duration(seconds: 4));
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
        _validarExistencia(_preferencia, 'PREFERENCIA', preferenciasPermitidas, 4);
        break;
      case 5:
        _validarExistencia(_emergencia, 'EMERGENCIA', areasPermitidas, 5);
        break;
    }
  }

  void _validarExistencia(String escucha, String campo, List<String> listaChequeo, int textFieldIndex) {
    if (!listaChequeo.contains(escucha)) {
      speak("Disculpe, no he entendido. Las opciones válidas son: ${listaChequeo.join(', ')}");
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
      _isButtonEnabled = (_origen.isNotEmpty && _destino.isNotEmpty && _preferencia.isNotEmpty) ||
          (_origen.isNotEmpty && _servicio.isNotEmpty && _preferencia.isNotEmpty);
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
                headerTexto(),
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
                      //SizedBox(height: 20),
                      //_buildRecordButton(), // Botón de grabación
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
    String ayudita = colocarMayusculas(("cargué " + label));
    return Row(
      children: [
        /*Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(fontSize: 20),
          ),
        ),*/
        SizedBox(width: 10),
        Expanded(
          flex: 3,
          child: GestureDetector(
            onTap: () => _listen(index, label),
            child: AbsorbPointer(
              child: TextFormField(
                key: ValueKey(text),
                initialValue: text,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: ayudita,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: _isButtonEnabled
              ? () {
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
            );
          }
              : null,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30), // Tamaño rectangular
            backgroundColor: Colors.blue, // Color de fondo
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Bordes redondeados pero rectangulares
            ),
          ),
          child: Text(
            'ACEPTAR',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            _triggerSOSAction();
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30), // Tamaño rectangular
            backgroundColor: Colors.red, // Color de fondo
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Bordes redondeados pero rectangulares
            ),
          ),
          child: Text(
            'S.O.S.',
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
        ),
      ],
    );
  }
 /*
  Widget _buildRecordButton() {
    return ElevatedButton(
      onPressed: _isListening
          ? _stopListening
          : () => _listen(_selectedTextFieldIndex, 'Campo seleccionado'),
      child: Text(_isListening ? 'Detener Grabación' : 'Iniciar Grabación'),
    );
  }
*/
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

