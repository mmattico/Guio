package com.guio.guio.model;

import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

public class Nodo {

    private String nombre;
    private Integer distancia = Integer.MAX_VALUE;
    private Arista arista = new Arista();
    private List<Nodo> caminoCorto = new LinkedList<>();
    Map<Nodo, Arista> nodosVecinos = new HashMap<>();

    public void addDestination(Nodo destino, Arista arista) {
        nodosVecinos.put(destino, arista);
    }

    public Nodo() {
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

    public Map<Nodo, Arista> getNodosVecinos() {
        return nodosVecinos;
    }

    public void setNodosVecinos(Map<Nodo, Arista> nodosVecinos) {
        this.nodosVecinos = nodosVecinos;
    }

    public Arista getArista() {
        return arista;
    }

    public void setArista(Arista arista) {
        this.arista = arista;
    }
}
