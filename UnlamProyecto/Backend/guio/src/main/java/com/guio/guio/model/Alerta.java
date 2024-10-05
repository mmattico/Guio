package com.guio.guio.model;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.guio.guio.dao.GrafoDAO;
import com.guio.guio.dao.UsuarioDAO;

import javax.persistence.*;
import java.time.LocalDateTime;

public class Alerta {

    private Long alertaID;
    private Long usuarioID;
    private LocalDateTime fecha;
    private String comentario;
    private String lugarDeAlerta;
    private String estado;
    private Integer grafoID;

    public Alerta(Long alertaID, Long usuarioID, LocalDateTime fecha, String comentario, String lugarDeAlerta, String estado, Integer grafoID) {
        this.alertaID = alertaID;
        this.usuarioID = usuarioID;
        this.fecha = fecha;
        this.comentario = comentario;
        this.lugarDeAlerta = lugarDeAlerta;
        this.estado = estado;
        this.grafoID = grafoID;
    }

    public Long getAlertaID() {
        return alertaID;
    }

    public void setAlertaID(Long alertaID) {
        this.alertaID = alertaID;
    }


    public LocalDateTime getFecha() {
        return fecha;
    }

    public void setFecha(LocalDateTime fecha) {
        this.fecha = fecha;
    }

    public String getComentario() {
        return comentario;
    }

    public void setComentario(String comentario) {
        this.comentario = comentario;
    }

    public String getLugarDeAlerta() {
        return lugarDeAlerta;
    }

    public void setLugarDeAlerta(String lugarDeAlerta) {
        this.lugarDeAlerta = lugarDeAlerta;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }



    public Alerta() {
    }


    public Long getUsuarioID() {
        return usuarioID;
    }

    public void setUsuarioID(Long usuarioID) {
        this.usuarioID = usuarioID;
    }

    public Integer getGrafoID() {
        return grafoID;
    }

    public void setGrafoID(Integer grafoID) {
        this.grafoID = grafoID;
    }
}
