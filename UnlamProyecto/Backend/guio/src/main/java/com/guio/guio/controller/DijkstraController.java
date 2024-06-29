package com.guio.guio.controller;

import com.guio.guio.model.*;
import com.guio.guio.service.DijkstraService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/dijktra")
public class DijkstraController {

	@GetMapping("/mascorto")
	/*
	http://localhost:8080/api/gps/dijktra?ORIGEN=1&DESTINO=11
	* */
	public ResponseEntity<?> getCaminoMasCorto(@RequestParam(name = "ORIGEN") String nodoNombreOrigen,
											   @RequestParam(name = "DESTINO") String nodoNombreDestino) {
		Grafo grafo = DijkstraService.obtenerGrafo();
		grafo = DijkstraService.calcularCaminoMasCortoDesdeFuente(grafo, nodoNombreOrigen);
		Camino camino = DijkstraService.convertirGrafoACamino(grafo, nodoNombreDestino);
		return new ResponseEntity<>(camino, HttpStatus.OK);
	}

	@GetMapping("/portipo")
	public ResponseEntity<?> getCaminoMasCortoPorTipo(@RequestParam(name = "ORIGEN") String nodoNombreOrigen,
											   @RequestParam(name = "TIPO") String tipoNodoDestino) {
		Grafo grafo = DijkstraService.obtenerGrafo();
		grafo = DijkstraService.calcularCaminoMasCortoDesdeFuente(grafo, nodoNombreOrigen);
		Camino camino = DijkstraService.convertirGrafoACaminoPorTipo(grafo, tipoNodoDestino);
		return new ResponseEntity<>(camino, HttpStatus.OK);
	}
}
