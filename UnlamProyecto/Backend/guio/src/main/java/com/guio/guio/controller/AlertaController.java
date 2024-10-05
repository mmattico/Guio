package com.guio.guio.controller;

import com.guio.guio.dao.AlertaDAO;
import com.guio.guio.dao.GrafoDAO;
import com.guio.guio.dao.UsuarioDAO;
import com.guio.guio.model.Alerta;
import com.guio.guio.service.AlertaService;
import com.guio.guio.service.GrafoService;
import com.guio.guio.service.UsuarioService;
import com.guio.guio.summary.AlertaSummary;
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
    public AlertaDAO createAlerta(@RequestBody Alerta alerta) {
        AlertaDAO alert = new AlertaDAO();
        alert.setComentario(alerta.getComentario());
        alert.setLugarDeAlerta(alerta.getLugarDeAlerta());
        alert.setFecha(alerta.getFecha());
        GrafoDAO grafo = new GrafoDAO();
        grafo.setGrafoID(alerta.getGrafoID());
        alert.setGrafo(grafo);
        UsuarioDAO user = new UsuarioDAO();
        user.setUsuarioID(alerta.getUsuarioID());
        alert.setUsuario(user);
        alert.setEstado(alerta.getEstado());
        return alertaService.save(alert);
    }

    @GetMapping("/{ubicacionCodigo}")
    public List<AlertaSummary>  getAllAlertasByUbicacion(@PathVariable String ubicacionCodigo) {
        return alertaService.findAllByGrafoUbicacion(ubicacionCodigo);
    }

    @PutMapping("/{id}/estado")
    public ResponseEntity<AlertaDAO> updateAlertaEstado(@PathVariable Integer id,
                                                        @RequestParam(value = "COMENTARIO", required = false) String comentario,
                                                        @RequestBody String estadoNuevo) {
        Optional<AlertaDAO> alertaOpt = alertaService.getAlertaById(id.longValue());
        if (!alertaOpt.isPresent()) {
            return ResponseEntity.notFound().build();
        }

        AlertaDAO alerta = alertaOpt.get();
        alerta.setEstado(estadoNuevo);
        if(comentario!=null) {
            alerta.setComentario(comentario);
        }
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
