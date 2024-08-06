import 'package:flutter/material.dart';

//*************** BOTÓN DE EMERGENCIA ***************

Widget emergencyButton(BuildContext context) {
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
}

Future<void> emergencyPopUp(BuildContext context) {
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
              size: 80,
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
                                    //Ver si aca modificamos el estado de la alerta directamente a Finalizada
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
                                  //Aca deberiamos setear la alerta como Cancelada
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