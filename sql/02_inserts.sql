-- =====================================================================
-- TP N° 1 SQL — Biblioteca universitaria
-- 02_inserts.sql: datos de prueba
-- Mismo orden que el CREATE: primero las tablas "padre", después las "hijas".
-- Los datos están pensados para que cada consulta del TP devuelva algo.
-- =====================================================================
USE BIBLIOTECA_UNI;

INSERT INTO CIUDAD (ID_CIUDAD, NOMBRE) VALUES
(1, 'San Juan'),
(2, 'Mendoza'),
(3, 'Córdoba');

INSERT INTO CAMPUS (ID_CAMPUS, NOMBRE, ID_CIUDAD) VALUES
(1, 'Campus Central', 1),
(2, 'Campus Rivadavia', 1),
(3, 'Campus Mendoza', 2),
(4, 'Campus Córdoba', 3);

INSERT INTO CARRERAS (ID_CARRERA, NOMBRE, ID_CAMPUS) VALUES
(1, 'Ingeniería en Informática', 1),
(2, 'Abogacía', 2),
(3, 'Medicina', 3),
(4, 'Arquitectura', 4),
(5, 'Contador Público', 1);

INSERT INTO ESTUDIANTES (RUT_EST, NOMBRES, APELLIDOS, EDAD, FONO, DIRECCION, ID_CARRERA) VALUES
('20111222-3', 'Gabriel',   'Alaniz',    22, '2644140309', 'Balcarce 120',       1),
('19222333-4', 'Lucía',     'Fernández', 27, '2644987654', 'Mitre 450',          2),
('18333444-5', 'Martín',    'Gómez',     30, '2615551234', 'Av. San Martín 900', 3),
('21444555-6', 'Sofía',     'Pérez',     19, '2644223344', 'Rivadavia 300',      1),
('17555666-7', 'Diego',     'Torres',    26, '3515557788', 'Colón 980',          4),
('21666777-8', 'Valentina', 'Castro',    20, '2644001122', 'Laprida 55',         5),
('20777888-9', 'Juan',      'Ruiz',      23, '2616662233', 'Las Heras 77',       3);

-- SALUD: 'Buena', 'Regular' o 'Mala'
INSERT INTO FUNCIONARIOS (RUT_FUNC, NOMBRES, APELLIDOS, EDAD, DIRECCION, SALUD, ID_CAMPUS) VALUES
('12111222-1', 'Ana',     'Morales', 54, 'Tucumán 210',  'Buena',   1),
('13222333-2', 'Carlos',  'Díaz',    45, 'Mendoza 1200', 'Regular', 1),
('14333444-3', 'Laura',   'Sánchez', 38, 'Belgrano 15',  'Buena',   3),
('11444555-4', 'Roberto', 'Vega',    58, 'Sarmiento 88', 'Mala',    4);

INSERT INTO AUTORES (RUT_AUTOR, NOMBRES, APELLIDOS) VALUES
('7001001-1', 'Gabriel',    'García Márquez'),
('7002002-2', 'Isabel',     'Allende'),
('7003003-3', 'Jorge Luis', 'Borges'),
('7004004-4', 'Pablo',      'Neruda'),
('7005005-5', 'Julio',      'Cortázar'),
('7006006-6', 'Gabriela',   'Mistral'),
('7007007-7', 'Tomás Eloy', 'Martínez');

INSERT INTO EDITORIALES (ID_EDIT, NOMBRE, PAIS) VALUES
(1, 'Sudamericana', 'Argentina'),
(2, 'Planeta',      'España'),
(3, 'Alfaguara',    'España'),
(4, 'Emecé',        'Argentina');

INSERT INTO BIBLIOTECA (ID_BIBLIO, BIBLIOTECA) VALUES
(1, 'Biblioteca Central'),
(2, 'Biblioteca de Ingeniería'),
(3, 'Biblioteca de Salud');

INSERT INTO TIPO (ID_TIPO, TIPO_P) VALUES
(1, 'Novela'),
(2, 'Poesía'),
(3, 'Cuento'),
(4, 'Ensayo');

INSERT INTO LIBROS (COD_LIBRO, TITULO, AGNO, ID_BIBLIO, ID_TIPO, RUT_AUTOR, ID_EDIT) VALUES
(101, 'Cien años de soledad',                             1967, 1, 1, '7001001-1', 1),
(102, 'El amor en los tiempos del cólera',                1985, 1, 1, '7001001-1', 3),
(103, 'La casa de los espíritus',                         1982, 2, 1, '7002002-2', 2),
(104, 'Ficciones',                                        1944, 1, 3, '7003003-3', 4),
(105, 'El Aleph',                                         1949, 3, 3, '7003003-3', 4),
(106, 'Veinte poemas de amor y una canción desesperada', 1924, 1, 2, '7004004-4', 3),
(107, 'Rayuela',                                          1963, 2, 1, '7005005-5', 1),
(108, 'Desolación',                                       1922, 3, 2, '7006006-6', 3),
(109, 'Santa Evita',                                      1995, 1, 1, '7007007-7', 2),
(110, 'Bestiario',                                        1951, 2, 3, '7005005-5', 1);

-- FECHA_E = fecha en que se devolvió (o se debe devolver). NULL = todavía prestado.
INSERT INTO PRESTAMO (RUT_EST, RUT_FUNC, COD_LIBRO, FECHA_P, FECHA_E) VALUES
('17555666-7', '14333444-3', 102, '2026-06-10', '2026-06-17'),
('17555666-7', '11444555-4', 106, '2026-07-15', '2026-07-22'),
('21444555-6', '12111222-1', 104, '2026-08-05', '2026-08-12'),
('20111222-3', '12111222-1', 101, '2026-09-03', '2026-09-10'),
('19222333-4', '13222333-2', 101, '2026-09-12', '2026-09-19'),
('18333444-5', '14333444-3', 103, '2026-09-20', '2026-09-27'),
('19222333-4', '12111222-1', 107, '2026-09-25', '2026-10-02'),
('20777888-9', '13222333-2', 104, '2026-09-28', '2026-10-05'),
('20777888-9', '14333444-3', 101, '2026-10-02', '2026-10-09'),
('20111222-3', '13222333-2', 103, '2026-10-10', '2026-10-17'),
('18333444-5', '12111222-1', 105, '2026-10-20', NULL);
