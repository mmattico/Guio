package com.guio.guio.model;

public class Arista {
    private Integer distancia = 0;
    private String sentidoOrigen = "";
    private String sentidoDestino = "";
    private boolean existePuerta = false;

    public Arista() {
    }

    public Arista(Integer distancia, String sentidoOrigen, String sentidoDestino, boolean existePuerta) {
        this.distancia = distancia;
        this.sentidoOrigen = sentidoOrigen;
        this.sentidoDestino = sentidoDestino;
        this.existePuerta = existePuerta;
    }

    public Integer getDistancia() {
        return distancia;
    }

    public void setDistancia(Integer distancia) {
        this.distancia = distancia;
    }

    public String getSentidoOrigen() {
        return sentidoOrigen;
    }

    public void setSentidoOrigen(String sentidoOrigen) {
        this.sentidoOrigen = sentidoOrigen;
    }

    public String getSentidoDestino() {
        return sentidoDestino;
    }

    public void setSentidoDestino(String sentidoDestino) {
        this.sentidoDestino = sentidoDestino;
    }

    public boolean isExistePuerta() {
        return existePuerta;
    }

    public void setExistePuerta(boolean existePuerta) {
        this.existePuerta = existePuerta;
    }
}
