import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:text_to_speech/text_to_speech.dart';

class AccesibleHome extends StatefulWidget {
  @override
  _AccesibleHome createState() => _AccesibleHome();
}

class _AccesibleHome extends State<AccesibleHome> {
  late stt.SpeechToText _speech;
  late TextToSpeech _textToSpeech;
  bool _isListening = false;
  String _text = " ";

  int _questionIndex = 0;
  final List<String> _responses = [];

  final List<String> _questions = [
    'Ingrese su origen',
    'Ingrese su destino',
    '¿Desea agregar otra parada?',
    '¿Prefiere ir por escalera o ascensor?',
  ];

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _textToSpeech = TextToSpeech();
    _speakQuestion();
  }

  void _speakQuestion() {
    if (_questionIndex < _questions.length) {
      _textToSpeech.speak(_questions[_questionIndex]);
    }
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() {
          _isListening = true;
        });
        _speech.listen(onResult: (result) {
          setState(() {
            _text = result.recognizedWords;
          });
        });

        // Detener el reconocimiento automáticamente después de 5 segundos
        Future.delayed(Duration(seconds: 5), () {
          if (_isListening) {
            _speech.stop();
            setState(() {
              _isListening = false;
              if (_text.isNotEmpty) {
                _handleResponse(_text);
                _text = "";  // Limpiar el texto reconocido
              }
            });
          }
        });
      }
    } else {
      setState(() {
        _isListening = false;
      });
      _speech.stop();
    }
  }

  void _handleResponse(String response) {
    setState(() {
      _responses.add(response);
      _questionIndex++;
      if (_questionIndex < _questions.length) {
        _speakQuestion();  // Leer la siguiente pregunta en voz alta
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (_questionIndex < _questions.length) ...[
                Text(
                  _questions[_questionIndex],
                  style: TextStyle(fontSize: 24),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _listen,
                  child: Text(_isListening ? 'Detener reconocimiento' : 'Habla ahora'),
                ),
              ] else ...[
                Text(
                  'Resumen de tus respuestas:',
                  style: TextStyle(fontSize: 24),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                ..._questions.asMap().entries.map((entry) {
                  int index = entry.key;
                  String question = entry.value;
                  String response = _responses[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      '$question $response',
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  );
                }).toList(),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Puedes hacer algo con las respuestas aquí si es necesario
                  },
                  child: Text('Aceptar'),
                ),
              ],
              if (_text.isNotEmpty && _isListening)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Text(
                    'Respuesta: $_text',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
