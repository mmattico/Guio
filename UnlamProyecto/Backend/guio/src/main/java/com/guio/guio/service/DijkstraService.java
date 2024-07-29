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

    public static Grafo calcularCaminoMasCortoDesdeFuente(Grafo grafo,
                                                          String nodoOrigenNombre,
                                                          String preferencia) {
        Nodo fuente = getNodoFromGrafo(grafo, nodoOrigenNombre);

        fuente.setDistancia(0);

        Set<Nodo> nodosRevisados = new HashSet<>();
        Set<Nodo> NodosNoRevisados = new HashSet<>();

        NodosNoRevisados.add(fuente);

        while (NodosNoRevisados.size() != 0) {
            Nodo currentNodo = getDistanciaMenorNodo(NodosNoRevisados);
            if (!preferencia.equalsIgnoreCase(NodoCTE.ACCESSIBILIDAD_CUALQUIERA)
                    && verificarPreferencia(currentNodo, preferencia))
                continue;

            NodosNoRevisados.remove(currentNodo);
            for (Map.Entry<Nodo, Arista> parDeAdjacencia : currentNodo.getNodosVecinos().entrySet()) {
                Nodo nodoVecino = parDeAdjacencia.getKey();
                if (!preferencia.equalsIgnoreCase(NodoCTE.ACCESSIBILIDAD_CUALQUIERA)
                        && verificarPreferencia(nodoVecino, preferencia))
                    continue;

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
        for (Nodo nodo : nodosNoRevisados) {
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
        for (Nodo nodo : nodoDestino.getCaminoCorto()) {
            if (nodo.getArista().getDistancia().compareTo(0) > 0) {
                if (aristaAnterior.getDistancia().compareTo(0) > 0) {
                    obtenerInstruccionDeDireccion(camino, aristaAnterior, nodo.getArista());
                }
                addInstruccionACamino(camino, nodo);
                aristaAnterior = nodo.getArista();
            }
        }

        if (nodoDestino.getArista().getDistancia().compareTo(0) > 0) {
            if (aristaAnterior.getDistancia().compareTo(0) > 0) {
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
        if ((orientacionFinal.equals("N") && orientacionDestino.equals("O"))
                || (orientacionFinal.equals("O") && orientacionDestino.equals("S"))
                || (orientacionFinal.equals("S") && orientacionDestino.equals("E"))
                || (orientacionFinal.equals("E") && orientacionDestino.equals("N"))) {
            instruccion = new Instruccion();
            instruccion.setHaygiro(true);
            instruccion.setSentido("Derecha");
            camino.addInstruccion(instruccion);
        } else if ((orientacionFinal.equals("N") && orientacionDestino.equals("E"))
                || (orientacionFinal.equals("E") && orientacionDestino.equals("S"))
                || (orientacionFinal.equals("S") && orientacionDestino.equals("O"))
                || (orientacionFinal.equals("O") && orientacionDestino.equals("N"))) {
            instruccion = new Instruccion();
            instruccion.setHaygiro(true);
            instruccion.setSentido("Izquierda");
            camino.addInstruccion(instruccion);
        }
    }

    private static Instruccion getInstruccionInicial(Nodo nodoDestino) {
        Instruccion instruccion = new Instruccion();
        instruccion.setCommando("El objetivo esta a una distancia de " + nodoDestino.getDistancia().toString() + " metros");
        return instruccion;
    }

    private static Nodo getNodoFromGrafo(Grafo grafo, String nodoDestinoNombre) {
        Nodo nodoDestino = new Nodo();
        for (Nodo nodo : grafo.getNodos()) {
            if (nodo.getNombre().equals(nodoDestinoNombre)) {
                nodoDestino = nodo;
                break;
            }
        }
        return nodoDestino;
    }

    public static Grafo obtenerGrafo(String accesibilidadTipo) {
        Grafo grafo = new Grafo();

        Nodo Nodo1 = new Nodo("1", NodoCTE.SERVICIO_TIPO_NADA);
        Nodo Nodo2 = new Nodo("2", NodoCTE.SERVICIO_TIPO_NADA);
        Nodo Nodo3 = new Nodo("3", NodoCTE.SERVICIO_TIPO_NADA);
        Nodo Nodo4 = new Nodo("4", NodoCTE.SERVICIO_TIPO_BAÑO);
        Nodo Nodo5 = new Nodo("Cardiología", NodoCTE.SERVICIO_TIPO_NADA);
        Nodo Nodo6 = new Nodo("6", NodoCTE.SERVICIO_TIPO_NADA);
        Nodo Nodo7 = new Nodo("7", NodoCTE.SERVICIO_TIPO_BAÑO);
        Nodo Nodo8 = new Nodo("Neurología", NodoCTE.SERVICIO_TIPO_NADA);
        Nodo Nodo9 = new Nodo("9", NodoCTE.SERVICIO_TIPO_NADA);
        Nodo Nodo10 = new Nodo("10", NodoCTE.SERVICIO_TIPO_NADA);
        Nodo Nodo11 = new Nodo("11", NodoCTE.SERVICIO_TIPO_NADA);
        Nodo Nodo12 = new Nodo("12", NodoCTE.SERVICIO_TIPO_NADA);
        Nodo Nodo13 = new Nodo("13", NodoCTE.SERVICIO_TIPO_NADA);
        Nodo Nodo14 = new Nodo("Dermatología", NodoCTE.SERVICIO_TIPO_NADA);
        Nodo Nodo15 = new Nodo("Pediatría", NodoCTE.SERVICIO_TIPO_NADA);
        Nodo Nodo16 = new Nodo("Clinica Medica", NodoCTE.SERVICIO_TIPO_NADA);
        Nodo Nodo17 = new Nodo("Ginecología", NodoCTE.SERVICIO_TIPO_NADA);

        Nodo1.addDestination(Nodo2, new Arista(2, "S", "N", true));

        Nodo2.addDestination(Nodo1, new Arista(2, "N", "S", true));
        Nodo2.addDestination(Nodo3, new Arista(3, "E", "O", false));

        Nodo3.addDestination(Nodo4, new Arista(4, "N", "S", false));
        Nodo3.addDestination(Nodo6, new Arista(5, "E", "O", false));
        Nodo3.addDestination(Nodo2, new Arista(3, "O", "E", false));
        Nodo3.addDestination(Nodo5, new Arista(4, "S", "N", false));

        Nodo4.addDestination(Nodo3, new Arista(4, "S", "N", false));

        Nodo5.addDestination(Nodo3, new Arista(4, "N", "S", false));

        Nodo6.addDestination(Nodo3, new Arista(5, "O", "E", false));
        Nodo6.addDestination(Nodo13, new Arista(4, "S", "N", false));
        Nodo6.addDestination(Nodo7, new Arista(4, "E", "O", false));

        Nodo7.addDestination(Nodo6, new Arista(4, "O", "E", false));
        Nodo7.addDestination(Nodo12, new Arista(4, "S", "N", false));

        Nodo8.addDestination(Nodo9, new Arista(2, "E", "O", true));

        Nodo9.addDestination(Nodo8, new Arista(2, "O", "E", true));
        Nodo9.addDestination(Nodo13, new Arista(1, "N", "S", false));
        Nodo9.addDestination(Nodo10, new Arista(5, "S", "N", false));

        Nodo10.addDestination(Nodo9, new Arista(5, "N", "S", false));
        Nodo10.addDestination(Nodo11, new Arista(4, "E", "O", false));
        Nodo10.addDestination(Nodo17, new Arista(1, "O", "E", true));

        Nodo11.addDestination(Nodo10, new Arista(4, "O", "E", false));
        Nodo11.addDestination(Nodo12, new Arista(5, "N", "S", false));
        Nodo11.addDestination(Nodo15, new Arista(1, "E", "O", true));

        Nodo12.addDestination(Nodo7, new Arista(4, "N", "S", false));
        Nodo12.addDestination(Nodo11, new Arista(5, "S", "N", false));
        Nodo12.addDestination(Nodo14, new Arista(1, "E", "O", true));
        Nodo12.addDestination(Nodo16, new Arista(1, "O", "E", true));

        Nodo13.addDestination(Nodo6, new Arista(4, "N", "S", false));
        Nodo13.addDestination(Nodo9, new Arista(1, "S", "N", false));

        Nodo14.addDestination(Nodo12, new Arista(1, "O", "E", true));

        Nodo15.addDestination(Nodo11, new Arista(1, "O", "E", true));

        Nodo16.addDestination(Nodo12, new Arista(1, "E", "O", true));

        Nodo17.addDestination(Nodo10, new Arista(1, "E", "O", true));

        if(accesibilidadTipo.equals(NodoCTE.ACCESSIBILIDAD_ASCENSOR)
                || accesibilidadTipo.equals(NodoCTE.ACCESSIBILIDAD_CUALQUIERA)){

            Nodo Nodo20 = new Nodo("20", NodoCTE.ACCESSIBILIDAD_ASCENSOR);
            Nodo Nodo21 = new Nodo("21", NodoCTE.ACCESSIBILIDAD_ASCENSOR);
            Nodo10.addDestination(Nodo21, new Arista(1, "S", "N", false));
            Nodo6.addDestination(Nodo20, new Arista(1, "N", "S", false));

            Nodo20.addDestination(Nodo6, new Arista(1, "S", "N", false));
            Nodo20.addDestination(Nodo21, new Arista(5, "O", "O", false));

            Nodo21.addDestination(Nodo20, new Arista(5, "O", "O", false));
            Nodo21.addDestination(Nodo10, new Arista(1, "N", "S", false));

            grafo.addNode(Nodo20);
            grafo.addNode(Nodo21);
        }

        if(accesibilidadTipo.equals(NodoCTE.ACCESSIBILIDAD_ESCALERA)
                || accesibilidadTipo.equals(NodoCTE.ACCESSIBILIDAD_CUALQUIERA)){

            Nodo Nodo18 = new Nodo("18", NodoCTE.ACCESSIBILIDAD_ESCALERA);
            Nodo Nodo19 = new Nodo("19", NodoCTE.ACCESSIBILIDAD_ESCALERA);

            Nodo7.addDestination(Nodo18, new Arista(1, "E", "O", false));

            Nodo11.addDestination(Nodo19, new Arista(1, "S", "N", true));

            Nodo18.addDestination(Nodo7, new Arista(1, "O", "E", false));
            Nodo18.addDestination(Nodo19, new Arista(2, "E", "E", false));

            Nodo19.addDestination(Nodo11, new Arista(1, "O", "E", false));
            Nodo19.addDestination(Nodo18, new Arista(2, "E", "E", false));

            grafo.addNode(Nodo18);
            grafo.addNode(Nodo19);
        }

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
        for (Nodo nodo : grafo.getNodos()) {
            if (nodo.getTipo().equals(tipoNodoDestino)
                    && nodo.getDistancia() < distanciaMenor) {
                nodoDestino = nodo;
                distanciaMenor = nodo.getDistancia();
            }
        }
        return nodoDestino;
    }

    public static Camino convertirGrafoACaminoConNodoIntermedio(Grafo grafoServicio, Grafo grafoOrigen,
                                                                String tipoNodoIntermedio,
                                                                String nodoNombreDestino,
                                                                String preferencia) {
        Nodo nodoIntermedio = getNodoIntermedioFromGrafo(grafoServicio, tipoNodoIntermedio, nodoNombreDestino, preferencia);
        Camino caminoAIntermedio = obtenerInstrucciones(nodoIntermedio);
        Instruccion instruccionFinIntermedio = new Instruccion();
        instruccionFinIntermedio.setDistancia(0);
        instruccionFinIntermedio.setCommando("Fin parte 1 del recorrido");
        caminoAIntermedio.addInstruccion(instruccionFinIntermedio);
        Grafo grafoIntermedio = obtenerGrafo(preferencia);
        grafoIntermedio = calcularCaminoMasCortoDesdeFuente(grafoIntermedio, nodoIntermedio.getNombre(), preferencia);
        Camino caminoADestino = convertirGrafoACamino(grafoIntermedio, nodoNombreDestino);
        Instruccion instruccionFin = new Instruccion();
        instruccionFin.setDistancia(0);
        instruccionFin.setCommando("Fin del recorrido");
        caminoADestino.addInstruccion(instruccionFin);
        return new Camino(caminoAIntermedio.mergeCaminos(caminoADestino));
    }

    private static Nodo getNodoIntermedioFromGrafo(Grafo grafo,
                                                   String tipoNodoDestino,
                                                   String nodoNombreDestino,
                                                   String preferencia) {
        Grafo grafoDestino = null;
        Nodo nodoIntermedio = new Nodo();
        Integer distanciaMenor = NodoCTE.DISTANCIA_DEFAULT;
        for (Nodo nodoOrigen : grafo.getNodos()) {
            if (nodoOrigen.getTipo().equals(tipoNodoDestino)) {
                /*grafoDestino = calcularCaminoMasCortoDesdeFuente(grafo, nodoOrigen.getNombre(), preferencia);
                for (Nodo nodoDestino : grafoDestino.getNodos()) {
                    if (nodoOrigen.getDistancia() + nodoDestino.getDistancia() < distanciaMenor) {
                        nodoIntermedio = nodoOrigen;
                        distanciaMenor = nodoOrigen.getDistancia() + nodoDestino.getDistancia();
                    }
                }*/
                if(nodoOrigen.getDistancia() < distanciaMenor){
                    nodoIntermedio = nodoOrigen;
                    distanciaMenor = nodoOrigen.getDistancia();
                }
            }
        }
        return nodoIntermedio;
    }

    private static boolean verificarPreferencia(Nodo nodo, String preferencia) {
        if ((preferencia.equalsIgnoreCase(NodoCTE.ACCESSIBILIDAD_ESCALERA)
                && nodo.getTipo().equalsIgnoreCase(NodoCTE.ACCESSIBILIDAD_ASCENSOR))
                || (preferencia.equalsIgnoreCase(NodoCTE.ACCESSIBILIDAD_ASCENSOR)
                && nodo.getTipo().equalsIgnoreCase(NodoCTE.ACCESSIBILIDAD_ESCALERA))) {
            return false;
        }
        return true;
    }
}