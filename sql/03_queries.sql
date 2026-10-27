-- =====================================================================
-- TP N° 1 SQL — Biblioteca universitaria
-- 03_queries.sql: SECCIÓN 2 (consultas SELECT) y SECCIÓN 3 (DML)
-- =====================================================================
USE BIBLIOTECA_UNI;

-- ---------------------------------------------------------------------
-- SECCIÓN 2 — Consultas SELECT
-- ---------------------------------------------------------------------

-- 1. Título y año de todos los libros, del más antiguo al más nuevo.
--    ORDER BY ... ASC (ascendente es el valor por defecto).
SELECT TITULO, AGNO
FROM LIBROS
ORDER BY AGNO ASC;

-- 2. Nombre, apellido y edad de los estudiantes mayores de 25 años.
SELECT NOMBRES, APELLIDOS, EDAD
FROM ESTUDIANTES
WHERE EDAD > 25;

-- 3. Título y año de los libros de la editorial con ID_EDIT = 3.
SELECT TITULO, AGNO
FROM LIBROS
WHERE ID_EDIT = 3;

-- 4. Todos los datos de los autores cuyo apellido empieza con "M".
--    LIKE 'M%': la M seguida de cualquier cosa.
SELECT *
FROM AUTORES
WHERE APELLIDOS LIKE 'M%';

-- 5. Funcionarios con salud distinta a "Buena".
--    <> (o !=) significa "distinto de".
SELECT NOMBRES, APELLIDOS
FROM FUNCIONARIOS
WHERE SALUD <> 'Buena';

-- 6. Título del libro con nombre y apellido de su autor.
SELECT l.TITULO, a.NOMBRES, a.APELLIDOS
FROM LIBROS l
JOIN AUTORES a ON l.RUT_AUTOR = a.RUT_AUTOR;

-- 7. Fecha de préstamo, estudiante, libro y funcionario que atendió.
--    PRESTAMO es la tabla central: se une con las otras tres.
--    CONCAT_WS(' ', a, b) junta los textos separados por un espacio.
SELECT p.FECHA_P,
       CONCAT_WS(' ', e.NOMBRES, e.APELLIDOS) AS ESTUDIANTE,
       l.TITULO,
       CONCAT_WS(' ', f.NOMBRES, f.APELLIDOS) AS FUNCIONARIO
FROM PRESTAMO p
JOIN ESTUDIANTES  e ON p.RUT_EST   = e.RUT_EST
JOIN LIBROS       l ON p.COD_LIBRO = l.COD_LIBRO
JOIN FUNCIONARIOS f ON p.RUT_FUNC  = f.RUT_FUNC;

-- 8. Estudiante, su carrera y la ciudad donde estudia.
--    Camino: ESTUDIANTES -> CARRERAS -> CAMPUS -> CIUDAD.
SELECT e.NOMBRES, e.APELLIDOS, ca.NOMBRE AS CARRERA, ci.NOMBRE AS CIUDAD
FROM ESTUDIANTES e
JOIN CARRERAS ca ON e.ID_CARRERA = ca.ID_CARRERA
JOIN CAMPUS   cp ON ca.ID_CAMPUS = cp.ID_CAMPUS
JOIN CIUDAD   ci ON cp.ID_CIUDAD = ci.ID_CIUDAD;

-- 9. Títulos con el nombre de la editorial y su país.
SELECT l.TITULO, ed.NOMBRE AS EDITORIAL, ed.PAIS
FROM LIBROS l
JOIN EDITORIALES ed ON l.ID_EDIT = ed.ID_EDIT;

-- 10. Título del libro y la biblioteca donde está físicamente.
SELECT l.TITULO, b.BIBLIOTECA
FROM LIBROS l
JOIN BIBLIOTECA b ON l.ID_BIBLIO = b.ID_BIBLIO;

-- 11. Cantidad de libros por tipo.
--     GROUP BY junta los libros del mismo tipo; COUNT(*) los cuenta.
SELECT t.TIPO_P, COUNT(*) AS CANTIDAD
FROM LIBROS l
JOIN TIPO t ON l.ID_TIPO = t.ID_TIPO
GROUP BY t.ID_TIPO, t.TIPO_P;

-- 12. Edad promedio de los estudiantes por carrera.
SELECT ca.NOMBRE AS CARRERA, AVG(e.EDAD) AS EDAD_PROMEDIO
FROM ESTUDIANTES e
JOIN CARRERAS ca ON e.ID_CARRERA = ca.ID_CARRERA
GROUP BY ca.ID_CARRERA, ca.NOMBRE;

-- 13. Funcionario y cantidad de préstamos que realizó, de mayor a menor.
SELECT f.NOMBRES, f.APELLIDOS, COUNT(*) AS TOTAL_PRESTAMOS
FROM PRESTAMO p
JOIN FUNCIONARIOS f ON p.RUT_FUNC = f.RUT_FUNC
GROUP BY f.RUT_FUNC, f.NOMBRES, f.APELLIDOS
ORDER BY TOTAL_PRESTAMOS DESC;

-- 14. Autores con más de 1 libro.
--     La condición es sobre un COUNT, por eso va en HAVING y no en WHERE.
SELECT a.NOMBRES, a.APELLIDOS, COUNT(*) AS CANTIDAD_LIBROS
FROM AUTORES a
JOIN LIBROS l ON l.RUT_AUTOR = a.RUT_AUTOR
GROUP BY a.RUT_AUTOR, a.NOMBRES, a.APELLIDOS
HAVING COUNT(*) > 1;

-- 15. Ciudad y cantidad de estudiantes.
--     ESTUDIANTES no tiene ciudad propia: se toma la ciudad del campus de su
--     carrera (ESTUDIANTES -> CARRERAS -> CAMPUS -> CIUDAD).
SELECT ci.NOMBRE AS CIUDAD, COUNT(*) AS CANTIDAD_ESTUDIANTES
FROM ESTUDIANTES e
JOIN CARRERAS ca ON e.ID_CARRERA = ca.ID_CARRERA
JOIN CAMPUS   cp ON ca.ID_CAMPUS = cp.ID_CAMPUS
JOIN CIUDAD   ci ON cp.ID_CIUDAD = ci.ID_CIUDAD
GROUP BY ci.ID_CIUDAD, ci.NOMBRE;

-- 16. Título y año del libro más antiguo.
--     Opción A: ordenar por año y quedarse con el primero.
SELECT TITULO, AGNO
FROM LIBROS
ORDER BY AGNO ASC
LIMIT 1;

--     Opción B (subconsulta escalar): el año tiene que ser igual al mínimo.
--     Ventaja: si hay empate, muestra todos los libros de ese año.
SELECT TITULO, AGNO
FROM LIBROS
WHERE AGNO = (SELECT MIN(AGNO) FROM LIBROS);

-- 17. Estudiantes que nunca pidieron un libro.
--     Opción A: LEFT JOIN trae a todos los estudiantes; los que no tienen
--     préstamo quedan con las columnas de PRESTAMO en NULL.
SELECT e.NOMBRES, e.APELLIDOS
FROM ESTUDIANTES e
LEFT JOIN PRESTAMO p ON p.RUT_EST = e.RUT_EST
WHERE p.RUT_EST IS NULL;

--     Opción B (subconsulta correlacionada con NOT EXISTS).
SELECT e.NOMBRES, e.APELLIDOS
FROM ESTUDIANTES e
WHERE NOT EXISTS (
    SELECT 1 FROM PRESTAMO p
    WHERE p.RUT_EST = e.RUT_EST
);

-- 18. Libros nunca prestados (no aparecen en PRESTAMO).
--     Opción A: LEFT JOIN ... IS NULL.
SELECT l.TITULO
FROM LIBROS l
LEFT JOIN PRESTAMO p ON p.COD_LIBRO = l.COD_LIBRO
WHERE p.COD_LIBRO IS NULL;

--     Opción B (subconsulta multifila con NOT IN).
SELECT TITULO
FROM LIBROS
WHERE COD_LIBRO NOT IN (SELECT COD_LIBRO FROM PRESTAMO);

-- 19. Préstamos realizados el mes anterior.
--     Se compara mes Y año con la fecha de hoy menos un mes.
SELECT *
FROM PRESTAMO
WHERE YEAR(FECHA_P)  = YEAR(CURDATE() - INTERVAL 1 MONTH)
  AND MONTH(FECHA_P) = MONTH(CURDATE() - INTERVAL 1 MONTH);

-- 20. Los 3 libros más prestados.
SELECT l.TITULO, COUNT(*) AS VECES_PRESTADO
FROM PRESTAMO p
JOIN LIBROS l ON p.COD_LIBRO = l.COD_LIBRO
GROUP BY l.COD_LIBRO, l.TITULO
ORDER BY VECES_PRESTADO DESC
LIMIT 3;

-- ---------------------------------------------------------------------
-- SECCIÓN 3 — Operaciones DML
-- ---------------------------------------------------------------------

-- 1. Nuevo estudiante, en una carrera existente (1 = Ingeniería en Informática).
INSERT INTO ESTUDIANTES (RUT_EST, NOMBRES, APELLIDOS, EDAD, FONO, DIRECCION, ID_CARRERA)
VALUES ('22888999-0', 'Camila', 'Rojas', 18, '2644556677', 'Entre Ríos 640', 1);

-- 2. SALUD = 'Excelente' para los funcionarios de más de 50 años.
UPDATE FUNCIONARIOS
SET SALUD = 'Excelente'
WHERE EDAD > 50;

-- 3. Borrar un libro sin préstamos (110 = Bestiario).
--    Si tuviera préstamos, la FK de PRESTAMO no dejaría borrarlo.
DELETE FROM LIBROS
WHERE COD_LIBRO = 110;

-- 4. Cambio de editorial de un libro (Santa Evita pasa a Alfaguara).
UPDATE LIBROS
SET ID_EDIT = 3
WHERE COD_LIBRO = 109;
