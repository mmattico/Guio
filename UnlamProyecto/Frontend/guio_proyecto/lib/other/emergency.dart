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
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Column(
          children: <Widget>[
            Icon(
              Icons.info_outline, // Icono grande
              size: 80, // Tamaño del icono
              color: Colors.red,
            ),
            SizedBox(height: 10), // Espacio entre el icono y el título
            Text(
              'ALERTA ENVIADA',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        content: const Text(
          '¡Por favor, quédate en la\n'
              'misma ubicación hasta recibir asistencia!\n',
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          Container(
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text('Emergencia Solucionada'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text('Cancelar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}
