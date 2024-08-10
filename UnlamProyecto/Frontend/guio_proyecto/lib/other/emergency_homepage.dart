import 'package:flutter/material.dart';
import '../other/search_homepage.dart';
import 'emergency.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';  // For jsonEncode

class AreaSelectionDialog extends StatefulWidget {
  @override
  _AreaSelectionDialogState createState() => _AreaSelectionDialogState();
}

class _AreaSelectionDialogState extends State<AreaSelectionDialog> {
  String? areaEmergencia;
  int alertaId = 0;

  List<String> statusAlert = ['pendiente', 'en curso', 'finalizada', 'cancelada'];


  Future<void> enviarAlerta() async {
    var url = Uri.https('guio-hgazcxb0cwgjhkev.eastus-01.azurewebsites.net', '/api/alerta/');

    final payload = {
      'usuario':{
        'usuarioID':'1'
      },
      'fecha': DateTime.now().toIso8601String(),
      'comentario': 'Nueva Alerta',
      'lugarDeAlerta': areaEmergencia,
      'estado': statusAlert[0],
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json', // Adjust headers as needed
        },
        body: jsonEncode(payload), // Convert your payload to a JSON string
      );

      // Check the response status
      if (response.statusCode == 200) {
        // If the server returns an OK response, parse the JSON
        final responseData = jsonDecode(response.body);
        alertaId = responseData['alertaID'];
        print('Response data: $responseData');
        print('alerta enviada');
      } else {
        // If the server did not return a 200 OK response,
        // throw an exception or handle it as needed
        print('Failed to post data: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any errors that occur during the request
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: const Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.warning_rounded,
            size: 95,
            color: Colors.red,
          ),
          SizedBox(height: 10),
          Text(
            'ENVIAR ALERTA', style: TextStyle(fontSize: 26),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      content: Container(
        width: 300.0,
        child:
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("¿En qué área se encuentra?", style: TextStyle(fontSize: 22),),
              const SizedBox(height: 8),
              SearchWidget(
                onAreaSelected: (area) {
                  setState(() {
                    areaEmergencia = area;
                  });
                },
              ),
            ],
          ),
      ),
      actions: <Widget>[
        Container(
          alignment: Alignment.center,
          child: Column(
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 220,
                    height: 70,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: areaEmergencia == null ? Colors.grey : const Color.fromRGBO(17, 116, 186, 1),
                      ),
                      onPressed: areaEmergencia == null ? null : () {
                        if (areaEmergencia != null) {
                          print('Área seleccionada: $areaEmergencia');
                          Navigator.of(context).pop();
                          emergencyPopUp(context, alertaId);
                          enviarAlerta();
                        }
                      },
                      child: const Text('Enviar alerta', style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      )),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  TextButton(
                    child: const Text('Cancelar', style: TextStyle(color:Color.fromRGBO(17, 116, 186, 1), fontSize: 17),),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Future<void> seleccionAreaEmergencia(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AreaSelectionDialog();
    },
  );
}

Widget emergencyButtonHome(BuildContext context) {
  return Column(
    children: [
      SizedBox(
        width: 60,
        height: 60,
        child: IconButton(
          onPressed: () {
            seleccionAreaEmergencia(context);
          },
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            backgroundColor: Colors.red,
          ),
          icon: const Icon(
            Icons.sos,
            color: Colors.white,
            size: 40,
          ),
        ),
      ),
    ],
  );
}

class SearchWidget extends StatefulWidget {
  final Function(String) onAreaSelected;

  SearchWidget({required this.onAreaSelected});

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  String buttonText = 'Buscar Área';

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        final result = await showSearch(
          context: context,
          delegate: CustomSearchDelegate(),
        );
        if (result != null) {
          setState(() {
            buttonText = result;
          });
          widget.onAreaSelected(result);
        }
      },
      child: Text(buttonText, style: const TextStyle(fontSize: 22, color: Color.fromRGBO(17, 116, 186, 1),),),
    );
  }
}