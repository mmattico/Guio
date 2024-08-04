package com.guio.guio.controller;

import com.guio.guio.dao.UsuarioDAO;
import com.guio.guio.service.UsuarioService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("/api/users")
public class UsuarioController {

    @Autowired
    private UsuarioService userService;

    @PostMapping
    public UsuarioDAO createUser(@RequestBody UsuarioDAO user) {
        return userService.save(user);
    }

    @GetMapping("/{username}")
    public UsuarioDAO getUser(@PathVariable String username) {
        return userService.findByUsername(username);
    }

    @DeleteMapping("/{id}")
    public void deleteUser(@PathVariable Long id) {
        userService.delete(id);
    }

    @GetMapping
    public List<UsuarioDAO> getAllUsers() {
        return userService.findAll();
    }

}
