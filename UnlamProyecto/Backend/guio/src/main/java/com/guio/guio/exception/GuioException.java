package com.guio.guio.exception;

public class GuioException {
    private final String error;
    private final String message;
    private final Integer code;

    public GuioException(Exception exception, Integer code) {
        this.error = exception.getClass().getSimpleName();
        this.message = exception.getMessage();
        this.code = code;
    }

    public String getError() {
        return error;
    }

    public String getMessage() {
        return message;
    }

    public Integer getCode() {
        return code;
    }

    @Override
    public String toString() {
        return "ErrorMessage [error=" + error + ", message=" + message + ", code=" + code + "]";
    }

}
