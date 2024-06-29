package com.guio.guio.service;

import com.guio.guio.model.Arista;
import com.guio.guio.model.Grafo;
import com.guio.guio.model.Nodo;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import java.util.HashSet;
import java.util.LinkedList;
import java.util.Map;
import java.util.Set;

@SpringBootApplication
public class DijkstraService {

    public static Grafo calculateShortestPathFromSource(Grafo grafo, Nodo fuente) {
        fuente.setDistancia(0);

        Set<Nodo> settledNodos = new HashSet<>();
        Set<Nodo> unsettledNodos = new HashSet<>();

        unsettledNodos.add(fuente);

        while (unsettledNodos.size() != 0) {
            Nodo currentNodo = getDistanciaMenorNodo(unsettledNodos);
            unsettledNodos.remove(currentNodo);
            for (Map.Entry<Nodo, Arista> adjacencyPair:
                    currentNodo.getNodosVecinos().entrySet()) {
                Nodo nodoVecino = adjacencyPair.getKey();
                Arista arista = adjacencyPair.getValue();
                if (!settledNodos.contains(nodoVecino)) {
                    CalcularDistanciaMinima(nodoVecino, arista, currentNodo);
                    unsettledNodos.add(nodoVecino);
                }
            }
            settledNodos.add(currentNodo);
        }
        return grafo;
    }

    private static Nodo getDistanciaMenorNodo(Set<Nodo> unsettledNodos) {
        Nodo distanciaMenorNodo = null;
        int distanciaMenor = Integer.MAX_VALUE;
        for (Nodo nodo: unsettledNodos) {
            int nodoDistancia = nodo.getDistancia();
            if (nodoDistancia < distanciaMenor) {
                distanciaMenor = nodoDistancia;
                distanciaMenorNodo = nodo;
            }
        }
        return distanciaMenorNodo;
    }

    private static void CalcularDistanciaMinima(Nodo nodoPrueba,
                                                 Arista arista, Nodo nodoFuente) {
        Integer peso = arista.getDistancia();
        Integer distanciaNodoFuente = nodoFuente.getDistancia();
        if (distanciaNodoFuente + peso < nodoPrueba.getDistancia()) {
            nodoPrueba.setDistancia(distanciaNodoFuente + peso);
            nodoPrueba.setArista(arista);
            LinkedList<Nodo> caminoMasCorto = new LinkedList<>(nodoFuente.getCaminoCorto());
            caminoMasCorto.add(nodoFuente);
            nodoPrueba.setCaminoCorto(caminoMasCorto);
        }
    }
}
