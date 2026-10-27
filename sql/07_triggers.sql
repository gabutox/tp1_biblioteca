-- =====================================================================
-- TP N° 1 SQL — Biblioteca universitaria
-- 07_triggers.sql: SECCIÓN 5 — Triggers
--
-- DELIMITER // cambia el fin de sentencia a "//" para que los ";" de
-- adentro del BEGIN ... END no corten el CREATE TRIGGER antes de tiempo.
-- (En DBeaver también se puede seleccionar el bloque y ejecutarlo con Ctrl+Enter.)
-- =====================================================================
USE BIBLIOTECA_UNI;

-- 1. Auditoría de préstamos ------------------------------------------

-- Primero la tabla donde el trigger va a dejar el registro.
CREATE TABLE IF NOT EXISTS AUDITORIA_PRESTAMOS (
    ID_AUDITORIA   INT AUTO_INCREMENT PRIMARY KEY,
    RUT_EST        VARCHAR(12),
    COD_LIBRO      INT,
    FECHA_REGISTRO DATETIME,
    ACCION         VARCHAR(50)
);

DROP TRIGGER IF EXISTS TR_AUDITAR_PRESTAMO;

DELIMITER //
-- AFTER INSERT: se ejecuta después de que el préstamo ya quedó guardado.
-- NEW.columna = el valor de la fila que se acaba de insertar.
CREATE TRIGGER TR_AUDITAR_PRESTAMO
AFTER INSERT ON PRESTAMO
FOR EACH ROW
BEGIN
    INSERT INTO AUDITORIA_PRESTAMOS (RUT_EST, COD_LIBRO, FECHA_REGISTRO, ACCION)
    VALUES (NEW.RUT_EST, NEW.COD_LIBRO, NOW(), 'NUEVO PRÉSTAMO');
END //
DELIMITER ;

-- 2. Validar la edad del estudiante ----------------------------------
-- MySQL no permite un trigger para INSERT y UPDATE a la vez: se crean dos
-- con la misma validación. BEFORE porque hay que frenar el dato ANTES
-- de que se guarde. SIGNAL lanza el error y cancela la operación.

DROP TRIGGER IF EXISTS TR_VALIDAR_EDAD_ESTUDIANTE_INS;
DROP TRIGGER IF EXISTS TR_VALIDAR_EDAD_ESTUDIANTE_UPD;

DELIMITER //
CREATE TRIGGER TR_VALIDAR_EDAD_ESTUDIANTE_INS
BEFORE INSERT ON ESTUDIANTES
FOR EACH ROW
BEGIN
    IF NEW.EDAD < 17 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: El estudiante debe ser mayor de edad para registrarse';
    END IF;
END //

CREATE TRIGGER TR_VALIDAR_EDAD_ESTUDIANTE_UPD
BEFORE UPDATE ON ESTUDIANTES
FOR EACH ROW
BEGIN
    IF NEW.EDAD < 17 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: El estudiante debe ser mayor de edad para registrarse';
    END IF;
END //
DELIMITER ;

-- Pruebas (descomentar para probar):
-- INSERT INTO PRESTAMO VALUES ('21444555-6', '13222333-2', 107, CURDATE(), NULL);
-- SELECT * FROM AUDITORIA_PRESTAMOS;                    -- aparece 'NUEVO PRÉSTAMO'
-- INSERT INTO ESTUDIANTES VALUES ('23000111-2', 'Tomás', 'Paz', 16, NULL, NULL, 1);  -- error
-- UPDATE ESTUDIANTES SET EDAD = 15 WHERE RUT_EST = '20111222-3';                     -- error
