package com.guio.guio.repositorio;

import com.guio.guio.dao.AlertaDAO;
import com.guio.guio.dao.NodoDAO;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface AlertaRepositorio extends JpaRepository<AlertaDAO, Long> {

    @Query("SELECT a FROM AlertaDAO a WHERE a.usuario.grafo.codigo = :ubicacion")
    List<AlertaDAO> findByGrafoUbicacion(@Param("ubicacion") String ubicacion);

}
