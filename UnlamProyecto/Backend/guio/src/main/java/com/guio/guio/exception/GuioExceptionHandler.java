package com.guio.guio.exception;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
public class GuioExceptionHandler {

    @ExceptionHandler(Exception.class)
    public ResponseEntity<Object> manejoDeErrores(Exception ex){
        ex.printStackTrace();
        GuioException exception = new GuioException(ex,HttpStatus.INTERNAL_SERVER_ERROR.value());
        return new ResponseEntity<Object>(exception, HttpStatus.INTERNAL_SERVER_ERROR);
    }
}
