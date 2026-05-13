USE biblioteca_db;

-- =============================================
-- WHERE - Filtrar registros
-- =============================================

-- Libros con stock mayor que 3
SELECT titulo, stock 
FROM libros 
WHERE stock > 3;

-- Libros publicados después de 1950
SELECT titulo, anio_publicacion 
FROM libros 
WHERE anio_publicacion > 1950;

-- Préstamos pendientes de devolver
SELECT nombre_socio, fecha_prestamo 
FROM prestamos 
WHERE devuelto = FALSE;

-- =============================================
-- LIKE - Buscar texto
-- =============================================

-- Libros que contengan "amor" en el título
SELECT titulo 
FROM libros 
WHERE titulo LIKE '%amor%';

-- Autores cuyo nombre empiece por "G"
SELECT nombre, apellido 
FROM autores 
WHERE nombre LIKE 'G%';

-- =============================================
-- BETWEEN - Rango de valores
-- =============================================

-- Libros publicados entre 1900 y 1970
SELECT titulo, anio_publicacion 
FROM libros 
WHERE anio_publicacion BETWEEN 1900 AND 1970;

-- =============================================
-- ORDER BY - Ordenar resultados
-- =============================================

-- Libros ordenados por título alfabéticamente
SELECT titulo, anio_publicacion 
FROM libros 
ORDER BY titulo ASC;

-- Libros ordenados por stock de mayor a menor
SELECT titulo, stock 
FROM libros 
ORDER BY stock DESC;

-- =============================================
-- COUNT, SUM, AVG, MAX, MIN - Funciones de agregación
-- =============================================

-- Total de libros
SELECT COUNT(*) AS total_libros 
FROM libros;

-- Total de stock de todos los libros
SELECT SUM(stock) AS total_stock 
FROM libros;

-- Media de páginas por libro
SELECT AVG(num_paginas) AS media_paginas 
FROM libros;

-- Libro con más páginas
SELECT titulo, num_paginas AS max_paginas
FROM libros
ORDER BY num_paginas DESC
LIMIT 1;

-- Libro con menos páginas
SELECT titulo, num_paginas AS min_paginas
FROM libros
ORDER BY num_paginas ASC
LIMIT 1;

-- =============================================
-- GROUP BY - Agrupar resultados
-- =============================================

-- Total de libros por categoría
SELECT c.nombre AS categoria, COUNT(*) AS total_libros
FROM libros l
JOIN categorias c ON l.id_categoria = c.id_categoria
GROUP BY c.nombre;

-- Total de stock por autor
SELECT CONCAT(a.nombre, ' ', a.apellido) AS autor, SUM(l.stock) AS total_stock
FROM libros l
JOIN autores a ON l.id_autor = a.id_autor
GROUP BY a.id_autor;

-- =============================================
-- HAVING - Filtrar grupos
-- =============================================

-- Categorías con más de 1 libro
SELECT c.nombre AS categoria, COUNT(*) AS total_libros
FROM libros l
JOIN categorias c ON l.id_categoria = c.id_categoria
GROUP BY c.nombre
HAVING COUNT(*) > 1;

-- =============================================
-- Consultas combinadas
-- =============================================

-- Libros con autor y categoría ordenados por año
SELECT 
    l.titulo,
    CONCAT(a.nombre, ' ', a.apellido) AS autor,
    c.nombre AS categoria,
    l.anio_publicacion,
    l.stock
FROM libros l
JOIN autores a ON l.id_autor = a.id_autor
JOIN categorias c ON l.id_categoria = c.id_categoria
ORDER BY l.anio_publicacion ASC;

-- Préstamos pendientes con título del libro
SELECT 
    p.nombre_socio,
    l.titulo,
    p.fecha_prestamo
FROM prestamos p
JOIN libros l ON p.id_libro = l.id_libro
WHERE p.devuelto = FALSE;