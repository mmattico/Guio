package com.guio.guio.dao;

import javax.persistence.*;

@Entity
@Table(name = "BSNodo")
public class NodoDAO {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "NodoID")
    private Integer nodoID;
    @ManyToOne
    @JoinColumn(name = "GrafoID") // Definir la columna que actúa como clave foránea
    private GrafoDAO grafo;
    @Column(name = "Nombre")
    private String nombre;
    @Column(name = "Tipo")
    private String tipo;
    @Column(name = "Activo")
    private boolean activo;

    public NodoDAO(Integer nodoID, GrafoDAO grafo, String nombre, String tipo, boolean activo) {
        this.nodoID = nodoID;
        this.grafo = grafo;
        this.nombre = nombre;
        this.tipo = tipo;
        this.activo = activo;
    }

    public NodoDAO() {
    }

    public Integer getNodoID() {
        return nodoID;
    }

    public void setNodoID(Integer nodoID) {
        this.nodoID = nodoID;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getTipo() {
        return tipo;
    }

    public void setTipo(String tipo) {
        this.tipo = tipo;
    }

    public boolean isActivo() {
        return activo;
    }

    public void setActivo(boolean activo) {
        this.activo = activo;
    }

    public GrafoDAO getGrafo() {
        return grafo;
    }

    public void setGrafo(GrafoDAO grafo) {
        this.grafo = grafo;
    }
}
