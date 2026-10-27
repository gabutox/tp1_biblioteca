# TP N° 1 — Preguntas teóricas

## 1. ¿Por qué PRESTAMO tiene una clave primaria compuesta? ¿Qué pasa si un estudiante pide el mismo libro dos veces?

PRESTAMO es una tabla intermedia que relaciona tres entidades: ESTUDIANTES, FUNCIONARIOS y LIBROS. Su clave primaria es la combinación de las tres claves foráneas (`RUT_EST`, `RUT_FUNC`, `COD_LIBRO`). Ninguna de ellas sola identifica un préstamo:

- un estudiante pide muchos libros;
- un libro se presta muchas veces;
- un funcionario atiende muchos préstamos.

Lo que identifica al préstamo es la combinación de las tres.

**El problema:** si el mismo estudiante pide el mismo libro dos veces y lo atiende el mismo funcionario, la combinación se repite. La base rechaza el segundo `INSERT` por clave primaria duplicada, aunque las fechas sean distintas.

**Vida real vs. este modelo:**

- **En la vida real** es normal pedir el mismo libro más de una vez (por ejemplo, un mes y después otra vez).
- **Este modelo** solo lo permite si lo atiende otro funcionario, lo cual no tiene sentido como regla.
- **Soluciones habituales:**
  - incluir `FECHA_P` en la clave primaria (`RUT_EST`, `RUT_FUNC`, `COD_LIBRO`, `FECHA_P`);
  - o, mejor, darle a PRESTAMO su propio identificador (`ID_PRESTAMO` autoincremental) y dejar las tres FK como columnas comunes.

## 2. Si intentamos borrar una CARRERA que tiene estudiantes asociados, ¿qué debería hacer la base de datos? ¿Por qué?

Debería **impedir el borrado** (`ON DELETE RESTRICT` / `NO ACTION`, que es el comportamiento por defecto de una FK en MySQL). Si se borrara la carrera, los estudiantes quedarían apuntando a un `ID_CARRERA` que ya no existe. Eso rompe la **integridad referencial**: tendríamos "estudiantes huérfanos".

Las alternativas no convienen:

- `CASCADE` borraría también a todos los estudiantes de esa carrera, y con ellos sus préstamos: una pérdida de datos grave por un solo `DELETE`.
- `SET NULL` dejaría a los estudiantes sin carrera, cuando en el modelo la carrera es obligatoria.

Lo correcto es reasignar o dar de baja a los estudiantes primero, y recién después borrar la carrera.

## 3. ¿Por qué el autor está en una tabla separada (AUTORES) y no directamente en LIBROS?

Por **normalización**: para no repetir datos.

- **Sin repetición:** un autor escribe varios libros. Si sus datos estuvieran en LIBROS, el nombre y apellido se repetirían en cada libro suyo.
- **Cambios en un solo lugar:** si hay que corregir el nombre de un autor, con la tabla aparte se cambia una sola fila. Si estuviera repetido, habría que cambiarlo en todas y se correría el riesgo de que quede distinto en algunas (anomalía de actualización).
- **Autor independiente del libro:** se puede registrar un autor aunque todavía no tenga libros cargados (se evita la anomalía de inserción).
- **Consultas más simples:** se puede consultar "los libros de tal autor" agrupando por `RUT_AUTOR` (consulta 14).

El libro solo guarda la clave foránea `RUT_AUTOR`.

## 4. ¿Qué tipo de relación existe entre CAMPUS y CIUDAD?

Es una relación **uno a muchos (1:N)**: una ciudad tiene muchos campus y cada campus está en una sola ciudad.

Se ve en el modelo porque la clave foránea `ID_CIUDAD` está en CAMPUS, del lado "muchos". Cada fila de CAMPUS guarda una sola ciudad, mientras que el mismo `ID_CIUDAD` se puede repetir en varios campus. En los datos de prueba, San Juan tiene dos campus: Central y Rivadavia.
