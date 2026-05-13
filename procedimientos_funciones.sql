USE biblioteca_db;

-- Cambiamos el delimitador para que MySQL no confunda
-- el ; de dentro del procedimiento con el fin del script
DELIMITER //

-- =============================================
-- PROCEDIMIENTOS ALMACENADOS
-- =============================================

-- Procedimiento 1: Agregar un nuevo libro
CREATE PROCEDURE agregar_libro(
    IN p_titulo VARCHAR(200),
    IN p_isbn VARCHAR(20),
    IN p_anio INT,
    IN p_paginas INT,
    IN p_stock INT,
    IN p_id_autor INT,
    IN p_id_categoria INT
)
BEGIN
    INSERT INTO libros (titulo, isbn, anio_publicacion, num_paginas, stock, id_autor, id_categoria)
    VALUES (p_titulo, p_isbn, p_anio, p_paginas, p_stock, p_id_autor, p_id_categoria);
    SELECT CONCAT('✔ Libro "', p_titulo, '" agregado correctamente.') AS mensaje;
END //

-- Procedimiento 2: Ver libros por categoría
CREATE PROCEDURE libros_por_categoria(
    IN p_id_categoria INT
)
BEGIN
    SELECT 
        l.titulo,
        CONCAT(a.nombre, ' ', a.apellido) AS autor,
        l.stock
    FROM libros l
    JOIN autores a ON l.id_autor = a.id_autor
    WHERE l.id_categoria = p_id_categoria;
END //

-- Procedimiento 3: Registrar un préstamo
CREATE PROCEDURE registrar_prestamo(
    IN p_nombre_socio VARCHAR(200),
    IN p_id_libro INT,
    IN p_fecha DATE
)
BEGIN
    DECLARE stock_actual INT;
    SELECT stock INTO stock_actual FROM libros WHERE id_libro = p_id_libro;
    
    IF stock_actual > 0 THEN
        INSERT INTO prestamos (nombre_socio, id_libro, fecha_prestamo, devuelto)
        VALUES (p_nombre_socio, p_id_libro, p_fecha, FALSE);
        UPDATE libros SET stock = stock - 1 WHERE id_libro = p_id_libro;
        SELECT '✔ Préstamo registrado correctamente.' AS mensaje;
    ELSE
        SELECT '✘ No hay stock disponible para este libro.' AS mensaje;
    END IF;
END //

-- Procedimiento 4: Devolver un libro
CREATE PROCEDURE devolver_libro(
    IN p_id_prestamo INT
)
BEGIN
    DECLARE id_libro_prestado INT;
    SELECT id_libro INTO id_libro_prestado FROM prestamos WHERE id_prestamo = p_id_prestamo;
    
    UPDATE prestamos 
    SET devuelto = TRUE, fecha_devolucion = CURDATE() 
    WHERE id_prestamo = p_id_prestamo;
    
    UPDATE libros SET stock = stock + 1 WHERE id_libro = id_libro_prestado;
    SELECT '✔ Libro devuelto correctamente.' AS mensaje;
END //

-- =============================================
-- FUNCIONES
-- =============================================

-- Función 1: Contar libros de un autor
CREATE FUNCTION total_libros_autor(p_id_autor INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    SELECT COUNT(*) INTO total FROM libros WHERE id_autor = p_id_autor;
    RETURN total;
END //

-- Función 2: Calcular días de préstamo
CREATE FUNCTION dias_prestamo(p_fecha_prestamo DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(CURDATE(), p_fecha_prestamo);
END //

DELIMITER ;

-- =============================================
-- EJECUTAR LOS PROCEDIMIENTOS Y FUNCIONES
-- =============================================

-- Llamar al procedimiento agregar_libro
CALL agregar_libro('El otoño del patriarca', '978-84-397-0178-4', 1975, 317, 3, 1, 1);

-- Llamar al procedimiento libros_por_categoria (categoría 1 = Novela)
CALL libros_por_categoria(1);

-- Llamar al procedimiento registrar_prestamo
CALL registrar_prestamo('Laura Gómez', 1, CURDATE());

-- Usar la función total_libros_autor
SELECT total_libros_autor(1) AS libros_de_garcia_marquez;

-- Usar la función dias_prestamo
SELECT nombre_socio, dias_prestamo(fecha_prestamo) AS dias_prestado
FROM prestamos
WHERE devuelto = FALSE;