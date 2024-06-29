package com.guio.guio.model;

public class Arista {
    private Integer distancia = 0;
    private String sentidoOrigen = "";
    private String sentidoDestino = "";

    public Arista() {
    }

    public Arista(Integer distancia, String sentidoOrigen, String sentidoDestino) {
        this.distancia = distancia;
        this.sentidoOrigen = sentidoOrigen;
        this.sentidoDestino = sentidoDestino;
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
}
