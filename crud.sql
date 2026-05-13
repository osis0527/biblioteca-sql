USE biblioteca_db;

-- =============================================
-- CREATE - Insertar nuevos registros
-- =============================================

-- Agregar nuevos autores
INSERT INTO autores (nombre, apellido, nacionalidad, anio_nacimiento) VALUES
('Mario', 'Vargas Llosa', 'Peruana', 1936),
('Pablo', 'Neruda', 'Chilena', 1904);

-- Agregar nueva categoría
INSERT INTO categorias (nombre, descripcion) VALUES
('Biografía', 'Obras sobre la vida de personas reales');

-- Agregar nuevos libros
INSERT INTO libros (titulo, isbn, anio_publicacion, num_paginas, stock, id_autor, id_categoria) VALUES
('La ciudad y los perros', '978-84-322-0213-6', 1963, 368, 4, 5, 1),
('Veinte poemas de amor', '978-84-376-0494-8', 1924, 100, 6, 6, 3);

-- Agregar nuevo préstamo
INSERT INTO prestamos (nombre_socio, id_libro, fecha_prestamo, devuelto) VALUES
('Pedro Sánchez', 4, '2024-04-01', FALSE);

-- =============================================
-- READ - Consultar registros
-- =============================================

-- Ver todos los autores
SELECT * FROM autores;

-- Ver todos los libros
SELECT * FROM libros;

-- Ver todos los préstamos
SELECT * FROM prestamos;

-- Ver libros con nombre de autor y categoría
SELECT 
    l.titulo,
    CONCAT(a.nombre, ' ', a.apellido) AS autor,
    c.nombre AS categoria,
    l.stock
FROM libros l
JOIN autores a ON l.id_autor = a.id_autor
JOIN categorias c ON l.id_categoria = c.id_categoria;

-- =============================================
-- UPDATE - Modificar registros
-- =============================================

-- Actualizar stock de un libro
UPDATE libros 
SET stock = 10 
WHERE id_libro = 1;

-- Actualizar fecha de devolución de un préstamo
UPDATE prestamos 
SET fecha_devolucion = '2024-04-15', devuelto = TRUE 
WHERE id_prestamo = 5;

-- Actualizar nacionalidad de un autor
UPDATE autores 
SET nacionalidad = 'Española' 
WHERE id_autor = 4;

-- =============================================
-- DELETE - Eliminar registros
-- =============================================

-- Eliminar un préstamo
DELETE FROM prestamos 
WHERE id_prestamo = 5;

-- Verificar que se eliminó
SELECT * FROM prestamos;