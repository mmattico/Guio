package com.guio.guio.service;

import com.guio.guio.dao.GrafoDAO;
import com.guio.guio.dao.UsuarioDAO;
import com.guio.guio.repositorio.GrafoRepositorio;
import com.guio.guio.repositorio.UsuarioRepositorio;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class GrafoService {

    @Autowired
    private GrafoRepositorio grafoRepository;

    public GrafoDAO save(GrafoDAO grafo) {
        return grafoRepository.save(grafo);
    }

    public GrafoDAO findByCodigo(String codigo) {
        return grafoRepository.findByCodigo(codigo);
    }

    public void delete(Long id) {
        grafoRepository.deleteById(id);
    }

    public List<GrafoDAO> findAll() {
        return grafoRepository.findAll();
    }
}
