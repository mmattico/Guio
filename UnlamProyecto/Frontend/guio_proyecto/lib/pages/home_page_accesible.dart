import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'dart:async';
import '../other/text_to_voice.dart';
import '../other/navigation_confirmation.dart';

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
  bool _isDialogShowing = false;
  Timer? _timer;
  bool _isButtonEnabled = false;

  final List<String> areasPermitidas = ['Cardiología', 'Clínica Médica', 'Dermatología'];
  final List<String> preferenciasPermitidas = ['Escaleras', 'Ascensor', 'Indiferente'];
  final List<String> serviciosPermitidos = ['Baño', 'Snack', 'Ventanilla'];

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    speak("Bienvenido a Guio, por favor complete los campos para poder ayudarlo");
  }

  @override
  void dispose() {
    _timer?.cancel();
    _speech.stop();
    super.dispose();
  }

  void _listen(int textFieldIndex, String label) async {
    speak("Usted seleccionó " + label);
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) {
          if (status == 'nosListening') {
            _stopListening();
            Future.delayed(Duration(milliseconds: 500), () {
              _validarExistenciaSegunCampo(textFieldIndex);
            });
          }
        },
        onError: (error) => print('onError: $error'),
      );

      if (available) {
        setState(() {
          _isListening = true;
        });
        _speech.listen(onResult: (result) {
          setState(() {
            switch (textFieldIndex) {
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
            }
            _updateButtonState();
          });
        },listenFor: const Duration(seconds: 5));
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
    print("DATO ORIGEN: $_origen");
    print("DATO DESTINO: $_destino");
    print("DATO SERVICIO: $_servicio");
    print("DATO PREFERENCIA: $_preferencia");
    print("-------------------------------------");
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
    }
  }

  void _validarExistencia(String escucha, String campo, List<String> listaChequeo, int textFieldIndex) {
    if (!listaChequeo.contains(escucha) && !_isDialogShowing) {
      print(escucha + " " + campo + " " + textFieldIndex.toString());
      speak("Disculpe, no he entendido. Vuelva a intentarlo.");
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
        }
      });
      _mostrarAlerta(campo);
    } else {
      speak("Fin del reconocimiento, $campo cargado");
    }
  }

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled = (_origen.isNotEmpty && _destino.isNotEmpty && _preferencia.isNotEmpty) ||
          (_origen.isNotEmpty && _servicio.isNotEmpty && _preferencia.isNotEmpty);
    });
  }

  void _mostrarAlerta(String campo) {
    setState(() {
      _isDialogShowing = true;
    });

    if (mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          _timer?.cancel();
          _timer = Timer(Duration(seconds: 5), () {
            if (mounted && Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          });

          return GestureDetector(
            onTap: () {
              if (mounted && Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            },
            child: AlertDialog(
              title: Text('Elemento no válido'),
              content: Text('El área ingresada en $campo no existe.'),
            ),
          );
        },
      ).then((_) {
        setState(() {
          _isDialogShowing = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ingresar datos por voz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
    );
  }

  Widget _buildLabelAndField(String label, int index, String text) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(fontSize: 20),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          flex: 3,
          child: GestureDetector(
            onTap: () => _listen(index, label),
            child: AbsorbPointer(
              child: TextField(
                controller: TextEditingController(text: text),
                readOnly: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
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
            shape: CircleBorder(),
            padding: EdgeInsets.all(80),
          ),
          child: Text(
            'ACEPTAR',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ],
    );
  }
}
