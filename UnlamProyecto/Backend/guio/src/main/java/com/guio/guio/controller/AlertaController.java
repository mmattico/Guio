package com.guio.guio.controller;

import com.guio.guio.dao.AlertaDAO;
import com.guio.guio.dao.UsuarioDAO;
import com.guio.guio.service.AlertaService;
import com.guio.guio.service.UsuarioService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

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

    @PutMapping("/{id}/estado")
    public ResponseEntity<AlertaDAO> updateAlertaEstado(@PathVariable Integer id, @RequestBody String estadoNuevo) {
        Optional<AlertaDAO> alertaOpt = alertaService.getAlertaById(id.longValue());
        if (!alertaOpt.isPresent()) {
            return ResponseEntity.notFound().build();
        }

        AlertaDAO alerta = alertaOpt.get();
        alerta.setEstado(estadoNuevo);
        AlertaDAO updatedAlerta = alertaService.save(alerta);

        return ResponseEntity.ok(updatedAlerta);
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
