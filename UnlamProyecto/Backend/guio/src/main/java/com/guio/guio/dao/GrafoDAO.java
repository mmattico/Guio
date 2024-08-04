package com.guio.guio.dao;

import com.fasterxml.jackson.annotation.JsonManagedReference;
import com.guio.guio.model.Nodo;

import javax.persistence.*;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "BSGrafo")
public class GrafoDAO {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "GrafoID")
    private Integer grafoID;
    @Column(name = "Nombre")
    private String nombre;
    @Column(name = "Codigo")
    private String codigo;
    @Column(name = "norte_grado")
    private Integer norteGrado;
    @OneToMany(mappedBy = "grafo")
    @JsonManagedReference
    private Set<NodoDAO> nodos = new HashSet<>();
    @OneToMany(mappedBy = "grafo")
    @JsonManagedReference
    private Set<UsuarioDAO> usuarios = new HashSet<>();

    public GrafoDAO(Integer grafoID, String nombre, String codigo, Integer norteGrado, Set<NodoDAO> nodos, Set<UsuarioDAO> usuarios) {
        this.grafoID = grafoID;
        this.nombre = nombre;
        this.codigo = codigo;
        this.norteGrado = norteGrado;
        this.nodos = nodos;
        this.usuarios = usuarios;
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

    public Integer getNorteGrado() {
        return norteGrado;
    }

    public void setNorteGrado(Integer norteGrado) {
        this.norteGrado = norteGrado;
    }

    public Set<UsuarioDAO> getUsuarios() {
        return usuarios;
    }

    public void setUsuarios(Set<UsuarioDAO> usuarios) {
        this.usuarios = usuarios;
    }
}
