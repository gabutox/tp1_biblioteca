-- =====================================================================
-- TP N° 1 SQL — Biblioteca universitaria
-- 06_views.sql: SECCIÓN 4 — Vistas
-- Una vista es una consulta guardada con nombre: se usa como si fuera
-- una tabla (SELECT * FROM VW_...), pero no guarda datos propios.
-- =====================================================================
USE BIBLIOTECA_UNI;

-- 1. Préstamos en forma "amigable": nombres en lugar de RUTs y códigos.
--    Une 5 tablas: PRESTAMO + ESTUDIANTES + LIBROS + FUNCIONARIOS + CARRERAS.
CREATE OR REPLACE VIEW VW_PRESTAMOS_DETALLE AS
SELECT p.FECHA_P                                AS FECHA_PRESTAMO,
       CONCAT_WS(' ', e.NOMBRES, e.APELLIDOS)   AS ESTUDIANTE,
       l.TITULO                                 AS LIBRO,
       CONCAT_WS(' ', f.NOMBRES, f.APELLIDOS)   AS FUNCIONARIO,
       ca.NOMBRE                                AS CARRERA
FROM PRESTAMO p
JOIN ESTUDIANTES  e  ON p.RUT_EST    = e.RUT_EST
JOIN LIBROS       l  ON p.COD_LIBRO  = l.COD_LIBRO
JOIN FUNCIONARIOS f  ON p.RUT_FUNC   = f.RUT_FUNC
JOIN CARRERAS     ca ON e.ID_CARRERA = ca.ID_CARRERA;

-- 2. Cantidad de libros por biblioteca.
--    "La ciudad donde está (si aplica)": en este modelo BIBLIOTECA no tiene
--    relación con CIUDAD ni con CAMPUS, así que no aplica y no se muestra.
--    LEFT JOIN para que también aparezca una biblioteca sin libros (con 0).
CREATE OR REPLACE VIEW VW_LIBROS_POR_BIBLIOTECA AS
SELECT b.BIBLIOTECA,
       COUNT(l.COD_LIBRO) AS TOTAL_LIBROS
FROM BIBLIOTECA b
LEFT JOIN LIBROS l ON l.ID_BIBLIO = b.ID_BIBLIO
GROUP BY b.ID_BIBLIO, b.BIBLIOTECA;

-- Uso:
SELECT * FROM VW_PRESTAMOS_DETALLE;
SELECT * FROM VW_LIBROS_POR_BIBLIOTECA ORDER BY TOTAL_LIBROS DESC;
