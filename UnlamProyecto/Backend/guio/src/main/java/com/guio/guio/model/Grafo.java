package com.guio.guio.model;

import java.util.HashSet;
import java.util.Set;

public class Grafo {

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
}
