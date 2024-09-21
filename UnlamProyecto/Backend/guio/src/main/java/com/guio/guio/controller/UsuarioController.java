package com.guio.guio.controller;

import com.guio.guio.dao.UsuarioDAO;
import com.guio.guio.service.UsuarioService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
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

    @GetMapping("/get-username/{username}")
    public UsuarioDAO getUser(@PathVariable String username) {
        return userService.findByUsername(username);
    }

    @GetMapping("/get-email/{email}")
    public UsuarioDAO getUserByEmail(@PathVariable String email) {
        return userService.findByEmail(email);
    }


    @DeleteMapping("/{id}")
    public void deleteUser(@PathVariable Long id) {
        userService.delete(id);
    }

    @GetMapping
    public List<UsuarioDAO> getAllUsers() {
        return userService.findAll();
    }

    @PostMapping("/reset-password")
    public ResponseEntity<String> resetPassword(@RequestParam(name = "EMAIL") String emailUsuario) {
        userService.resetPassword(emailUsuario);
        return ResponseEntity.ok("Password successfully reset");
    }

    @GetMapping("/validar-nombre-usuario")
    public boolean validarNombreUsuario(@RequestParam(name = "USERNAME") String nombreUsuario) {
        return userService.existeNombreUsuario(nombreUsuario);
    }

    @GetMapping("/validar-documento")
    public boolean validarDocumentoIdentificacion(@RequestParam(name = "DNI") String documentoIdentificacion) {
        return userService.existeDocumentoIdentificacion(documentoIdentificacion);
    }

    @GetMapping("/validar-correo")
    public boolean validarCorreoElectronico(@RequestParam(name = "EMAIL") String correoElectronico) {
        return userService.existeCorreoElectronico(correoElectronico);
    }

    @PutMapping("/actualizar-password")
    public boolean actualizarpassword(@RequestParam Long idUsuario, @RequestParam(name = "PASSWORD") String contraseña) {
        return userService.actualizarPassword(idUsuario, contraseña);
    }

    @PutMapping("/actualizar-email")
    public boolean actualizarCorreoElectronico(@RequestParam Long idUsuario, @RequestParam(name = "EMAIL") String nuevoCorreoElectronico) {
        return userService.actualizarCorreoElectronico(idUsuario, nuevoCorreoElectronico);
    }

    @PutMapping("/actualizar-telefono")
    public boolean actualizarTelefono(@RequestParam Long idUsuario, @RequestParam(name = "TEL") String nuevoTelefono) {
        return userService.actualizarNumeroDeTelefono(idUsuario, nuevoTelefono);
    }

}
