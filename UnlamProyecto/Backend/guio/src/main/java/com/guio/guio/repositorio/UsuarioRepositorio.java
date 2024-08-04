package com.guio.guio.repositorio;

import com.guio.guio.dao.UsuarioDAO;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UsuarioRepositorio extends JpaRepository<UsuarioDAO, Long> {
    UsuarioDAO findByUsuario(String usuario);
}
