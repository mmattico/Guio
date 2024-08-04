package com.guio.guio.service;

import com.guio.guio.dao.AlertaDAO;
import com.guio.guio.dao.GrafoDAO;
import com.guio.guio.repositorio.AlertaRepositorio;
import com.guio.guio.repositorio.GrafoRepositorio;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class AlertaService {

    @Autowired
    private AlertaRepositorio alertaRepository;

    public AlertaDAO save(AlertaDAO alerta) {
        return alertaRepository.save(alerta);
    }

    public List<AlertaDAO> findAllByGrafoUbicacion(String codigo) {
        return alertaRepository.findByGrafoUbicacion(codigo);
    }

    public void delete(Long id) {
        alertaRepository.deleteById(id);
    }

    public List<AlertaDAO> findAll() {
        return alertaRepository.findAll();
    }
}
