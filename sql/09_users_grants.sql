-- =====================================================================
-- TP N° 1 SQL — Biblioteca universitaria
-- 09_users_grants.sql: SECCIÓN 7 — Usuarios y permisos
-- GRANT da permisos, REVOKE los quita. Formato: base.tabla (o base.* = todas).
-- =====================================================================

-- 1. Usuario bibliotecario con contraseña segura.
CREATE USER IF NOT EXISTS 'bibliotecario_user'@'localhost' IDENTIFIED BY 'Biblio#2026_Seguro';

-- 2. Solo lectura sobre LIBROS, AUTORES y EDITORIALES.
GRANT SELECT ON BIBLIOTECA_UNI.LIBROS      TO 'bibliotecario_user'@'localhost';
GRANT SELECT ON BIBLIOTECA_UNI.AUTORES     TO 'bibliotecario_user'@'localhost';
GRANT SELECT ON BIBLIOTECA_UNI.EDITORIALES TO 'bibliotecario_user'@'localhost';

-- 3. Lectura y escritura sobre PRESTAMO.
GRANT SELECT, INSERT, UPDATE, DELETE ON BIBLIOTECA_UNI.PRESTAMO TO 'bibliotecario_user'@'localhost';

-- 4. Administrador con todos los privilegios sobre la base completa.
CREATE USER IF NOT EXISTS 'admin_user'@'localhost' IDENTIFIED BY 'Admin#2026_Seguro';
GRANT ALL PRIVILEGES ON BIBLIOTECA_UNI.* TO 'admin_user'@'localhost';

-- 5. Quitarle al bibliotecario el DELETE sobre PRESTAMO.
REVOKE DELETE ON BIBLIOTECA_UNI.PRESTAMO FROM 'bibliotecario_user'@'localhost';

-- Verificación:
SHOW GRANTS FOR 'bibliotecario_user'@'localhost';
SHOW GRANTS FOR 'admin_user'@'localhost';
