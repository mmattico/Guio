package com.guio.guio.model;

public class Planificacion {
    private Grafo primeraParte;
    private Grafo segundaParte;

    public Grafo getPrimeraParte() {
        return primeraParte;
    }

    public void setPrimeraParte(Grafo primeraParte) {
        this.primeraParte = primeraParte;
    }

    public Grafo getSegundaParte() {
        return segundaParte;
    }

    public void setSegundaParte(Grafo segundaParte) {
        this.segundaParte = segundaParte;
    }
}
