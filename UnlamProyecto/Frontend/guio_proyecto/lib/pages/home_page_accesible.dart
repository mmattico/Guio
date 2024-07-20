import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../other/navigation_confirmation.dart';
import '../other/emergency.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class AccesibleHome extends StatefulWidget {
  @override
  _AccesibleHome createState() => _AccesibleHome();
}

class _AccesibleHome extends State<AccesibleHome> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = "Press the button and start speaking";

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText(); // Inicialización de la variable
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Speech to Text'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(_text),
            SizedBox(height: 20),
            IconButton(
              icon: Icon(
                Icons.mic,
                size: 50,
                color: _isListening ? Colors.green : Colors.blue,
              ),
              onPressed: _listen,
            ),
          ],
        ),
      ),
    );
  }
}