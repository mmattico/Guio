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
@RequestMapping("/api/gps")
public class DijkstraController {

	@GetMapping("/dijktra")
	public ResponseEntity<?> getCaminoMasCortoPrueba() {
		Nodo Nodo1 = new Nodo("1");
		Nodo Nodo2 = new Nodo("2");
		Nodo Nodo3 = new Nodo("3");
		Nodo Nodo4 = new Nodo("4");
		Nodo Nodo5 = new Nodo("5");
		Nodo Nodo6 = new Nodo("6");
		Nodo Nodo7 = new Nodo("7");
		Nodo Nodo8 = new Nodo("8");
		Nodo Nodo9 = new Nodo("9");
		Nodo Nodo10 = new Nodo("10");
		Nodo Nodo11 = new Nodo("11");
		Nodo Nodo12 = new Nodo("12");
		Nodo Nodo13 = new Nodo("13");

		Nodo1.addDestination(Nodo2, new Arista(2,"S","N"));

		Nodo2.addDestination(Nodo1, new Arista(2,"N","S"));
		Nodo2.addDestination(Nodo3, new Arista(3,"E","O"));

		Nodo3.addDestination(Nodo4, new Arista(4,"N","S"));
		Nodo3.addDestination(Nodo6, new Arista(5,"E","O"));
		Nodo3.addDestination(Nodo2, new Arista(3,"O","E"));
		Nodo3.addDestination(Nodo5, new Arista(4,"S","N"));

		Nodo4.addDestination(Nodo3, new Arista(4,"S","N"));

		Nodo5.addDestination(Nodo3, new Arista(4,"N","S"));

		Nodo6.addDestination(Nodo3, new Arista(5,"O","E"));
		Nodo6.addDestination(Nodo13, new Arista(4,"S","N"));
		Nodo6.addDestination(Nodo7, new Arista(4,"E","O"));

		Nodo7.addDestination(Nodo6, new Arista(4,"O","E"));
		Nodo7.addDestination(Nodo12, new Arista(4,"S","N"));

		Nodo8.addDestination(Nodo9, new Arista(2,"E","O"));

		Nodo9.addDestination(Nodo8, new Arista(2,"O","E"));
		Nodo9.addDestination(Nodo13, new Arista(1,"N","S"));
		Nodo9.addDestination(Nodo10, new Arista(5,"S","N"));

		Nodo10.addDestination(Nodo6, new Arista(5,"N","S"));
		Nodo10.addDestination(Nodo11, new Arista(4,"E","O"));

		Nodo11.addDestination(Nodo10, new Arista(4,"O","E"));
		Nodo11.addDestination(Nodo12, new Arista(5,"N","S"));

		Nodo12.addDestination(Nodo6, new Arista(4,"N","S"));
		Nodo12.addDestination(Nodo11, new Arista(5,"S","N"));

		Nodo13.addDestination(Nodo6, new Arista(4,"N","S"));
		Nodo13.addDestination(Nodo9, new Arista(1,"S","N"));

		Grafo grafo = new Grafo();

		grafo.addNode(Nodo1);
		grafo.addNode(Nodo2);
		grafo.addNode(Nodo3);
		grafo.addNode(Nodo4);
		grafo.addNode(Nodo5);
		grafo.addNode(Nodo6);
		grafo.addNode(Nodo7);
		grafo.addNode(Nodo8);
		grafo.addNode(Nodo9);
		grafo.addNode(Nodo10);
		grafo.addNode(Nodo11);
		grafo.addNode(Nodo12);
		grafo.addNode(Nodo13);

		grafo = DijkstraService.calcularCaminoMasCortoDesdeFuente(grafo, Nodo1);

		Camino camino = new Camino();
		camino = DijkstraService.convertirGrafoACamino(grafo, "9");
		return new ResponseEntity<>(camino, HttpStatus.OK);
	}
}
