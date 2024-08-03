package com.guio.guio.dao;

import javax.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "BSAlerta")
public class AlertaDAO {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "AlertaID")
    private Integer alertaID;
    @ManyToOne
    @JoinColumn(name = "UsuarioID") // Definir la columna que actúa como clave foránea
    private UsuarioDAO usuario;
    @Column(name = "Fecha")
    private LocalDateTime fecha;
    @Column(name = "Comentario")
    private String comentario;
    @Column(name = "LugarDeAlerta")
    private String lugarDeAlerta;
    @Column(name = "Estado")
    private String estado;

    public AlertaDAO(Integer alertaID, UsuarioDAO usuario, LocalDateTime fecha, String comentario, String lugarDeAlerta, String estado) {
        this.alertaID = alertaID;
        this.usuario = usuario;
        this.fecha = fecha;
        this.comentario = comentario;
        this.lugarDeAlerta = lugarDeAlerta;
        this.estado = estado;
    }

    public AlertaDAO() {
    }

    public Integer getAlertaID() {
        return alertaID;
    }

    public void setAlertaID(Integer alertaID) {
        this.alertaID = alertaID;
    }

    public UsuarioDAO getUsuario() {
        return usuario;
    }

    public void setUsuario(UsuarioDAO usuario) {
        this.usuario = usuario;
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
}