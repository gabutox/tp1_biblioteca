-- =====================================================================
-- TP N° 1 SQL — Biblioteca universitaria
-- 08_store_procedures.sql: SECCIÓN 6 — Procedimientos almacenados
-- Un procedimiento es un bloque de código con nombre que se ejecuta con
-- CALL nombre(parámetros). Los parámetros IN son datos de entrada.
-- =====================================================================
USE BIBLIOTECA_UNI;

DROP PROCEDURE IF EXISTS SP_REGISTRAR_PRESTAMO;

DELIMITER //
CREATE PROCEDURE SP_REGISTRAR_PRESTAMO (
    IN p_RUT_EST   VARCHAR(12),
    IN p_COD_LIBRO INT,
    IN p_RUT_FUNC  VARCHAR(12),
    IN p_FECHA_P   DATE
)
BEGIN
    -- a. ¿El libro ya está prestado en esa fecha?
    --    Está prestado si hay un préstamo que empezó antes y todavía no se
    --    devolvió (FECHA_E NULL) o se devuelve después de p_FECHA_P.
    IF EXISTS (
        SELECT 1 FROM PRESTAMO
        WHERE COD_LIBRO = p_COD_LIBRO
          AND FECHA_P <= p_FECHA_P
          AND (FECHA_E IS NULL OR FECHA_E >= p_FECHA_P)
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: el libro ya se encuentra prestado';
    END IF;

    -- b. Regla de negocio: la devolución es 7 días después del préstamo.
    INSERT INTO PRESTAMO (RUT_EST, RUT_FUNC, COD_LIBRO, FECHA_P, FECHA_E)
    VALUES (p_RUT_EST, p_RUT_FUNC, p_COD_LIBRO, p_FECHA_P, p_FECHA_P + INTERVAL 7 DAY);

    -- c. Mensaje de éxito.
    SELECT 'Préstamo registrado correctamente' AS MENSAJE;
END //
DELIMITER ;

-- Pruebas (descomentar para probar):
-- CALL SP_REGISTRAR_PRESTAMO('21666777-8', 108, '12111222-1', CURDATE());  -- OK
-- CALL SP_REGISTRAR_PRESTAMO('20111222-3', 105, '13222333-2', CURDATE());  -- error: 105 está prestado
