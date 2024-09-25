import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';  // For jsonEncode

Future<List<Nodo>> fetchNodos(Future<String?> graphCodeFuture) async {
  final graphCode = await graphCodeFuture;
  if (graphCode == null) {
    throw Exception('Graph code no proporcionado.');
  }

  final response = await http.get(Uri.https('guio-hgazcxb0cwgjhkev.eastus-01.azurewebsites.net', '/api/grafo/$graphCode'));

  if (response.statusCode == 200) {
    final utf8DecodedBody = utf8.decode(response.bodyBytes);
    final Map<String, dynamic> body = jsonDecode(utf8DecodedBody);

    print('JSON recibido: $body');

    if (body['nodos'] == null) {
      return [];
    }

    List<Nodo> nodos = (body['nodos'] as List)
        .map((dynamic item) => Nodo.fromJson(item))
        .toList();

    return nodos;
  } else {
    print('Error al obtener nodos: ${response.statusCode}');
    print('Cuerpo de la respuesta: ${response.body}');
    throw Exception('Error al obtener nodos');
  }
}


Future<List<Nodo>> fetchNodosExtremos(Future<String?> graphCodeFuture) async {
  final graphCode = await graphCodeFuture;
  if (graphCode == null) {
    throw Exception('Graph code no proporcionado.');
  }

  final response = await http.get(Uri.https('guio-hgazcxb0cwgjhkev.eastus-01.azurewebsites.net', '/api/nodos/extremos/$graphCode'));

  if (response.statusCode == 200) {
    final utf8DecodedBody = utf8.decode(response.bodyBytes);
    final List<dynamic> body = jsonDecode(utf8DecodedBody);

    print('JSON recibido: $body');

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


class Grafo {
  final List<Nodo> nodos;

  Grafo({
    required this.nodos,
  });

  factory Grafo.fromJson(Map<String, dynamic> json) {
    return Grafo(
      nodos: (json['nodos'] as List)
          .map((nodoJson) => Nodo.fromJson(nodoJson))
          .toList(),
    );
  }

  @override
  String toString() {
    return 'Grafo(nodos: $nodos)';
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

  // Método para convertir JSON en un objeto Nodo
  factory Nodo.fromJson(Map<String, dynamic> json) {
    return Nodo(
      nodoId: json['nodoId'] ?? 000,
      nombre: json['nombre']?.toString() ?? '',
      tipo: json['tipo']?.toString() ?? '',
      activo: json['activo'] ?? false, // Aseguramos que siempre haya un valor booleano
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