import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';  // For jsonEncode

Future<List<Grafo>> fetchGrafos() async {
  final response = await http.get(Uri.https('guio-hgazcxb0cwgjhkev.eastus-01.azurewebsites.net', '/api/grafo/'));

  if (response.statusCode == 200) {
    final utf8DecodedBody = utf8.decode(response.bodyBytes);
    List<dynamic> body = jsonDecode(utf8DecodedBody);
    print('JSON recibido: $body');

    if (body == null) {
      return [];
    }
    List<Grafo> grafos = body.map((dynamic item) => Grafo.fromJson(item)).toList();
    return grafos;
  } else {
    print('Error al obtener grafos: ${response.statusCode}');
    print('Cuerpo de la respuesta: ${response.body}');
    throw Exception('Error al obtener grafos');
  }
}

class Grafo {
  final int grafoID;
  final String nombre;
  final String codigo;
  final int norteGrado;

  Grafo({
    required this.grafoID,
    required this.nombre,
    required this.codigo,
    required this.norteGrado,
  });

  factory Grafo.fromJson(Map<String, dynamic> json) {
    return Grafo(
        grafoID: json['grafoID'] ?? 000,
        nombre: json['nombre']?.toString() ?? '',
        codigo: json['codigo']?.toString() ?? '',
        norteGrado: json['norteGrado']
    );
  }

  @override
  String toString() {
    return 'Nodo(grafoID: $grafoID, nombre: $nombre, codigo: $codigo, norteGrado: $norteGrado)';
  }
}

// Obtenemos solos los nodos areas

List<String> getNGrafoss(List<Grafo> grafos) {
  return grafos
      .where((grafo) => grafo.codigo == '')
      .map((grafo) => grafo.nombre)
      .toList();
}