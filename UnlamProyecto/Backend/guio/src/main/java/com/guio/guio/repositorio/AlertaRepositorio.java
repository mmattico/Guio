package com.guio.guio.repositorio;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.guio.guio.dao.AlertaDAO;
import com.guio.guio.dao.NodoDAO;
import com.guio.guio.dao.UsuarioDAO;
import com.guio.guio.summary.AlertaSummary;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import javax.persistence.Column;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import java.time.LocalDateTime;
import java.util.List;

public interface AlertaRepositorio extends JpaRepository<AlertaDAO, Long> {

    @Query(value = "SELECT a.AlertaID as AlertaID, " +
                        "a.Fecha as Fecha, " +
                        "a.Comentario as Comentario, " +
                        "a.lugar_de_alerta as LugarDeAlerta, " +
                        "a.Estado as Estado, " +
                        "u.Nombre as Nombre, " +
                        "u.Apellido as Apellido, " +
                        "u.Dni as Dni, " +
                        "u.Telefono as Telefono " +
                    "FROM BSAlerta as a " +
                    "INNER JOIN BSUsuario as u ON u.UsuarioID = a.UsuarioID " +
                    "INNER JOIN BSGrafo as g on g.GrafoID = a.GrafoID " +
                    "WHERE g.Codigo = ?1", nativeQuery = true)
    List<AlertaSummary> findByGrafoUbicacion(@Param("ubicacion") String ubicacion);
}
