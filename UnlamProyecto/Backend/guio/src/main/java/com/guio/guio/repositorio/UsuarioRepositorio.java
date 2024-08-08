package com.guio.guio.repositorio;

import com.guio.guio.dao.UsuarioDAO;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface UsuarioRepositorio extends JpaRepository<UsuarioDAO, Long> {
    Optional<UsuarioDAO> findUsuarioDAOByUsuario(String usuario);
    Optional<UsuarioDAO> findByUsuario(String usuario);
    Optional<UsuarioDAO> findByDni(String dni);
    Optional<UsuarioDAO> findByEmail(String email);
}
