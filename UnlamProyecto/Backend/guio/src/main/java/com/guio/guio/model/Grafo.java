package com.guio.guio.model;

import java.util.HashSet;
import java.util.Set;

public class Grafo {

    private Integer grafoID;
    private Set<Nodo> nodos = new HashSet<>();

    public void addNode(Nodo nodeA) {
        nodos.add(nodeA);
    }

    public Set<Nodo> getNodos() {
        return nodos;
    }

    public void setNodos(Set<Nodo> nodos) {
        this.nodos = nodos;
    }

    public Integer getGrafoID() {
        return grafoID;
    }

    public void setGrafoID(Integer grafoID) {
        this.grafoID = grafoID;
    }
}
