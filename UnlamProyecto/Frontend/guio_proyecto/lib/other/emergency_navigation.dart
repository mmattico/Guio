import 'package:flutter/material.dart';
import 'package:guio_proyecto/other/user_session.dart';
import 'package:vibration/vibration.dart';
import 'emergency.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AreaDialog extends StatefulWidget {
  final String areaActual;
  final VoidCallback onCancel; // Agrega esta propiedad
  final Function updateCancelarRecorrido; // Nueva propiedad para updateCancelarRecorrido

  AreaDialog({
    required this.areaActual,
    required this.onCancel,
    required this.updateCancelarRecorrido, // Asegúrate de que esta función sea requerida
  });

  @override
  _AreaDialogState createState() => _AreaDialogState();
}

class _AreaDialogState extends State<AreaDialog> {
  String? areaEmergencia;
  Future<int?> userID = getUserID();
  Future<int?> graphID = getGraphID();

  int alertaId = 0;

  List<String> statusAlert = ['pendiente', 'en curso', 'finalizada', 'cancelada'];

  @override
  void initState() {
    super.initState();
    areaEmergencia = widget.areaActual;
    _cargarNombreUsuario();
    _cargarGrafoID();
  }

  Future<void> enviarAlerta(userID, graphID) async {
    var url = Uri.https('guio-hgazcxb0cwgjhkev.eastus-01.azurewebsites.net', '/api/alerta/');

    final payload = {
      'usuarioID': userID,
      'fecha': DateTime.now().toIso8601String(),
      'comentario': ' ',
      'lugarDeAlerta': areaEmergencia,
      'estado': 'pendiente',
      'grafoID': graphID
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
        print('Response data: $responseData');
        print('alerta enviada');
        alertaId = responseData['alertaID'];
        print('alerta id : $alertaId');
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

  int? _userID;
  int? _graphID;

  Future<void> _cargarNombreUsuario() async {
    int? userID = await getUserID();
    setState(() {
      _userID = userID;
    });
  }

  Future<void> _cargarGrafoID() async {
    int? graphID = await getGraphID();
    setState(() {
      _graphID = graphID;
    });
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
            'ENVIAR ALERTA',
            textAlign: TextAlign.center,
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Área seleccionada: ${widget.areaActual}", style: TextStyle(fontSize: 18)),
          const SizedBox(height: 4),
        ],
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
                    width: 210,
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.all(8.0),
                        backgroundColor: areaEmergencia == null ? Colors.grey : const Color.fromRGBO(17, 116, 186, 1),
                      ),
                      onPressed: widget.areaActual == null ? null : () async {
                        if (widget.areaActual != null) {
                          print('Usted se encuentra en: ${widget.areaActual}');
                          print('usuario id: $_userID');
                          print('grafo id: $_graphID');
                          await enviarAlerta(_userID, _graphID);
                          Navigator.of(context).pop();
                          emergencyPopUpNavigation(context, alertaId, widget.updateCancelarRecorrido);
                        }
                      },
                      child: const Text('Enviar alerta', style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      )),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  TextButton(
                    child: const Text('Cancelar', style: TextStyle(color: Color.fromRGBO(17, 116, 186, 1), fontSize: 16),),
                    onPressed: () {
                      widget.onCancel();
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

Future<void> confirmacionAreaActual(BuildContext context, String areaActual, Function updateCancelarRecorrido) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AreaDialog(
        areaActual: areaActual,
        onCancel: () {
          updateCancelarRecorrido(false);
        },
        updateCancelarRecorrido: updateCancelarRecorrido,
      );
    },
  );
}
