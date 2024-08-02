package com.guio.guio.controller;

import com.guio.guio.model.*;
import com.guio.guio.service.DijkstraService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("/api/dijktra")
public class DijkstraController {

	@GetMapping("/mascorto")
	/*
	http://localhost:8080/api/dijktra/mascorto?ORIGEN=1&DESTINO=11
	* */
	public ResponseEntity<?> getCaminoMasCorto(@RequestParam(name = "ORIGEN") String nodoNombreOrigen,
											   @RequestParam(name = "DESTINO") String nodoNombreDestino,
											   @RequestParam(name = "PREFERENCIA") String preferencia) {
		Grafo grafo = DijkstraService.obtenerGrafo(preferencia);
		grafo = DijkstraService.calcularCaminoMasCortoDesdeFuente(grafo, nodoNombreOrigen, preferencia);
		Camino camino = DijkstraService.convertirGrafoACamino(grafo, nodoNombreDestino);
		return new ResponseEntity<>(camino, HttpStatus.OK);
	}

	@GetMapping("/portipo")
	public ResponseEntity<?> getCaminoMasCortoPorTipo(@RequestParam(name = "ORIGEN") String nodoNombreOrigen,
													  @RequestParam(name = "SERVICIO") String tipoNodoDestino,
													  @RequestParam(name = "PREFERENCIA") String preferencia) {
		Grafo grafo = DijkstraService.obtenerGrafo(preferencia);
		grafo = DijkstraService.calcularCaminoMasCortoDesdeFuente(grafo, nodoNombreOrigen, preferencia);
		Camino camino = DijkstraService.convertirGrafoACaminoPorTipo(grafo, tipoNodoDestino);
		return new ResponseEntity<>(camino, HttpStatus.OK);
	}

	@GetMapping("/mascortoconnodointermedio")
	public ResponseEntity<?> getCaminoMasCortoPorTipo(@RequestParam(name = "ORIGEN") String nodoNombreOrigen,
													  @RequestParam(name = "DESTINO") String nodoNombreDestino,
													  @RequestParam(name = "SERVICIO") String tipoNodoIntermedio,
													  @RequestParam(name = "PREFERENCIA") String preferencia) {
		Grafo grafo = DijkstraService.obtenerGrafo(preferencia);
		Grafo grafoServicio = DijkstraService.calcularCaminoMasCortoDesdeFuente(grafo, nodoNombreOrigen, preferencia);
		Camino camino = DijkstraService.convertirGrafoACaminoConNodoIntermedio(grafoServicio, grafo, tipoNodoIntermedio, nodoNombreDestino, preferencia);
		return new ResponseEntity<>(camino, HttpStatus.OK);
	}
}
