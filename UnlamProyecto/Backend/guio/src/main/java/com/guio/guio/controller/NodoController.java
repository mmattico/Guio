package com.guio.guio.controller;

import com.guio.guio.dao.NodoDAO;
import com.guio.guio.service.NodoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("/api/nodos")
public class NodoController {

    @Autowired
    private NodoService nodoService;

    @PostMapping
    public NodoDAO createNodo(@RequestBody NodoDAO Nodo) {
        return nodoService.saveNode(Nodo);
    }

    @GetMapping("/{id}")
    public Optional<NodoDAO> getNodo(@PathVariable Long id) {
        return nodoService.getNodeById(id);
    }

    @DeleteMapping("/{id}")
    public void deleteNodo(@PathVariable Long id) {
        nodoService.deleteNode(id);
    }

    @GetMapping
    public List<NodoDAO> getAllNodes() {
        return nodoService.getAllNodes();
    }

    @GetMapping("/extremos/{ubicacion}")
    public List<NodoDAO> getAllNodesExtremos(@PathVariable String ubicacion) {
        return nodoService.getAllNodesExtremos(ubicacion);
    }

    //http://localhost:8080/api/nodos/desactivar/1/PRUEBA
    @PutMapping("/desactivar/{nombre}/{ubicacion}")
    public ResponseEntity<?> desactivarNodo(@PathVariable String nombre, @PathVariable String ubicacion) {
        List<NodoDAO> nodos = nodoService.getNodeByNombreYUbicacionGrafo(nombre, ubicacion);
        for (NodoDAO nodo: nodos){
            nodo.setActivo(false);
            nodoService.saveNode(nodo);
        }
        return new ResponseEntity<>("Se desactivo", HttpStatus.OK);
    }

    @PutMapping("/activar/{nombre}/{ubicacion}")
    public ResponseEntity<?> activarNodo(@PathVariable String nombre, @PathVariable String ubicacion) {
        List<NodoDAO> nodos = nodoService.getNodeByNombreYUbicacionGrafo(nombre, ubicacion);
        for (NodoDAO nodo: nodos){
            nodo.setActivo(true);
            nodoService.saveNode(nodo);
        }
        return new ResponseEntity<>("Se activo", HttpStatus.OK);
    }
}
