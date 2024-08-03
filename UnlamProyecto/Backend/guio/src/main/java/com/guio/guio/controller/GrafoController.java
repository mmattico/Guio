package com.guio.guio.controller;

import com.guio.guio.dao.GrafoDAO;
import com.guio.guio.dao.UsuarioDAO;
import com.guio.guio.service.GrafoService;
import com.guio.guio.service.UsuarioService;
import org.springframework.beans.factory.annotation.Autowired;
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
        return grafoService.findByUsername(codigo);
    }

    @DeleteMapping("/{id}")
    public void deleteGrafo(@PathVariable Long id) {
        grafoService.delete(id);
    }

    @GetMapping
    public List<GrafoDAO> getAllGrafos() {
        return grafoService.findAll();
    }

}
