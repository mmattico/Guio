package com.guio.guio.service;

import com.guio.guio.constantes.NodoCTE;
import com.guio.guio.model.*;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.stereotype.Service;

import java.sql.*;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.Map;
import java.util.Set;

@Service
public class DijkstraService {

    @Value("${spring.datasource.url}")
    private String url;

    @Value("${spring.datasource.username}")
    private String user;

    @Value("${spring.datasource.password}")
    private String password;

    @Value("${spring.datasource.driver-class-name}")
    private String driverClass;

    public static Grafo calcularCaminoMasCortoDesdeFuente(Grafo grafo, String nodoOrigenNombre) {
        Nodo fuente = getNodoFromGrafo(grafo, nodoOrigenNombre);

        fuente.setDistancia(0);

        Set<Nodo> nodosRevisados = new HashSet<>();
        Set<Nodo> NodosNoRevisados = new HashSet<>();

        NodosNoRevisados.add(fuente);

        while (NodosNoRevisados.size() != 0) {
            Nodo currentNodo = getDistanciaMenorNodo(NodosNoRevisados);
            NodosNoRevisados.remove(currentNodo);
            for (Map.Entry<Nodo, Arista> parDeAdjacencia : currentNodo.getNodosVecinos().entrySet()) {
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
        for (Nodo nodo : nodosNoRevisados) {
            int nodoDistancia = nodo.getDistancia();
            if (nodoDistancia < distanciaMenor) {
                distanciaMenor = nodoDistancia;
                distanciaMenorNodo = nodo;
            }
        }
        return distanciaMenorNodo;
    }

    private static void CalcularDistanciaMinima(Nodo nodoPrueba, Arista arista, Nodo nodoFuente) {
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
        Camino camino;
        if(nodoDestino.getCaminoCorto().isEmpty()){
            camino = obtenerInstruccionCaminoNoExiste();
        }else {
            camino = obtenerInstrucciones(nodoDestino);
        }
        return camino;
    }

    private static Camino obtenerInstruccionCaminoNoExiste() {
        Camino camino = new Camino();
        Instruccion instruccion = new Instruccion();
        instruccion.setCommando("No existe camino disponible, volver atras y elegir otra ruta");
        camino.addInstruccion(instruccion);
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
            instruccion.setSentidoOrigen(orientacionFinal);
            instruccion.setSentidoDestino(orientacionDestino);
            camino.addInstruccion(instruccion);
        } else if ((orientacionFinal.equals("N") && orientacionDestino.equals("E"))
                || (orientacionFinal.equals("E") && orientacionDestino.equals("S"))
                || (orientacionFinal.equals("S") && orientacionDestino.equals("O"))
                || (orientacionFinal.equals("O") && orientacionDestino.equals("N"))) {
            instruccion = new Instruccion();
            instruccion.setHaygiro(true);
            instruccion.setSentido("Izquierda");
            instruccion.setSentidoOrigen(orientacionFinal);
            instruccion.setSentidoDestino(orientacionDestino);
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

    public Planificacion obtenerPlanificacion(String ubicacion, String accesibilidadTipo) {
        Planificacion planificacion = new Planificacion();
        Grafo grafoParte1 = new Grafo();
        Grafo grafoParte2 = new Grafo();

        Connection connection = null;
        Statement statement = null;
        ResultSet resultSet = null;
        try {
            // Cargar el driver JDBC
            Class.forName(this.driverClass);

            // Establecer conexión
            connection = DriverManager.getConnection(this.url, this.user, this.password);

            // Crear un statement
            statement = connection.createStatement();

            String query = "SELECT BSNodo.* " +
                    "FROM BSNodo " +
                    "INNER JOIN BSGrafo on BSGrafo.GrafoID = BSNodo.GrafoID " +
                    "WHERE BSGrafo.Codigo = '" + ubicacion + "' " +
                    "AND BSNodo.Activo = '1' ";

            if(accesibilidadTipo.equals(NodoCTE.ACCESSIBILIDAD_ESCALERA)){
                query = query + "AND BSNodo.Tipo <> 'Ascensor'";
            }else if(accesibilidadTipo.equals(NodoCTE.ACCESSIBILIDAD_ASCENSOR)){
                query = query + "AND BSNodo.Tipo <> 'Escaleras'";
            }

            resultSet = statement.executeQuery(query);

            while (resultSet.next()) {
                String nodoNombre = resultSet.getString("Nombre");
                String nodoTipo = resultSet.getString("Tipo");
                Nodo NodoParte1 = new Nodo(nodoNombre, nodoTipo);
                Nodo NodoParte2 = new Nodo(nodoNombre, nodoTipo);
                grafoParte1.setGrafoID(resultSet.getInt("GrafoID"));
                grafoParte2.setGrafoID(resultSet.getInt("GrafoID"));
                grafoParte1.addNode(NodoParte1);
                grafoParte2.addNode(NodoParte2);
            }

            String query2 = "SELECT NodoOrigen.Nombre as NodoOrigenNombre, " +
                    "NodoDestino.Nombre as NodoDestinoNombre, " +
                    "BSArista.SentidoOrigen as SentidoOrigen, " +
                    "BSArista.SentidoDestino as SentidoDestino, " +
                    "BSArista.Distancia as Distancia, " +
                    "BSArista.ExistePuerta as ExistePuerta " +
                    "FROM BSArista " +
                    "INNER JOIN BSNodo NodoOrigen on NodoOrigen.NodoID = BSArista.NodoOrigenID " +
                    "INNER JOIN BSNodo NodoDestino on NodoDestino.NodoID = BSArista.NodoDestinoID " +
                    "WHERE NodoOrigen.GrafoID = " + grafoParte1.getGrafoID() + " " +
                    "AND NodoDestino.GrafoID = " + grafoParte1.getGrafoID();

            resultSet = statement.executeQuery(query2);
            while (resultSet.next()) {
                Nodo nodoOrigenParte1 = getNodoFromGrafo(grafoParte1, resultSet.getString("NodoOrigenNombre"));
                Nodo nodoDestinoParte1 = getNodoFromGrafo(grafoParte1, resultSet.getString("NodoDestinoNombre"));
                Nodo nodoOrigenParte2 = getNodoFromGrafo(grafoParte2, resultSet.getString("NodoOrigenNombre"));
                Nodo nodoDestinoParte2 = getNodoFromGrafo(grafoParte2, resultSet.getString("NodoDestinoNombre"));
                String sentidoOrigen = resultSet.getString("SentidoOrigen");
                String sentidoDestino = resultSet.getString("SentidoDestino");
                Integer distancia = resultSet.getInt("Distancia");
                boolean existePuerta = resultSet.getBoolean("ExistePuerta");
                nodoOrigenParte1.addDestination(nodoDestinoParte1,
                        new Arista(distancia, sentidoOrigen, sentidoDestino, existePuerta));
                nodoOrigenParte2.addDestination(nodoDestinoParte2,
                        new Arista(distancia, sentidoOrigen, sentidoDestino, existePuerta));
            }

        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        } finally {
            // Cerrar recursos
            try {
                if (resultSet != null) resultSet.close();
                if (statement != null) statement.close();
                if (connection != null) connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        planificacion.setPrimeraParte(grafoParte1);
        planificacion.setSegundaParte(grafoParte2);
        return planificacion;
    }

    public Grafo obtenerGrafo(String ubicacion, String accesibilidadTipo) {
        Grafo grafo = new Grafo();

        Connection connection = null;
        Statement statement = null;
        ResultSet resultSet = null;
        try {
            // Cargar el driver JDBC
            Class.forName(this.driverClass);

            // Establecer conexión
            connection = DriverManager.getConnection(this.url, this.user, this.password);

            // Crear un statement
            statement = connection.createStatement();

            String query = "SELECT BSNodo.* " +
                    "FROM BSNodo " +
                    "INNER JOIN BSGrafo on BSGrafo.GrafoID = BSNodo.GrafoID " +
                    "WHERE BSGrafo.Codigo = '" + ubicacion + "' " +
                    "AND BSNodo.Activo = '1' ";

            if(accesibilidadTipo.equals(NodoCTE.ACCESSIBILIDAD_ESCALERA)){
                query = query + "AND BSNodo.Tipo <> 'Ascensor'";
            }else if(accesibilidadTipo.equals(NodoCTE.ACCESSIBILIDAD_ASCENSOR)){
                query = query + "AND BSNodo.Tipo <> 'Escaleras'";
            }

            resultSet = statement.executeQuery(query);

            while (resultSet.next()) {
                String nodoNombre = resultSet.getString("Nombre");
                String nodoTipo = resultSet.getString("Tipo");
                Nodo Nodo = new Nodo(nodoNombre, nodoTipo);
                grafo.setGrafoID(resultSet.getInt("GrafoID"));
                grafo.addNode(Nodo);
            }

            String query2 = "SELECT NodoOrigen.Nombre as NodoOrigenNombre, " +
                                    "NodoDestino.Nombre as NodoDestinoNombre, " +
                                    "BSArista.SentidoOrigen as SentidoOrigen, " +
                                    "BSArista.SentidoDestino as SentidoDestino, " +
                                    "BSArista.Distancia as Distancia, " +
                                    "BSArista.ExistePuerta as ExistePuerta " +
                            "FROM BSArista " +
                            "INNER JOIN BSNodo NodoOrigen on NodoOrigen.NodoID = BSArista.NodoOrigenID " +
                            "INNER JOIN BSNodo NodoDestino on NodoDestino.NodoID = BSArista.NodoDestinoID " +
                            "WHERE NodoOrigen.GrafoID = " + grafo.getGrafoID() + " " +
                                "AND NodoDestino.GrafoID = " + grafo.getGrafoID();

            resultSet = statement.executeQuery(query2);
            while (resultSet.next()) {
                Nodo nodoOrigen = getNodoFromGrafo(grafo, resultSet.getString("NodoOrigenNombre"));
                Nodo nodoDestino = getNodoFromGrafo(grafo, resultSet.getString("NodoDestinoNombre"));
                String sentidoOrigen = resultSet.getString("SentidoOrigen");
                String sentidoDestino = resultSet.getString("SentidoDestino");
                Integer distancia = resultSet.getInt("Distancia");
                boolean existePuerta = resultSet.getBoolean("ExistePuerta");
                nodoOrigen.addDestination(nodoDestino,
                        new Arista(distancia, sentidoOrigen, sentidoDestino, existePuerta));
            }

        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        } finally {
            // Cerrar recursos
            try {
                if (resultSet != null) resultSet.close();
                if (statement != null) statement.close();
                if (connection != null) connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
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

    public static Camino convertirGrafoACaminoConNodoIntermedio(Planificacion planificacion,
                                                                String nodoNombreOrigen,
                                                                String tipoNodoIntermedio,
                                                                String nodoNombreDestino) {
        Grafo grafoServicio = calcularCaminoMasCortoDesdeFuente(planificacion.getPrimeraParte(), nodoNombreOrigen);
        Nodo nodoIntermedio = getNodoIntermedioFromGrafo(grafoServicio, tipoNodoIntermedio);
        if(nodoIntermedio.getCaminoCorto().isEmpty()){
            return obtenerInstruccionCaminoNoExiste();
        }
        Camino caminoAIntermedio = obtenerInstrucciones(nodoIntermedio);

        Instruccion instruccionFinIntermedio = new Instruccion();
        instruccionFinIntermedio.setDistancia(0);
        instruccionFinIntermedio.setCommando("Fin parte 1 del recorrido");
        instruccionFinIntermedio.setPausa(true);
        caminoAIntermedio.addInstruccion(instruccionFinIntermedio);

        Grafo grafoIntermedio = calcularCaminoMasCortoDesdeFuente(planificacion.getSegundaParte(), nodoIntermedio.getNombre());
        if(getNodoFromGrafo(grafoIntermedio, nodoNombreDestino).getCaminoCorto().isEmpty()){
            return obtenerInstruccionCaminoNoExiste();
        }
        Camino caminoADestino = convertirGrafoACamino(grafoIntermedio, nodoNombreDestino);

        Instruccion instruccionFin = new Instruccion();
        instruccionFin.setDistancia(0);
        instruccionFin.setCommando("Fin del recorrido");
        instruccionFin.setPausa(true);
        caminoADestino.addInstruccion(instruccionFin);

        return new Camino(caminoAIntermedio.mergeCaminos(caminoADestino));
    }

    private static Nodo getNodoIntermedioFromGrafo(Grafo grafo, String tipoNodoDestino) {
        Nodo nodoIntermedio = new Nodo();
        Integer distanciaMenor = NodoCTE.DISTANCIA_DEFAULT;
        for (Nodo nodoOrigen : grafo.getNodos()) {
            if (nodoOrigen.getTipo().equals(tipoNodoDestino)) {
                if(nodoOrigen.getDistancia() < distanciaMenor){
                    nodoIntermedio = nodoOrigen;
                    distanciaMenor = nodoOrigen.getDistancia();
                }
            }
        }
        return nodoIntermedio;
    }

}