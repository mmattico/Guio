package com.guio.guio.service;

import com.guio.guio.model.*;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import java.util.HashSet;
import java.util.LinkedList;
import java.util.Map;
import java.util.Set;

@SpringBootApplication
public class DijkstraService {

    public static Grafo calcularCaminoMasCortoDesdeFuente(Grafo grafo, String nodoOrigenNombre) {
        Nodo fuente = getNodoFromGrafo(grafo, nodoOrigenNombre);

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

    public static Grafo obtenerGrafo() {
        Grafo grafo = new Grafo();

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
        return grafo;
    }
}
