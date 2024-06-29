package com.guio.guio.model;

public class Instruccion {

    private String commando;
    private String siguienteNodo;
    private Integer distancia;
    private boolean existePuerta;
    private boolean haygiro;
    private String sentido;

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
}
