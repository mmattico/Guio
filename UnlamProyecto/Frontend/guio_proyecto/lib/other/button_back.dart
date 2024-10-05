import 'package:flutter/material.dart';
import 'dart:async';

class DoubleBackToExit extends StatelessWidget {
  final Widget child;

  DoubleBackToExit({required this.child});

  @override
  Widget build(BuildContext context) {
    DateTime? lastPressed;

    return WillPopScope(
      onWillPop: () async {
        DateTime now = DateTime.now();
        if (lastPressed == null || now.difference(lastPressed!) > Duration(seconds: 2)) {
          lastPressed = now;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Presiona nuevamente para salir'),
              duration: Duration(seconds: 2),
            ),
          );
          return false;
        }
        return true;
      },
      child: child,
    );
  }
}

class DisableBackButton extends StatelessWidget {
  final Widget child;

  DisableBackButton({required this.child});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Siempre devuelve false para bloquear el botón "atrás"
        return false;
      },
      child: child,
    );
  }
}
