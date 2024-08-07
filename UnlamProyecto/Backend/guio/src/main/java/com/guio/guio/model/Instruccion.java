package com.guio.guio.model;

public class Instruccion {

    private String commando = "";
    private String siguienteNodo = "";
    private Integer distancia = 0;
    private boolean existePuerta;
    private boolean haygiro;
    private boolean pausa;
    private String sentido = "";
    private String sentidoOrigen = "";
    private String sentidoDestino = "";

    public String getSiguienteNodo() {
        return siguienteNodo;
    }

    public void setSiguienteNodo(String siguienteNodo) {
        this.siguienteNodo = siguienteNodo;
    }

    public Integer getDistancia() {
        return distancia;
    }

    public void setDistancia(Integer distancia) {
        this.distancia = distancia;
    }

    public boolean isExistePuerta() {
        return existePuerta;
    }

    public void setExistePuerta(boolean existePuerta) {
        this.existePuerta = existePuerta;
    }

    public boolean isHaygiro() {
        return haygiro;
    }

    public void setHaygiro(boolean haygiro) {
        this.haygiro = haygiro;
    }

    public String getSentido() {
        return sentido;
    }

    public void setSentido(String sentido) {
        this.sentido = sentido;
    }

    public String getCommando() {
        return commando;
    }

    public void setCommando(String commando) {
        this.commando = commando;
    }

    public boolean isPausa() {
        return pausa;
    }

    public void setPausa(boolean pausa) {
        this.pausa = pausa;
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
