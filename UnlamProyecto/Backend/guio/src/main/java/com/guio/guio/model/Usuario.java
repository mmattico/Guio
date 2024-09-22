package com.guio.guio.model;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import com.guio.guio.dao.AlertaDAO;
import com.guio.guio.dao.GrafoDAO;

import javax.persistence.*;
import java.util.HashSet;
import java.util.Set;


public class Usuario {

    private Long usuarioID;
    private String nombre;
    private String apellido;
    private String email;
    private String telefono;
    private String dni;
    private String permisos;
    private String usuario;
    private String contraseña;
    private boolean accesibilidadDefault;
    private boolean contraseñaReseteada;

    public Usuario() {
    }

    public Usuario(Long usuarioID, String nombre, String apellido, String email, String telefono, String dni, String permisos, String usuario, String contraseña, boolean accesibilidadDefault, boolean contraseñaReseteada) {
        this.usuarioID = usuarioID;
        this.nombre = nombre;
        this.apellido = apellido;
        this.email = email;
        this.telefono = telefono;
        this.dni = dni;
        this.permisos = permisos;
        this.usuario = usuario;
        this.contraseña = contraseña;
        this.accesibilidadDefault = accesibilidadDefault;
        this.contraseñaReseteada = contraseñaReseteada;
    }

    public Long getUsuarioID() {
        return usuarioID;
    }

    public void setUsuarioID(Long usuarioID) {
        this.usuarioID = usuarioID;
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

    public boolean isAccesibilidadDefault() {
        return accesibilidadDefault;
    }

    public void setAccesibilidadDefault(boolean accesibilidadDefault) {
        this.accesibilidadDefault = accesibilidadDefault;
    }

    public boolean isContraseñaReseteada() {
        return contraseñaReseteada;
    }

    public void setContraseñaReseteada(boolean contraseñaReseteada) {
        this.contraseñaReseteada = contraseñaReseteada;
    }
}
