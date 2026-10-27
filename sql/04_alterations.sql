-- =====================================================================
-- TP N° 1 SQL — Biblioteca universitaria
-- 04_alterations.sql: modificaciones posteriores al esquema
-- El TP no pide alteraciones; se agregan restricciones que protegen los datos.
-- =====================================================================
USE BIBLIOTECA_UNI;

-- La edad no puede ser negativa.
ALTER TABLE ESTUDIANTES
ADD CONSTRAINT CHK_EST_EDAD CHECK (EDAD >= 0);

ALTER TABLE FUNCIONARIOS
ADD CONSTRAINT CHK_FUNC_EDAD CHECK (EDAD >= 0);

-- La fecha de entrega no puede ser anterior a la de préstamo.
ALTER TABLE PRESTAMO
ADD CONSTRAINT CHK_PRESTAMO_FECHAS CHECK (FECHA_E IS NULL OR FECHA_E >= FECHA_P);
