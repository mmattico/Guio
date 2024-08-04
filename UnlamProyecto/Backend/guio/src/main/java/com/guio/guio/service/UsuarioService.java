package com.guio.guio.service;

import com.guio.guio.dao.UsuarioDAO;
import com.guio.guio.repositorio.UsuarioRepositorio;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UsuarioService {

    @Autowired
    private UsuarioRepositorio userRepository;

    public UsuarioDAO save(UsuarioDAO user) {
        return userRepository.save(user);
    }

    public UsuarioDAO findByUsername(String username) {
        return userRepository.findByUsuario(username);
    }

    public void delete(Long id) {
        userRepository.deleteById(id);
    }

    public List<UsuarioDAO> findAll() {
        return userRepository.findAll();
    }
}
