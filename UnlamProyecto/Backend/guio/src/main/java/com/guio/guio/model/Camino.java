package com.guio.guio.model;

import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Set;

public class Camino {

    private List<Instruccion> instrucciones = new LinkedList<>();

    public void addInstruccion(Instruccion instruccion) {
        instrucciones.add(instruccion);
    }

    public List<Instruccion> getInstrucciones() {
        return instrucciones;
    }

    public void setInstrucciones(List<Instruccion> instrucciones) {
        this.instrucciones = instrucciones;
    }
}
