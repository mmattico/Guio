package com.guio.guio.summary;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.guio.guio.dao.UsuarioDAO;

import javax.persistence.*;
import java.time.LocalDateTime;

public interface AlertaSummary {
    Long getAlertaID();
    LocalDateTime getFecha();
    String getComentario();
    String getLugarDeAlerta();
    String getEstado();
    String getNombre();
    String getApellido();
    String getDni();
    String getTelefono();

}
