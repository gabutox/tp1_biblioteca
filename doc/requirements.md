# TP N° 1 — Modelo de datos: Biblioteca universitaria

## De qué se trata

El modelo representa el **sistema de préstamos de libros de una universidad**. Registra lo siguiente:

- **Estudiantes:** a qué carrera pertenecen, y a través de ella, en qué campus y ciudad estudian.
- **Funcionarios:** los que atienden en cada campus.
- **Libros:** su autor, editorial, tipo y la biblioteca donde están físicamente.
- **Préstamos:** qué estudiante se llevó qué libro, qué funcionario lo atendió, y cuándo se prestó y se devolvió.

Base de datos: `BIBLIOTECA_UNI` (MySQL 8).

## Entidades

| Tabla | Representa | Clave primaria |
|---|---|---|
| CIUDAD | Ciudades donde hay sedes | ID_CIUDAD |
| CAMPUS | Sedes de la universidad | ID_CAMPUS |
| CARRERAS | Carreras que se dictan en cada campus | ID_CARRERA |
| ESTUDIANTES | Alumnos que piden libros | RUT_EST |
| FUNCIONARIOS | Personal que registra los préstamos | RUT_FUNC |
| AUTORES | Autores de los libros | RUT_AUTOR |
| EDITORIALES | Editoriales y su país | ID_EDIT |
| BIBLIOTECA | Bibliotecas físicas | ID_BIBLIO |
| TIPO | Género o tipo del libro (Novela, Poesía…) | ID_TIPO |
| LIBROS | Catálogo de libros | COD_LIBRO |
| PRESTAMO | Préstamo de un libro a un estudiante | (RUT_EST, RUT_FUNC, COD_LIBRO) |

## Relaciones y su relación inversa

| Relación | Cardinalidad | Lectura directa | Relación inversa |
|---|---|---|---|
| CIUDAD – CAMPUS | 1:N | Un campus está en una ciudad | Una ciudad tiene muchos campus |
| CAMPUS – CARRERAS | 1:N | Una carrera se dicta en un campus | Un campus dicta muchas carreras |
| CAMPUS – FUNCIONARIOS | 1:N | Un funcionario trabaja en un campus | Un campus tiene muchos funcionarios |
| CARRERAS – ESTUDIANTES | 1:N | Un estudiante cursa una carrera | Una carrera tiene muchos estudiantes |
| AUTORES – LIBROS | 1:N | Un libro tiene un autor | Un autor escribió muchos libros |
| EDITORIALES – LIBROS | 1:N | Un libro es de una editorial | Una editorial publica muchos libros |
| BIBLIOTECA – LIBROS | 1:N | Un libro está en una biblioteca | Una biblioteca tiene muchos libros |
| TIPO – LIBROS | 1:N | Un libro es de un tipo | Un tipo agrupa muchos libros |
| ESTUDIANTES – PRESTAMO | 1:N | Un préstamo es de un estudiante | Un estudiante tiene muchos préstamos |
| FUNCIONARIOS – PRESTAMO | 1:N | Un préstamo lo atiende un funcionario | Un funcionario atiende muchos préstamos |
| LIBROS – PRESTAMO | 1:N | Un préstamo es de un libro | Un libro se presta muchas veces |

PRESTAMO resuelve una relación **muchos a muchos entre ESTUDIANTES y LIBROS**: un estudiante pide muchos libros y un libro lo piden muchos estudiantes. Además registra al funcionario que atendió.

## Requerimientos funcionales

1. Registrar ciudades, campus y las carreras que se dictan en cada campus.
2. Registrar estudiantes con sus datos personales y su carrera.
3. Registrar funcionarios con su edad, estado de salud y campus.
4. Mantener el catálogo de libros: título, año, autor, editorial, tipo y biblioteca.
5. Registrar préstamos con fecha de préstamo y de entrega, indicando estudiante, libro y funcionario (procedimiento `SP_REGISTRAR_PRESTAMO`).
6. Impedir prestar un libro que ya está prestado.
7. Consultar préstamos, libros más prestados, libros nunca prestados, estudiantes sin préstamos y estadísticas por carrera, ciudad, tipo y autor.
8. Dejar una auditoría de cada préstamo nuevo (trigger `TR_AUDITAR_PRESTAMO`).
9. Rechazar estudiantes menores de 17 años (triggers `TR_VALIDAR_EDAD_ESTUDIANTE_*`).

## Requerimientos no funcionales

1. **Integridad referencial:** todas las relaciones con claves foráneas; no se puede borrar un dato que otro usa (por ejemplo, un libro con préstamos).
2. **Seguridad:** acceso con usuarios y permisos mínimos. El bibliotecario solo lee el catálogo y gestiona préstamos (sin borrar); el administrador tiene control total.
3. **Rendimiento:** índices sobre fecha de préstamo, año del libro y apellido del autor.
4. **Trazabilidad:** registro automático con fecha y hora de cada préstamo nuevo.
5. **Portabilidad:** el motor corre en Docker (`docker-compose.yml` + `.env`) y los scripts se ejecutan en orden numérico.
6. **Consistencia de datos:** restricciones `CHECK` (edad no negativa, fecha de entrega posterior a la de préstamo).
