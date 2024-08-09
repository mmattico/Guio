package com.guio.guio.repositorio;

import com.guio.guio.dao.NodoDAO;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface NodoRepositorio  extends JpaRepository<NodoDAO, Long> {

    @Query("SELECT n FROM NodoDAO n WHERE n.nombre = :nombre AND n.grafo.codigo = :ubicacion")
    List<NodoDAO> findNodosByNombreAndGrafoUbicacion(@Param("nombre") String nombre, @Param("ubicacion") String ubicacion);

    @Query("SELECT n FROM NodoDAO n WHERE n.tipo = :tipo AND n.grafo.codigo = :ubicacion")
    List<NodoDAO> findNodosByGrafoUbicacionAndTipo(@Param("ubicacion") String ubicacion, @Param("tipo") String tipo);
}
