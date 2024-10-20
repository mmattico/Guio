package com.guio.guio.controller;

import com.guio.guio.model.Version;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@CrossOrigin("*")
@RequestMapping("/api")
public class VersionController {
    @GetMapping(value = "/version", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<?> version (){
        Version version = new Version();
        version.setMensaje("OK");
        version.setVersion("1.0.0.41");
        return new ResponseEntity<>(version, HttpStatus.OK);
    }
}
