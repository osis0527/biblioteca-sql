-- =============================================
-- EJERCICIO 12 - TRANSACCIONES Y CONTROL DE CONCURRENCIA
-- =============================================

USE biblioteca_db;
SET SQL_SAFE_UPDATES = 0;

-- =============================================
-- TRANSACCIONES BÁSICAS
-- =============================================

-- Transacción exitosa: préstamo de libro
START TRANSACTION;

UPDATE libros SET stock = stock - 1 WHERE id_libro = 1;
INSERT INTO prestamos (nombre_socio, id_libro, fecha_prestamo, devuelto)
VALUES ('Roberto García', 1, CURDATE(), FALSE);

COMMIT;

-- Verificar cambios
SELECT titulo, stock FROM libros WHERE id_libro = 1;
SELECT * FROM prestamos WHERE nombre_socio = 'Roberto García';

-- =============================================
-- TRANSACCIÓN CON ROLLBACK
-- =============================================

-- Transacción fallida: se deshacen los cambios
START TRANSACTION;

UPDATE libros SET stock = stock - 1 WHERE id_libro = 2;
INSERT INTO prestamos (nombre_socio, id_libro, fecha_prestamo, devuelto)
VALUES ('Ana Ruiz', 2, CURDATE(), FALSE);

-- Simulamos un error y deshacemos todo
ROLLBACK;

-- Verificar que no hubo cambios
SELECT titulo, stock FROM libros WHERE id_libro = 2;
SELECT * FROM prestamos WHERE nombre_socio = 'Ana Ruiz';

-- =============================================
-- TRANSACCIÓN CON SAVEPOINT
-- =============================================

START TRANSACTION;

-- Primer cambio
UPDATE libros SET stock = stock - 1 WHERE id_libro = 3;
SAVEPOINT punto1;

-- Segundo cambio
UPDATE libros SET stock = stock - 1 WHERE id_libro = 4;
SAVEPOINT punto2;

-- Tercer cambio con error, volvemos al punto1
UPDATE libros SET stock = stock - 1 WHERE id_libro = 5;
ROLLBACK TO punto1;

-- Solo se confirma hasta punto1
COMMIT;

-- Verificar cambios
SELECT id_libro, titulo, stock FROM libros WHERE id_libro IN (3, 4, 5);

-- =============================================
-- NIVELES DE AISLAMIENTO
-- =============================================

-- Ver nivel actual
SELECT @@transaction_isolation;

-- Cambiar nivel de aislamiento
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT @@transaction_isolation;

-- Volver al nivel por defecto
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT @@transaction_isolation;