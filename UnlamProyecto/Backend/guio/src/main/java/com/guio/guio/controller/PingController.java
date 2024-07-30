package com.guio.guio.controller;

import com.guio.guio.model.Ping;
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
public class PingController {

    @GetMapping(value = "/ping", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<?> ping (){
        Ping ping = new Ping();
        ping.setMensaje("OK");
        ping.setStatus(String.valueOf(HttpStatus.OK));
        return new ResponseEntity<>(ping, HttpStatus.OK);
    }
}
