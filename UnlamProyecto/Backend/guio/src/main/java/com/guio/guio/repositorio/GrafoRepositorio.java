package com.guio.guio.repositorio;

import com.guio.guio.dao.GrafoDAO;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;


public interface GrafoRepositorio extends JpaRepository<GrafoDAO, Long> {

    @Query("SELECT g FROM GrafoDAO g WHERE g.codigo = :codigo")
    GrafoDAO findByCodigo(@Param("codigo") String codigo);

}
