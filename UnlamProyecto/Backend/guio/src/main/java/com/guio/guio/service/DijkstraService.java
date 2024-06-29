package com.guio.guio.service;

import com.guio.guio.model.*;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import java.util.HashSet;
import java.util.LinkedList;
import java.util.Map;
import java.util.Set;

@SpringBootApplication
public class DijkstraService {

    public static Grafo calcularCaminoMasCortoDesdeFuente(Grafo grafo, Nodo fuente) {
        fuente.setDistancia(0);

        Set<Nodo> nodosRevisados = new HashSet<>();
        Set<Nodo> NodosNoRevisados = new HashSet<>();

        NodosNoRevisados.add(fuente);

        while (NodosNoRevisados.size() != 0) {
            Nodo currentNodo = getDistanciaMenorNodo(NodosNoRevisados);
            NodosNoRevisados.remove(currentNodo);
            for (Map.Entry<Nodo, Arista> parDeAdjacencia:currentNodo.getNodosVecinos().entrySet()) {
                Nodo nodoVecino = parDeAdjacencia.getKey();
                Arista arista = parDeAdjacencia.getValue();
                if (!nodosRevisados.contains(nodoVecino)) {
                    CalcularDistanciaMinima(nodoVecino, arista, currentNodo);
                    NodosNoRevisados.add(nodoVecino);
                }
            }
            nodosRevisados.add(currentNodo);
        }
        return grafo;
    }

    private static Nodo getDistanciaMenorNodo(Set<Nodo> nodosNoRevisados) {
        Nodo distanciaMenorNodo = null;
        int distanciaMenor = Integer.MAX_VALUE;
        for (Nodo nodo: nodosNoRevisados) {
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

    public static Camino convertirGrafoACamino(Grafo grafo, String nodoDestinoNombre) {

        Camino camino = new Camino();
        Nodo nodoDestino = new Nodo();
        for (Nodo nodo: grafo.getNodos()){
            if(nodo.getNombre().equals(nodoDestinoNombre)){
                nodoDestino = nodo;
                break;
            }
        }
        Instruccion instruccion = new Instruccion();
        instruccion.setCommando("El objetivo esta a una distancia de "+nodoDestino.getDistancia()+" metros");
        camino.addInstruccion(instruccion);

        for (Nodo nodo: nodoDestino.getCaminoCorto()){
            if(nodo.getArista().getDistancia().compareTo(0) > 0) {
                instruccion = new Instruccion();
                instruccion.setCommando("El nodo "+nodo.getNombre()+" esta a una distancia de " + nodo.getArista().getDistancia() + " metros");
                camino.addInstruccion(instruccion);
            }
        }

        if(nodoDestino.getArista().getDistancia().compareTo(0) > 0) {
            instruccion = new Instruccion();
            instruccion.setCommando("El nodo "+nodoDestino.getNombre()+" esta a una distancia de " + nodoDestino.getArista().getDistancia() + " metros");
            camino.addInstruccion(instruccion);
        }

        return camino;
    }
}
