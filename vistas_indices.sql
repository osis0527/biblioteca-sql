-- =============================================
-- EJERCICIO 11 - VISTAS E ÍNDICES
-- =============================================

USE biblioteca_db;

-- =============================================
-- VISTAS
-- =============================================

-- Vista 1: Libros con autor y categoría
CREATE VIEW vista_libros_completa AS
SELECT 
    l.id_libro,
    l.titulo,
    CONCAT(a.nombre, ' ', a.apellido) AS autor,
    c.nombre AS categoria,
    l.anio_publicacion,
    l.stock
FROM libros l
JOIN autores a ON l.id_autor = a.id_autor
JOIN categorias c ON l.id_categoria = c.id_categoria;

-- Vista 2: Préstamos pendientes
CREATE VIEW vista_prestamos_pendientes AS
SELECT 
    p.id_prestamo,
    p.nombre_socio,
    l.titulo,
    p.fecha_prestamo
FROM prestamos p
JOIN libros l ON p.id_libro = l.id_libro
WHERE p.devuelto = FALSE;

-- Vista 3: Libros con stock bajo (menos de 3)
CREATE VIEW vista_stock_bajo AS
SELECT 
    l.titulo,
    CONCAT(a.nombre, ' ', a.apellido) AS autor,
    l.stock
FROM libros l
JOIN autores a ON l.id_autor = a.id_autor
WHERE l.stock < 3;

-- =============================================
-- ÍNDICES
-- =============================================

-- Índice en título de libros para búsquedas rápidas
CREATE INDEX idx_titulo ON libros(titulo);

-- Índice en nombre de autor
CREATE INDEX idx_autor ON autores(apellido);

-- Índice en fecha de préstamo
CREATE INDEX idx_fecha_prestamo ON prestamos(fecha_prestamo);

-- =============================================
-- USAR LAS VISTAS
-- =============================================

-- Ver todos los libros completos
SELECT * FROM vista_libros_completa;

-- Ver préstamos pendientes
SELECT * FROM vista_prestamos_pendientes;

-- Ver libros con stock bajo
SELECT * FROM vista_stock_bajo;

-- Ver índices creados
SHOW INDEX FROM libros;
SHOW INDEX FROM autores;
SHOW INDEX FROM prestamos;