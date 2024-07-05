package com.guio.guio.service;

import com.guio.guio.constantes.NodoCTE;
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
        instruccion.setExistePuerta(nodo.getArista().isExistePuerta());
        instruccion.setSiguienteNodo(nodo.getNombre());
        instruccion.setDistancia(nodo.getArista().getDistancia());
        instruccion.setHaygiro(false);
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
            instruccion.setHaygiro(true);
            instruccion.setSentido("Derecha");
            camino.addInstruccion(instruccion);
        }else if((orientacionFinal.equals("N") && orientacionDestino.equals("E"))
                || (orientacionFinal.equals("E") && orientacionDestino.equals("S"))
                || (orientacionFinal.equals("S") && orientacionDestino.equals("O"))
                || (orientacionFinal.equals("O") && orientacionDestino.equals("N"))){
            instruccion = new Instruccion();
            instruccion.setHaygiro(true);
            instruccion.setSentido("Izquierda");
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

        Nodo Nodo1 = new Nodo("1", NodoCTE.NODO_TIPO_NADA);
        Nodo Nodo2 = new Nodo("2", NodoCTE.NODO_TIPO_NADA);
        Nodo Nodo3 = new Nodo("3", NodoCTE.NODO_TIPO_NADA);
        Nodo Nodo4 = new Nodo("4", NodoCTE.NODO_TIPO_BAÑO);
        Nodo Nodo5 = new Nodo("5", NodoCTE.NODO_TIPO_NADA);
        Nodo Nodo6 = new Nodo("6", NodoCTE.NODO_TIPO_NADA);
        Nodo Nodo7 = new Nodo("7", NodoCTE.NODO_TIPO_BAÑO);
        Nodo Nodo8 = new Nodo("8", NodoCTE.NODO_TIPO_NADA);
        Nodo Nodo9 = new Nodo("9", NodoCTE.NODO_TIPO_NADA);
        Nodo Nodo10 = new Nodo("10", NodoCTE.NODO_TIPO_NADA);
        Nodo Nodo11 = new Nodo("11", NodoCTE.NODO_TIPO_NADA);
        Nodo Nodo12 = new Nodo("12", NodoCTE.NODO_TIPO_NADA);
        Nodo Nodo13 = new Nodo("13", NodoCTE.NODO_TIPO_NADA);

        Nodo1.addDestination(Nodo2, new Arista(2,"S","N",true));

        Nodo2.addDestination(Nodo1, new Arista(2,"N","S",true));
        Nodo2.addDestination(Nodo3, new Arista(3,"E","O", false));

        Nodo3.addDestination(Nodo4, new Arista(4,"N","S", false));
        Nodo3.addDestination(Nodo6, new Arista(5,"E","O", false));
        Nodo3.addDestination(Nodo2, new Arista(3,"O","E", false));
        Nodo3.addDestination(Nodo5, new Arista(4,"S","N", false));

        Nodo4.addDestination(Nodo3, new Arista(4,"S","N", false));

        Nodo5.addDestination(Nodo3, new Arista(4,"N","S", false));

        Nodo6.addDestination(Nodo3, new Arista(5,"O","E", false));
        Nodo6.addDestination(Nodo13, new Arista(4,"S","N", false));
        Nodo6.addDestination(Nodo7, new Arista(4,"E","O", false));

        Nodo7.addDestination(Nodo6, new Arista(4,"O","E", false));
        Nodo7.addDestination(Nodo12, new Arista(4,"S","N", false));

        Nodo8.addDestination(Nodo9, new Arista(2,"E","O", true));

        Nodo9.addDestination(Nodo8, new Arista(2,"O","E",true));
        Nodo9.addDestination(Nodo13, new Arista(1,"N","S", false));
        Nodo9.addDestination(Nodo10, new Arista(5,"S","N", false));

        Nodo10.addDestination(Nodo6, new Arista(5,"N","S", false));
        Nodo10.addDestination(Nodo11, new Arista(4,"E","O", false));

        Nodo11.addDestination(Nodo10, new Arista(4,"O","E", false));
        Nodo11.addDestination(Nodo12, new Arista(5,"N","S", false));

        Nodo12.addDestination(Nodo6, new Arista(4,"N","S", false));
        Nodo12.addDestination(Nodo11, new Arista(5,"S","N", false));

        Nodo13.addDestination(Nodo6, new Arista(4,"N","S", false));
        Nodo13.addDestination(Nodo9, new Arista(1,"S","N", false));

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

    public static Camino convertirGrafoACaminoPorTipo(Grafo grafo, String tipoNodoDestino) {
        Nodo nodoDestino = getNodoWithTypeFromGrafo(grafo, tipoNodoDestino);
        Camino camino = obtenerInstrucciones(nodoDestino);
        return camino;
    }

    private static Nodo getNodoWithTypeFromGrafo(Grafo grafo, String tipoNodoDestino) {
        Nodo nodoDestino = new Nodo();
        Integer distanciaMenor = NodoCTE.DISTANCIA_DEFAULT;
        for (Nodo nodo: grafo.getNodos()){
            if(nodo.getTipo().equals(tipoNodoDestino)
                    && nodo.getDistancia() < distanciaMenor){
                nodoDestino = nodo;
                distanciaMenor = nodo.getDistancia();
            }
        }
        return nodoDestino;
    }
}
