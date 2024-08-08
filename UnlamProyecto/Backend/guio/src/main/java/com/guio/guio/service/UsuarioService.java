package com.guio.guio.service;

import com.guio.guio.dao.UsuarioDAO;
import com.guio.guio.repositorio.UsuarioRepositorio;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
public class UsuarioService {

    @Autowired
    private UsuarioRepositorio userRepository;

    public UsuarioDAO save(UsuarioDAO user) {
        return userRepository.save(user);
    }

    public UsuarioDAO findByUsername(String username) {
        return userRepository.findUsuarioDAOByUsuario(username).get();
    }

    public boolean existeNombreUsuario(String nombreUsuario) {
        return userRepository.findByUsuario(nombreUsuario).isPresent();
    }

    public boolean existeDocumentoIdentificacion(String documentoIdentificacion) {
        return userRepository.findByDni(documentoIdentificacion).isPresent();
    }

    public boolean existeCorreoElectronico(String correoElectronico) {
        return userRepository.findByEmail(correoElectronico).isPresent();
    }

    public void delete(Long id) {
        userRepository.deleteById(id);
    }

    public List<UsuarioDAO> findAll() {
        return userRepository.findAll();
    }

    @Transactional
    public boolean actualizarCorreoElectronico(Long idUsuario, String nuevoCorreoElectronico) {
        Optional<UsuarioDAO> optionalUsuario = userRepository.findById(idUsuario);
        if (optionalUsuario.isPresent()) {
            UsuarioDAO usuario = optionalUsuario.get();
            usuario.setEmail(nuevoCorreoElectronico);
            userRepository.save(usuario);
            return true;
        } else {
            return false;
        }
    }

    @Transactional
    public boolean actualizarNumeroDeTelefono(Long idUsuario, String nuevoTelefono) {
        Optional<UsuarioDAO> optionalUsuario = userRepository.findById(idUsuario);
        if (optionalUsuario.isPresent()) {
            UsuarioDAO usuario = optionalUsuario.get();
            usuario.setTelefono(nuevoTelefono);
            userRepository.save(usuario);
            return true;
        } else {
            return false;
        }
    }
}
