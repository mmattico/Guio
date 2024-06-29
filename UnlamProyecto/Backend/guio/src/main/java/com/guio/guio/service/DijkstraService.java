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
        Nodo nodoDestino = getNodoFromGrafo(grafo, nodoDestinoNombre);
        Camino camino = obtenerInstrucciones(nodoDestino);
        return camino;
    }

    private static Camino obtenerInstrucciones(Nodo nodoDestino) {
        Camino camino = new Camino();
        Instruccion instruccion = getInstruccionInicial(nodoDestino);
        camino.addInstruccion(instruccion);

        Arista aristaAnterior = new Arista();
        for (Nodo nodo: nodoDestino.getCaminoCorto()){
            if(nodo.getArista().getDistancia().compareTo(0) > 0) {
                if(aristaAnterior.getDistancia().compareTo(0) > 0){
                    obtenerInstruccionDeDireccion(camino, aristaAnterior, nodo.getArista());
                }
                addInstruccionACamino(camino, nodo);
                aristaAnterior = nodo.getArista();
            }
        }

        if(nodoDestino.getArista().getDistancia().compareTo(0) > 0) {
            if(aristaAnterior.getDistancia().compareTo(0) > 0){
                obtenerInstruccionDeDireccion(camino, aristaAnterior, nodoDestino.getArista());
            }
            addInstruccionACamino(camino, nodoDestino);
        }
        return camino;
    }

    private static void addInstruccionACamino(Camino camino, Nodo nodo) {
        Instruccion instruccion;
        instruccion = new Instruccion();
        instruccion.setCommando("El nodo " + nodo.getNombre() + " esta a una distancia de " + nodo.getArista().getDistancia() + " metros");
        camino.addInstruccion(instruccion);
    }

    private static void obtenerInstruccionDeDireccion(Camino camino, Arista aristaAnterior, Arista aristaDestino) {
        Instruccion instruccion;
        String orientacionFinal = aristaAnterior.getSentidoDestino();
        String orientacionDestino = aristaDestino.getSentidoOrigen();
        if((orientacionFinal.equals("N") && orientacionDestino.equals("O"))
                || (orientacionFinal.equals("O") && orientacionDestino.equals("S"))
                || (orientacionFinal.equals("S") && orientacionDestino.equals("E"))
                || (orientacionFinal.equals("E") && orientacionDestino.equals("N"))){
            instruccion = new Instruccion();
            instruccion.setCommando("Girar a la derecha");
            camino.addInstruccion(instruccion);
        }else if((orientacionFinal.equals("N") && orientacionDestino.equals("E"))
                || (orientacionFinal.equals("E") && orientacionDestino.equals("S"))
                || (orientacionFinal.equals("S") && orientacionDestino.equals("O"))
                || (orientacionFinal.equals("O") && orientacionDestino.equals("N"))){
            instruccion = new Instruccion();
            instruccion.setCommando("Girar a la izquierda");
            camino.addInstruccion(instruccion);
        }
    }

    private static Instruccion getInstruccionInicial(Nodo nodoDestino) {
        Instruccion instruccion = new Instruccion();
        instruccion.setCommando("El objetivo esta a una distancia de "+ nodoDestino.getDistancia()+" metros");
        return instruccion;
    }

    private static Nodo getNodoFromGrafo(Grafo grafo, String nodoDestinoNombre) {
        Nodo nodoDestino = new Nodo();
        for (Nodo nodo: grafo.getNodos()){
            if(nodo.getNombre().equals(nodoDestinoNombre)){
                nodoDestino = nodo;
                break;
            }
        }
        return nodoDestino;
    }
}
