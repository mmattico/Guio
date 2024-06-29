package com.guio.guio.model;

import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

public class Nodo {

    private String nombre;
    private Integer distancia = Integer.MAX_VALUE;
    private List<Nodo> caminoCorto = new LinkedList<>();
    Map<Nodo, Integer> nodosVecinos = new HashMap<>();

    public void addDestination(Nodo destino, int distancia) {
        nodosVecinos.put(destino, distancia);
    }

    public Nodo(String nombre) {
        this.nombre = nombre;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public Integer getDistancia() {
        return distancia;
    }

    public void setDistancia(Integer distancia) {
        this.distancia = distancia;
    }

    public List<Nodo> getCaminoCorto() {
        return caminoCorto;
    }

    public void setCaminoCorto(List<Nodo> caminoCorto) {
        this.caminoCorto = caminoCorto;
    }

    public Map<Nodo, Integer> getNodosVecinos() {
        return nodosVecinos;
    }

    public void setNodosVecinos(Map<Nodo, Integer> nodosVecinos) {
        this.nodosVecinos = nodosVecinos;
    }
}
