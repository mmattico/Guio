package com.guio.guio.dao;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonManagedReference;

import javax.persistence.*;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "BSUsuario")
public class UsuarioDAO {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "UsuarioID")
    private Integer usuarioID;
    @ManyToOne
    @JoinColumn(name = "GrafoID") // Definir la columna que actúa como clave foránea
    @JsonBackReference
    private GrafoDAO grafo;
    @OneToMany(mappedBy = "usuario")
    @JsonManagedReference
    private Set<AlertaDAO> alertas = new HashSet<>();
    @Column(name = "Nombre")
    private String nombre;
    @Column(name = "Apellido")
    private String apellido;
    @Column(name = "Email")
    private String email;
    @Column(name = "Telefono")
    private String telefono;
    @Column(name = "Dni")
    private String dni;
    @Column(name = "Permisos")
    private String permisos;
    @Column(name = "Usuario")
    private String usuario;
    @Column(name = "Contraseña")
    private String contraseña;

    public UsuarioDAO(Integer usuarioID, GrafoDAO grafo, Set<AlertaDAO> alertas, String nombre, String apellido, String email, String telefono, String dni, String permisos, String usuario, String contraseña) {
        this.usuarioID = usuarioID;
        this.grafo = grafo;
        this.alertas = alertas;
        this.nombre = nombre;
        this.apellido = apellido;
        this.email = email;
        this.telefono = telefono;
        this.dni = dni;
        this.permisos = permisos;
        this.usuario = usuario;
        this.contraseña = contraseña;
    }

    public UsuarioDAO() {
    }

    public Integer getUsuarioID() {
        return usuarioID;
    }

    public void setUsuarioID(Integer usuarioID) {
        this.usuarioID = usuarioID;
    }

    public GrafoDAO getGrafo() {
        return grafo;
    }

    public void setGrafo(GrafoDAO grafo) {
        this.grafo = grafo;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getApellido() {
        return apellido;
    }

    public void setApellido(String apellido) {
        this.apellido = apellido;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getTelefono() {
        return telefono;
    }

    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }

    public String getDni() {
        return dni;
    }

    public void setDni(String dni) {
        this.dni = dni;
    }

    public String getPermisos() {
        return permisos;
    }

    public void setPermisos(String permisos) {
        this.permisos = permisos;
    }

    public String getUsuario() {
        return usuario;
    }

    public void setUsuario(String usuario) {
        this.usuario = usuario;
    }

    public String getContraseña() {
        return contraseña;
    }

    public void setContraseña(String contraseña) {
        this.contraseña = contraseña;
    }

    public Set<AlertaDAO> getAlertas() {
        return alertas;
    }

    public void setAlertas(Set<AlertaDAO> alertas) {
        this.alertas = alertas;
    }
}
