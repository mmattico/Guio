package com.guio.guio.controller;

import com.guio.guio.model.*;
import com.guio.guio.service.DijkstraService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("/api/dijktra")
public class DijkstraController {

	@Autowired
	DijkstraService service;

	@GetMapping("/mascorto")
	/*
	http://localhost:8080/api/dijktra/mascorto?ORIGEN=1&DESTINO=11
	* */
	public ResponseEntity<?> getCaminoMasCorto(@RequestParam(name = "ORIGEN") String nodoNombreOrigen,
											   @RequestParam(name = "DESTINO") String nodoNombreDestino,
											   @RequestParam(name = "PREFERENCIA") String preferencia,
											   @RequestParam(name = "UBICACION") String ubicacion) {
		Grafo grafo = service.obtenerGrafo(ubicacion, preferencia);
		grafo = service.calcularCaminoMasCortoDesdeFuente(grafo, nodoNombreOrigen);
		Camino camino = service.convertirGrafoACamino(grafo, nodoNombreDestino);
		return new ResponseEntity<>(camino, HttpStatus.OK);
	}

	@GetMapping("/portipo")
	public ResponseEntity<?> getCaminoMasCortoPorTipo(@RequestParam(name = "ORIGEN") String nodoNombreOrigen,
													  @RequestParam(name = "SERVICIO") String tipoNodoDestino,
													  @RequestParam(name = "PREFERENCIA") String preferencia,
													  @RequestParam(name = "UBICACION") String ubicacion) {
		Grafo grafo = service.obtenerGrafo(ubicacion, preferencia);
		grafo = service.calcularCaminoMasCortoDesdeFuente(grafo, nodoNombreOrigen);
		Camino camino = service.convertirGrafoACaminoPorTipo(grafo, tipoNodoDestino);
		camino.setNorteGrado(grafo.getNorteGrado());
		return new ResponseEntity<>(camino, HttpStatus.OK);
	}

	@GetMapping("/mascortoconnodointermedio")
	public ResponseEntity<?> getCaminoMasCortoPorTipo(@RequestParam(name = "ORIGEN") String nodoNombreOrigen,
													  @RequestParam(name = "DESTINO") String nodoNombreDestino,
													  @RequestParam(name = "SERVICIO") String tipoNodoIntermedio,
													  @RequestParam(name = "PREFERENCIA") String preferencia,
													  @RequestParam(name = "UBICACION") String ubicacion) {
		Planificacion planificacion = service.obtenerPlanificacion(ubicacion, preferencia);
		Camino camino = service.convertirGrafoACaminoConNodoIntermedio(planificacion, nodoNombreOrigen, tipoNodoIntermedio, nodoNombreDestino);
		return new ResponseEntity<>(camino, HttpStatus.OK);
	}
}
