package com.guio.guio.controller;

import com.guio.guio.dao.NodoDAO;
import com.guio.guio.service.NodoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("/api/nodos")
public class NodoController {

    @Autowired
    private NodoService nodoService;

    //http://localhost:8080/api/nodos/desactivar/1/PRUEBA
    @GetMapping("/desactivar/{nombre}/{ubicacion}")
    public ResponseEntity<?> desactivarNodo(@PathVariable String nombre, @PathVariable String ubicacion) {
        List<NodoDAO> nodos = nodoService.getNodeByNombreYUbicacionGrafo(nombre, ubicacion);
        for (NodoDAO nodo: nodos){
            nodo.setActivo(false);
            nodoService.saveNode(nodo);
        }
        return new ResponseEntity<>("Se desactivo", HttpStatus.OK);
    }

    @GetMapping("/activar/{nombre}/{ubicacion}")
    public ResponseEntity<?> activarNodo(@PathVariable String nombre, @PathVariable String ubicacion) {
        List<NodoDAO> nodos = nodoService.getNodeByNombreYUbicacionGrafo(nombre, ubicacion);
        for (NodoDAO nodo: nodos){
            nodo.setActivo(true);
            nodoService.saveNode(nodo);
        }
        return new ResponseEntity<>("Se activo", HttpStatus.OK);
    }
}
