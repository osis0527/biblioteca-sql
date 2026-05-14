USE biblioteca_db;

DELIMITER //

-- Trigger 1: Registrar en log cuando se agrega un libro
CREATE TABLE IF NOT EXISTS log_libros (
    id_log INT AUTO_INCREMENT PRIMARY KEY,
    accion VARCHAR(50),
    titulo VARCHAR(200),
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP
) //

CREATE TRIGGER after_insert_libro
AFTER INSERT ON libros
FOR EACH ROW
BEGIN
    INSERT INTO log_libros (accion, titulo)
    VALUES ('INSERCIÓN', NEW.titulo);
END //

-- Trigger 2: Registrar en log cuando se elimina un libro
CREATE TRIGGER after_delete_libro
AFTER DELETE ON libros
FOR EACH ROW
BEGIN
    INSERT INTO log_libros (accion, titulo)
    VALUES ('ELIMINACIÓN', OLD.titulo);
END //

-- Trigger 3: Evitar stock negativo
CREATE TRIGGER before_update_stock
BEFORE UPDATE ON libros
FOR EACH ROW
BEGIN
    IF NEW.stock < 0 THEN
        SET NEW.stock = 0;
    END IF;
END //

DELIMITER ;

-- Probar los triggers
INSERT INTO libros (titulo, isbn, anio_publicacion, num_paginas, stock, id_autor, id_categoria)
VALUES ('Libro de prueba', '000-000', 2024, 100, 5, 1, 1);

-- Ver el log
SELECT * FROM log_libros;

-- Probar trigger de stock negativo
UPDATE libros SET stock = -5 WHERE titulo = 'Libro de prueba';
SELECT titulo, stock FROM libros WHERE titulo = 'Libro de prueba';