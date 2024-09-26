package com.guio.guio.service;

import com.guio.guio.dao.UsuarioDAO;
import com.guio.guio.model.Usuario;
import com.guio.guio.repositorio.UsuarioRepositorio;
import org.apache.commons.text.RandomStringGenerator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.Column;
import java.util.List;
import java.util.Optional;

@Service
public class UsuarioService {

    @Autowired
    private JavaMailSender emailSender;

    @Autowired
    private UsuarioRepositorio userRepository;


    public UsuarioDAO save(UsuarioDAO user) {
        return userRepository.save(user);
    }

    public UsuarioDAO findByUsername(String username) {
        UsuarioDAO usuario = userRepository.findUsuarioDAOByUsuario(username).get();
        if(usuario.getGrafo()!= null)
            usuario.setGrafo_Id(usuario.getGrafo().getGrafoID());
        return usuario;
    }

    public UsuarioDAO findByEmail(String email) {
        UsuarioDAO usuario = userRepository.findByEmail(email).get();
        if(usuario.getGrafo()!= null)
            usuario.setGrafo_Id(usuario.getGrafo().getGrafoID());
        return usuario;
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

    @Transactional
    public boolean actualizarPassword(Long idUsuario, String contraseña){
        Optional<UsuarioDAO> optionalUsuario = userRepository.findById(idUsuario);
        if (optionalUsuario.isPresent()) {
            UsuarioDAO usuario = optionalUsuario.get();
            usuario.setContraseña(contraseña);
            usuario.setContraseñaReseteada(false);
            userRepository.save(usuario);
            return true;
        } else {
            return false;
        }
    }

    public void resetPassword(String emailUsuario) {
        String contraseña = generatePassword();
        UsuarioDAO usuario = userRepository.findByEmail(emailUsuario).orElseThrow(() -> new RuntimeException("Usuario no encontrado"));
        usuario.setContraseña(contraseña);
        usuario.setContraseñaReseteada(true);
        userRepository.save(usuario);

        String subject = "Solicitud de reseteo de contraseña";
        String message = "Su nueva contraseña es: " + contraseña + " por favor acordarse de cambiarla al iniciar sesion";

        sendEmail(usuario.getEmail(), subject, message);
    }

    public void sendEmail(String to, String subject, String text) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(to);
        message.setSubject(subject);
        message.setText(text);
        emailSender.send(message);
    }

    private static String generatePassword() {
        RandomStringGenerator generator = new RandomStringGenerator.Builder()
                .withinRange('0', 'z')
                .filteredBy(Character::isLetterOrDigit) // Puedes ajustar el filtrado según tus necesidades
                .build();

        return generator.generate(12); // Ajusta la longitud de la contraseña
    }

    public Optional<UsuarioDAO> actualizarUsuario(Long id, Usuario actualizacion) {
        return userRepository.findById(id)
                .map(usuario -> {
                    usuario.setNombre(actualizacion.getNombre());
                    usuario.setApellido(actualizacion.getApellido());
                    usuario.setEmail(actualizacion.getEmail());
                    usuario.setTelefono(actualizacion.getTelefono());
                    usuario.setDni(actualizacion.getDni());
                    usuario.setUsuario(actualizacion.getUsuario());
                    usuario.setContraseña(actualizacion.getContraseña());
                    usuario.setContraseñaReseteada(false);
                    usuario.setAccesibilidadDefault(actualizacion.isAccesibilidadDefault());
                    return userRepository.save(usuario);
                });
    }
}
