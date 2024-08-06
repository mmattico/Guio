import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'dart:async';

class Magnetometer {
  StreamSubscription<CompassEvent>? _compassSubscription;

  // Inicia la suscripción al magnetómetro
  void startListening() {
    _compassSubscription = FlutterCompass.events!.listen((CompassEvent event) {
      double? direction = event.heading;
      if (direction == null) {
        print('Magnetómetro no disponible');
      } else {
        print('Dirección: ${direction.toStringAsFixed(2)}°');
      }
    });
  }

  // Detiene la suscripción al magnetómetro
  void stopListening() {
    _compassSubscription?.cancel();
  }
}