CREATE DATABASE "M5S5 REBOUND";
\c "M5S5 REBOUND";

-- 1. Crear tabla “editoriales”, con los atributos código y nombre. Definir el código como llave primaria.
CREATE TABLE editoriales (
    codigo int PRIMARY KEY,
    nombre varchar(120) NOT NULL
);

-- 2. Crear tabla “libros”, con los atributos código, título, y codigoeditorial. Definir el código como 
-- llave primaria, y codigoeditorial como llave foránea, referenciando a la tabla editoriales.
CREATE TABLE libros (
    codigo int PRIMARY KEY,
    titulo varchar(120) NOT NULL,
    codigoeditorial int,
    CONSTRAINT fk_editoriales
        FOREIGN KEY(codigoeditorial)
            REFERENCES editoriales(codigo)
);
-- 3. Insertar editoriales y libros, de acuerdo con:
INSERT INTO editoriales (codigo, nombre)
VALUES 
    (1, 'Anaya'),
    (2, 'Andina'),
    (3, 'S.M.');

INSERT INTO libros (codigo, titulo, codigoeditorial)
VALUES
    (1, 'Don Quijote de La Mancha I', 1),
    (2, 'El Principito', 2),
    (3, 'El Príncipe', 3),
    (4, 'Diplomacia', 3),
    (5, 'Don Quijote de La Mancha II', 1);
    
-- 4. Modificar la tabla “libros”, agregando la columna autor y precio.
ALTER TABLE libros
ADD COLUMN autor varchar(120),
ADD COLUMN precio int;

-- 5. Agregar autor y precio a los libros ya ingresados.
BEGIN TRANSACTION;
UPDATE libros
SET autor = 'Miguel de Cervantes',
    precio = 150
    WHERE codigo = 1;
UPDATE libros
SET autor = 'Miguel de Cervantes',
    precio = 140
    WHERE codigo = 5;
UPDATE libros
SET autor = 'Antoine SaintExupery',
    precio = 120
    WHERE codigo = 2;
UPDATE libros
SET autor = 'Maquiavelo',
    precio = 180
    WHERE codigo = 3;
UPDATE libros
SET autor = 'Henry Kissinger',
    precio = 170
    WHERE codigo = 4;
COMMIT;

-- 6. Insertar 2 nuevos libros.
INSERT INTO libros
VALUES
    (6, 'El Juego de Ender', 3, 'Orson Scott Card', 130),
    (7, 'Fundación', 2, 'Isaac Asimov', 120);


-- 7. Eliminar los libros de la editorial Anaya, solo en memoria (ROLLBACK).
BEGIN TRANSACTION;
DELETE FROM libros
WHERE codigoeditorial = 1;
ROLLBACK;

-- 8. Actualizar el nombre de la editorial Andina a Iberlibro en memoria, y actualizar el nombre de
-- la editorial S.M. a Mountain en disco duro (SAVEPOINT / ROLLBACK TO).
BEGIN TRANSACTION;
UPDATE editoriales
SET nombre = 'Mountain'
    WHERE codigo = 3;
SAVEPOINT Andina
UPDATE editoriales 
SET nombre = 'Iberlibro'
    WHERE codigo = 2;
ROLLBACK TO Andina;
COMMIT;