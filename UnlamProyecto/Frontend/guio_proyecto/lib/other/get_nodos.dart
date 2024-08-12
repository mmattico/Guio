import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';  // For jsonEncode

Future<List<Nodo>> fetchNodos() async {
  final response = await http.get(Uri.https('guio-hgazcxb0cwgjhkev.eastus-01.azurewebsites.net', '/api/nodos/'));

  if (response.statusCode == 200) {
    final utf8DecodedBody = utf8.decode(response.bodyBytes);
    List<dynamic> body = jsonDecode(utf8DecodedBody);
    print('JSON recibido: $body'); // Depuración

    if (body == null) {
      return [];
    }
    List<Nodo> nodos = body.map((dynamic item) => Nodo.fromJson(item)).toList();
    return nodos;
  } else {
    print('Error al obtener nodos: ${response.statusCode}');
    print('Cuerpo de la respuesta: ${response.body}');
    throw Exception('Error al obtener nodos');
  }
}

class Nodo {
  final int nodoId;
  final String nombre;
  final String tipo;
  final bool activo;

  Nodo({
    required this.nodoId,
    required this.nombre,
    required this.tipo,
    required this.activo,
  });

  factory Nodo.fromJson(Map<String, dynamic> json) {
    return Nodo(
        nodoId: json['nodoId'] ?? 000,
        nombre: json['nombre']?.toString() ?? '',
        tipo: json['tipo']?.toString() ?? '',
        activo: json['activo'],
    );
  }

  @override
  String toString() {
    return 'Nodo(nodoId: $nodoId, nombre: $nombre, tipo: $tipo, activo: $activo)';
  }
}

// Obtenemos solos los nodos areas

List<String> getNodosAreas(List<Nodo> nodos) {
  return nodos
      .where((nodo) => nodo.tipo == '')
      .map((nodo) => nodo.nombre)
      .toList();
}