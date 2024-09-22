package com.guio.guio.dao;

import com.fasterxml.jackson.annotation.JsonBackReference;

import javax.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "BSAlerta")
public class AlertaDAO {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "AlertaID")
    private Long alertaID;
    @ManyToOne
    @JoinColumn(name = "UsuarioID") // Definir la columna que actúa como clave foránea
    @JsonBackReference
    private UsuarioDAO usuario;
    @Column(name = "Fecha")
    private LocalDateTime fecha;
    @Column(name = "Comentario")
    private String comentario;
    @Column(name = "lugar_de_alerta")
    private String lugarDeAlerta;
    @Column(name = "Estado")
    private String estado;
    @ManyToOne
    @JoinColumn(name = "GrafoID") // Definir la columna que actúa como clave foránea
    @JsonBackReference
    private GrafoDAO grafo;

    public AlertaDAO(Long alertaID, UsuarioDAO usuario, LocalDateTime fecha, String comentario, String lugarDeAlerta, String estado, GrafoDAO grafo) {
        this.alertaID = alertaID;
        this.usuario = usuario;
        this.fecha = fecha;
        this.comentario = comentario;
        this.lugarDeAlerta = lugarDeAlerta;
        this.estado = estado;
        this.grafo = grafo;
    }

    public AlertaDAO() {
    }

    public Long getAlertaID() {
        return alertaID;
    }

    public void setAlertaID(Long alertaID) {
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

    public GrafoDAO getGrafo() {
        return grafo;
    }

    public void setGrafo(GrafoDAO grafo) {
        this.grafo = grafo;
    }
}
