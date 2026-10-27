-- =====================================================================
-- TP N° 1 SQL — Biblioteca universitaria
-- 05_indexes.sql: índices para las búsquedas más usadas en las consultas
-- (las PK y FK ya tienen índice automático en MySQL).
-- =====================================================================
USE BIBLIOTECA_UNI;

-- Consulta 19: búsqueda de préstamos por fecha.
CREATE INDEX IDX_PRESTAMO_FECHA_P ON PRESTAMO (FECHA_P);

-- Consultas 1 y 16: orden por año de publicación.
CREATE INDEX IDX_LIBROS_AGNO ON LIBROS (AGNO);

-- Consulta 4: búsqueda de autores por apellido (LIKE 'M%').
CREATE INDEX IDX_AUTORES_APELLIDOS ON AUTORES (APELLIDOS);
