import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//*************** BOTÓN DE EMERGENCIA ***************

/*Widget emergencyButton(BuildContext context) {
  return Column(
    children: [
      SizedBox(
        width: 60,
        height: 60,
        child: IconButton(onPressed: () {
          emergencyPopUp(context);
        },
            style: ElevatedButton.styleFrom(
              shape: const StadiumBorder(),
              //padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.red,
            ),
            icon: const Icon(Icons.sos,
              color: Colors.white,
              size: 40,
            )
        ),
      ),
    ],
  );
}*/

Future<void> emergencyPopUp(BuildContext context, int alertaId) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: const Column(
          children: <Widget>[
            Icon(
              Icons.warning_rounded,
              size: 95,
              color: Colors.red,
            ),
            SizedBox(height: 10),
            Text(
              'ALERTA ENVIADA',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 265,
              height: 55,
              child: Text(
                '¡Por favor, quédate en la\n'
                    'misma ubicación hasta recibir asistencia!\n',
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 15,)
          ],
        ),
        actions: <Widget>[
          Container(
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                SizedBox(
                  width: 180,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Color.fromRGBO(17, 116, 186, 1),
                    ),
                    onPressed: () async {
                      // Muestra el diálogo de confirmación
                      final result = await showDialog<bool>(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            title: const Text('Confirmación'),
                            content: const Text('¿Confirma que la emergencia fue solucionada?'),
                            actions: <Widget>[
                              SizedBox(
                                width: 60,
                                height: 40,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: const StadiumBorder(),
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    backgroundColor: const Color.fromRGBO(17, 116, 186, 1),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                  child: const Text('Sí', style: TextStyle(color: Colors.white),),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                                child: const Text('No', style: TextStyle(color: Color.fromRGBO(17, 116, 186, 1)),),
                              ),
                            ],
                          );
                        },
                      );

                      // Si el usuario eligió sí, cierra el popup original
                      if (result == true) {
                        //actualizar estado de alerta a "finalizada"
                        updateTicketStatus(alertaId, 'finalizada');
                        //agregar también update de comentario
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('Emergencia Solucionada', style: TextStyle(color: Colors.white,),
                  ),
                ),),
                SizedBox(height: 10,),
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  onPressed: () async {
                    // Muestra el diálogo de confirmación
                    final result = await showDialog<bool>(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.white,
                          title: const Text('Confirmación'),
                          content: const Text('¿Está seguro que desea cancelar?'),
                          actions: <Widget>[
                            SizedBox(
                              width: 85,
                              height: 60,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: const StadiumBorder(),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  backgroundColor: const Color.fromRGBO(17, 116, 186, 1),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop(true);

                                },
                                child: const Text('Sí', style: TextStyle(color: Colors.white),),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                              child: const Text('No', style: TextStyle(color: Color.fromRGBO(17, 116, 186, 1)),),
                            ),
                          ],
                        );
                      },
                    );

                    // Si el usuario eligió sí, cierra el popup original
                    if (result == true) {
                      //cambia estado de alerta a cancelada
                      updateTicketStatus(alertaId, 'cancelada');
                      //agregar también update de comentario
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(color: Color.fromRGBO(17, 116, 186, 1)),
                  ),
                )

              ],
            ),
          ),
        ],
      );
    },
  );
}

// CAMBIAR ESTADO DE LA ALERTA

Future<void> updateTicketStatus(int ticketId, String newStatus) async {
  final url = Uri.https('guio-hgazcxb0cwgjhkev.eastus-01.azurewebsites.net', '/api/alerta/$ticketId/estado');

  final response = await http.put(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: newStatus,
  );

  if (response.statusCode == 200) {
    print('Ticket actualizado con éxito');
  } else {
    print('Error al actualizar el ticket: ${response.statusCode}');
    print('Respuesta: ${response.body}');
  }
}