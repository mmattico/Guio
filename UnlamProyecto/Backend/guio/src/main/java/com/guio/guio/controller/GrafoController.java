package com.guio.guio.controller;

import com.guio.guio.dao.GrafoDAO;
import com.guio.guio.service.GrafoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("/api/grafo")
public class GrafoController {

    @Autowired
    private GrafoService grafoService;

    @PostMapping
    public GrafoDAO createGrafo(@RequestBody GrafoDAO grafo) {
        return grafoService.save(grafo);
    }

    @GetMapping("/{codigo}")
    public GrafoDAO getGrafo(@PathVariable String codigo) {
        return grafoService.findByCodigo(codigo);
    }

    @DeleteMapping("/{id}")
    public void deleteGrafo(@PathVariable Long id) {
        grafoService.delete(id);
    }

    @GetMapping
    public List<GrafoDAO> getAllGrafos() {
        return grafoService.findAll();
    }

    @PutMapping("/actualizarNorte/{codigo}/{grados}")
    public ResponseEntity<?> actualizarNorte(@PathVariable String codigo, @PathVariable Integer grados) {
        GrafoDAO grafo = grafoService.findByCodigo(codigo);
        grafo.setNorteGrado(grados);
        grafoService.save(grafo);
        return new ResponseEntity<>("Se desactivo", HttpStatus.OK);
    }

}
