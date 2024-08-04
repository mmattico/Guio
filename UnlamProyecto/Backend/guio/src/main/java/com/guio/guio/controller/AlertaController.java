package com.guio.guio.controller;

import com.guio.guio.dao.AlertaDAO;
import com.guio.guio.dao.UsuarioDAO;
import com.guio.guio.service.AlertaService;
import com.guio.guio.service.UsuarioService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("/api/alerta")
public class AlertaController {

    @Autowired
    private AlertaService alertaService;

    @PostMapping
    public AlertaDAO createAlerta(@RequestBody AlertaDAO user) {
        return alertaService.save(user);
    }

    @GetMapping("/{ubicacionCodigo}")
    public List<AlertaDAO>  getAllAlertasByUbicacion(@PathVariable String ubicacionCodigo) {
        return alertaService.findAllByGrafoUbicacion(ubicacionCodigo);
    }

    @DeleteMapping("/{id}")
    public void deleteAlerta(@PathVariable Long id) {
        alertaService.delete(id);
    }

    @GetMapping
    public List<AlertaDAO> getAllAlerta() {
        return alertaService.findAll();
    }

}
