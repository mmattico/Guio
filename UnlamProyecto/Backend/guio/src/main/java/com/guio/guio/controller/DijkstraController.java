package com.guio.guio.controller;

import com.guio.guio.model.Grafo;
import com.guio.guio.model.Nodo;
import com.guio.guio.service.DijkstraService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/gps")
public class DijkstraController {

	@GetMapping("/dijktra")
	public ResponseEntity<?> getCaminoMasCortoPrueba() {
		Nodo NodoA = new Nodo("A");
		Nodo NodoB = new Nodo("B");
		Nodo NodoC = new Nodo("C");
		Nodo NodoD = new Nodo("D");
		Nodo NodoE = new Nodo("E");
		Nodo NodoF = new Nodo("F");

		NodoA.addDestination(NodoB, 10);
		NodoA.addDestination(NodoC, 15);

		NodoB.addDestination(NodoD, 12);
		NodoB.addDestination(NodoF, 15);

		NodoC.addDestination(NodoE, 10);

		NodoD.addDestination(NodoE, 2);
		NodoD.addDestination(NodoF, 1);

		NodoF.addDestination(NodoE, 5);

		Grafo grafo = new Grafo();

		grafo.addNode(NodoA);
		grafo.addNode(NodoB);
		grafo.addNode(NodoC);
		grafo.addNode(NodoD);
		grafo.addNode(NodoE);
		grafo.addNode(NodoF);

		grafo = DijkstraService.calculateShortestPathFromSource(grafo, NodoA);
		return new ResponseEntity<>(grafo, HttpStatus.OK);
	}
}
