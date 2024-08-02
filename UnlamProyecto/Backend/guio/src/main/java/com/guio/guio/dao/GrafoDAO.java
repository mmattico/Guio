package com.guio.guio.dao;

import com.guio.guio.model.Nodo;

import javax.persistence.*;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "BSGrafo")
public class GrafoDAO {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "GrafoID")
    private Integer grafoID;
    @Column(name = "Nombre")
    private String nombre;
    @Column(name = "Codigo")
    private String codigo;
    @OneToMany(mappedBy = "grafo")
    private Set<NodoDAO> nodos = new HashSet<>();

    public GrafoDAO(Integer grafoID, String nombre, String codigo, Set<NodoDAO> nodos) {
        this.grafoID = grafoID;
        this.nombre = nombre;
        this.codigo = codigo;
        this.nodos = nodos;
    }

    public GrafoDAO() {
    }

    public Integer getGrafoID() {
        return grafoID;
    }

    public void setGrafoID(Integer grafoID) {
        this.grafoID = grafoID;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getCodigo() {
        return codigo;
    }

    public void setCodigo(String codigo) {
        this.codigo = codigo;
    }

    public Set<NodoDAO> getNodos() {
        return nodos;
    }

    public void setNodos(Set<NodoDAO> nodos) {
        this.nodos = nodos;
    }
}
