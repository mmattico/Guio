import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class CustomSearchDelegate extends SearchDelegate<String> {
  // Definición de áreas
  List<String> searchTerms = [
    "Cardiología",
    "Traumatología",
    "Oftalmología",
    "Clínica Médica",
    "Obstetricia",
    "Cirugía",
    "Internaciones",
    "Dermatología"
  ];

  // Instancia de SpeechToText
  final stt.SpeechToText _speechToText = stt.SpeechToText();

  // Ícono para volver hacia atrás, salir de la barra de búsqueda
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, '');
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  // Ícono de micrófono, para tomar comandos por voz
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      Padding(
        padding: const EdgeInsets.fromLTRB(1, 1, 25, 1),
        child: IconButton(
          onPressed: () async {
            // Verifica el estado de la conexión con el micrófono
            bool available = await _speechToText.initialize();
            if (available) {
              _speechToText.listen(
                onResult: (result) {
                  if (result.hasConfidenceRating) {
                    query = result.recognizedWords;
                    showResults(context);
                  }
                },
                listenFor: const Duration(seconds: 5),
                pauseFor: const Duration(seconds: 3),
                partialResults: true,
                onSoundLevelChange: (level) => print('Sound level: $level'),
              );
            } else {
              // Muestra un mensaje si el micrófono no está disponible
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Micrófono no disponible')),
              );
            }
          },
          icon: const Icon(Icons.mic_rounded, size: 35,),
        ),
      ),
    ];
  }

  // Para la búsqueda por teclado de un área
  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var term in searchTerms) {
      if (term.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(term);
      }
    }
    return Container(
      color: Colors.white, // Fondo blanco
      child: ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index) {
          var result = matchQuery[index];
          return ListTile(
            title: Text(result),
            onTap: () {
              close(context, result); // Devuelve el valor seleccionado y cierra el buscador
            },
          );
        },
      ),
    );
  }

  // Para la búsqueda por teclado de un área
  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var term in searchTerms) {
      if (term.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(term);
      }
    }
    return Container(
      color: Colors.white, // Fondo blanco
      child: ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index) {
          var result = matchQuery[index];
          return ListTile(
            title: Text(result),
            onTap: () {
              close(context, result); // Devuelve el valor seleccionado y cierra el buscador
            },
          );
        },
      ),
    );
  }
}
