package com.guio.guio.service;

import com.guio.guio.dao.NodoDAO;
import com.guio.guio.model.Nodo;
import com.guio.guio.repositorio.NodoRepositorio;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class NodoService {

    @Autowired
    private NodoRepositorio nodoRepositorio;

    public List<NodoDAO> getAllNodes() {
        return nodoRepositorio.findAll();
    }

    public List<NodoDAO> getNodeByNombreYUbicacionGrafo(String nombre, String ubicacion) {
        return nodoRepositorio.findNodosByNombreAndGrafoUbicacion(nombre,ubicacion);
    }

    public Optional<NodoDAO> getNodeById(Long id) {
        return nodoRepositorio.findById(id);
    }

    public NodoDAO saveNode(NodoDAO node) {
        return nodoRepositorio.save(node);
    }

    public void deleteNode(Long id) {
        nodoRepositorio.deleteById(id);
    }
}
