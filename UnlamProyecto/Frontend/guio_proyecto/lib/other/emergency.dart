import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//*************** BOTÓN DE EMERGENCIA ***************

Future<void> emergencyPopUp(BuildContext context, int alertaID) {
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
              width: double.infinity,
              height: 65,
              child: Text(
                '¡Por favor, quédate en la\n'
                'misma ubicación hasta recibir asistencia!\n',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15),
              ),
            ),
            SizedBox(
              height: 15,
            )
          ],
        ),
        actions: <Widget>[
          Container(
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                SizedBox(
                  width: 220,
                  height: 70,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      backgroundColor: Color.fromRGBO(17, 116, 186, 1),
                    ),
                    onPressed: () async {
                      final result = await showDialog<bool>(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            title: const Text('Confirmación'),
                            content: const Text(
                                '¿Confirma que la emergencia fue solucionada?', style: TextStyle(fontSize: 16),),
                            actions: <Widget>[
                              SizedBox(
                                width: 95,
                                height: 55,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    backgroundColor:
                                        Color.fromRGBO(17, 116, 186, 1),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                  child: const Text(
                                    'Sí',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                                child: const Text(
                                  'No',
                                  style: TextStyle(
                                      color: Color.fromRGBO(17, 116, 186, 1),
                                      fontSize: 18),
                                ),
                              ),
                            ],
                          );
                        },
                      );

                      // Si el usuario eligió sí, cierra el popup original y actualiza la alerta
                      if (result == true) {
                        //actualizar estado de alerta a "finalizada"
                        updateTicketStatus(alertaID, 'finalizada',
                            'Finalizada por el usuario');
                        //agregar también update de comentario
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text(
                      'Emergencia\nSolucionada',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
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
                          content:
                              const Text('¿Está seguro que desea cancelar?', style: TextStyle(fontSize: 16),),
                          actions: <Widget>[
                            SizedBox(
                              width: 95,
                              height: 55,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  backgroundColor:
                                      Color.fromRGBO(17, 116, 186, 1),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                },
                                child: const Text(
                                  'Sí',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                              child: const Text(
                                'No',
                                style: TextStyle(
                                    color: Color.fromRGBO(17, 116, 186, 1),
                                    fontSize: 18),
                              ),
                            ),
                          ],
                        );
                      },
                    );

                    // Si el usuario eligió sí, cierra el popup original
                    if (result == true) {
                      //cambia estado de alerta a cancelada
                      updateTicketStatus(
                          alertaID, 'cancelada', 'Cancelada por el usuario');
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

//

Future<void> emergencyPopUpNavigation(
    BuildContext context, int alertaID, Function updateCancelarRecorrido) {
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
              width: double.infinity,
              height: 65,
              child: Text(
                '¡Por favor, quédate en la\n'
                'misma ubicación hasta recibir asistencia!\n',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15),
              ),
            ),
            SizedBox(
              height: 15,
            )
          ],
        ),
        actions: <Widget>[
          Container(
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                SizedBox(
                  width: 220,
                  height: 70,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      backgroundColor: Color.fromRGBO(17, 116, 186, 1),
                    ),
                    onPressed: () async {
                      final result = await showDialog<bool>(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            title: const Text('Confirmación'),
                            content: const Text(
                                '¿Confirma que la emergencia fue solucionada?', style: TextStyle(fontSize: 16),),
                            actions: <Widget>[
                              SizedBox(
                                width: 95,
                                height: 55,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                    backgroundColor:
                                    Color.fromRGBO(17, 116, 186, 1),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                  child: const Text(
                                    'Sí',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                                child: const Text(
                                  'No',
                                  style: TextStyle(
                                      color: Color.fromRGBO(17, 116, 186, 1),
                                      fontSize: 18),
                                ),
                              ),
                            ],
                          );
                        },
                      );

                      // Si el usuario eligió sí, cierra el popup original y actualiza la alerta
                      if (result == true) {
                        //actualizar estado de alerta a "finalizada"
                        updateTicketStatus(alertaID, 'finalizada',
                            'Finalizado por el usuario');
                        updateCancelarRecorrido(false);
                        //agregar también update de comentario
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text(
                      'Emergencia\nSolucionada',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
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
                          content:
                              const Text('¿Está seguro que desea cancelar?', style: TextStyle(fontSize: 16),),
                          actions: <Widget>[
                            SizedBox(
                              width: 95,
                              height: 55,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  padding:
                                  const EdgeInsets.symmetric(vertical: 8),
                                  backgroundColor:
                                  Color.fromRGBO(17, 116, 186, 1),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                },
                                child: const Text(
                                  'Sí',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                              child: const Text(
                                'No',
                                style: TextStyle(
                                    color: Color.fromRGBO(17, 116, 186, 1),
                                    fontSize: 18),
                              ),
                            ),
                          ],
                        );
                      },
                    );

                    // Si el usuario eligió sí, cierra el popup original
                    if (result == true) {
                      //cambia estado de alerta a cancelada
                      updateTicketStatus(
                          alertaID, 'cancelada', 'Cancelada por el usuario');
                      updateCancelarRecorrido(false);
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

Future<void> updateTicketStatus(
    int ticketId, String newStatus, String comentario) async {
  final url = Uri.https('guio-hgazcxb0cwgjhkev.eastus-01.azurewebsites.net',
          '/api/alerta/$ticketId/estado')
      .replace(queryParameters: {'COMENTARIO': comentario});

  print('URL: $url');
  print('New Status: $newStatus');
  print('ticket id $ticketId');

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
