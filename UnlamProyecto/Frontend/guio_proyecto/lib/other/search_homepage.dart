import 'package:flutter/material.dart';
import 'package:guio_proyecto/other/get_nodos.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

/*
class CustomSearchDelegate extends SearchDelegate<String> {
  final List<String>? nodos;

  CustomSearchDelegate({required this.nodos});

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
    for (var nodo in nodos!) {
      if (nodo.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(nodo);
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
    for (var nodo in nodos!) {
      if (nodo.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(nodo);
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
*/

class CustomSearchDelegate extends SearchDelegate<String> {
  final List<Nodo>? nodos;

  CustomSearchDelegate({required this.nodos});

  final stt.SpeechToText _speechToText = stt.SpeechToText();

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, '');
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      Padding(
        padding: const EdgeInsets.fromLTRB(1, 1, 25, 1),
        child: IconButton(
          onPressed: () async {
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

  @override
  Widget buildResults(BuildContext context) {
    List<Nodo> matchQuery = [];
    for (var nodo in nodos!) {
      if (nodo.nombre.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(nodo);
      }
    }
    return Container(
      color: Colors.white,
      child: ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index) {
          var result = matchQuery[index];
          return ListTile(
            title: Text(
              result.nombre,
              style: TextStyle(
                color: result.activo ? Colors.black : Colors.red,
              ),
            ),
            onTap: () {
              if (!result.activo) {
                // Mostrar un popup si el nodo está desactivado
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Área No Habilitada'),
                      content: Text('El área "${result
                          .nombre}" no está habilitada para ser seleccionada.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Cerrar el popup
                            // Volver al listado sin seleccionar el nodo
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              } else {
                close(context,
                    result.nombre); // Cierra el buscador y devuelve el valor
              }
            },
          );
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Nodo> matchQuery = [];
    for (var nodo in nodos!) {
      if (nodo.nombre.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(nodo);
      }
    }
    return Container(
      color: Colors.white,
      child: ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index) {
          var result = matchQuery[index];
          return ListTile(
            title: Text(
              result.nombre,
              style: TextStyle(
                color: result.activo ? Colors.black : Colors.red,
              ),
            ),
            onTap: () {
              if (!result.activo) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      icon: Icon(Icons.warning_rounded, color: Colors.red, size: 100.0,),
                      title: Text('¡Área No Habilitada!', textAlign: TextAlign.center, style: TextStyle(fontSize: 22),),
                      content: Text('El área "${result.nombre}" no está habilitada para ser seleccionada.', textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 16),),
                      actions: [
                      SizedBox(
                        width: 95,
                        height: 60,
                        child:
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: const StadiumBorder(),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: const Color.fromRGBO(17, 116, 186, 1),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('OK',style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          )),
                        ),),
                      ],
                    );
                  },
                );
              } else {
                close(context, result.nombre);
              }
            },
          );
        },
      ),
    );
  }
}