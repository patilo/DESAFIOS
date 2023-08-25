CREATE TABLE Peliculas (
    id INT PRIMARY KEY,
    nombre VARCHAR(255),
    anno INT
);
INSERT INTO Peliculas (id, nombre, anno) VALUES
(1, 'silicon valley', 2000),
(2, 'red social', 2001),
(3, 'El codigo enigma', 2002),
(4, 'hacker', 2003),
(5, 'aprendices', 2004);

select * from Peliculas;

CREATE TABLE Tags (
    id INT PRIMARY KEY,
    tag VARCHAR(32)
);
INSERT INTO Tags (id, tag) VALUES
(1, 'Acción'),
(2, 'Drama'),
(3, 'Suspenso'),
(4, 'Ciencia ficción'),
(5, 'Comedia');

 select * from Tags;
 
 -- CREAREMOS UNA TABLA INTERMEDIA --
CREATE TABLE PeliculaTag (
    pelicula_id INT REFERENCES Peliculas(id),
    tag_id INT REFERENCES Tags(id) );
	
-- Inserta 5 películas y 5 tags; la primera película debe tener 3 tags asociados, 
-- La segunda película debe tener 2 tags asociados.

-- Insertar relaciones película-tag (Pelicula 1 con 3 tags)
INSERT INTO PeliculaTag (pelicula_id, tag_id) VALUES
(1, 1), -- Acción
(1, 2), -- Drama
(1, 3); -- Comedia

-- Insertar relaciones película-tag (Pelicula 2 con 2 tags)
INSERT INTO PeliculaTag (pelicula_id, tag_id) VALUES
(2, 2), -- Drama
(2, 4); -- Ciencia ficción

select * from PeliculaTag;

-- Cuenta la cantidad de tags que tiene cada película. Si una película no tiene tags debe mostrar 0.
SELECT p.id AS pelicula_id, p.nombre AS pelicula_nombre, COUNT(pt.tag_id) AS cantidad_tags
FROM Peliculas p
LEFT JOIN PeliculaTag pt ON p.id = pt.pelicula_id
GROUP BY p.id, p.nombre;




------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- tabla Preguntas
CREATE TABLE Preguntas (
    id INT PRIMARY KEY,
    pregunta VARCHAR(255),
    respuesta_incorrecta VARCHAR(255)
);
select * from Preguntas;

-- tabla Usuarios
CREATE TABLE Usuarios (
    id INT PRIMARY KEY,
    nombre VARCHAR(255),
    edad INT
);
select * from Usuarios;

-- tabla Respuestas
CREATE TABLE Respuestas (
    id INT PRIMARY KEY,
    respuesta VARCHAR(255),
    usuario_id INT,
    pregunta_id INT,
    FOREIGN KEY (usuario_id) REFERENCES Usuarios(id),
    FOREIGN KEY (pregunta_id) REFERENCES Preguntas(id) );
	
select * from Respuestas;
-- Agrega 5 usuarios y 5 preguntas.
-- a). La primera pregunta debe estar respondida correctamente dos veces, por dos usuarios diferentes.
-- b). La segunda pregunta debe estar contestada correctamente solo por unusuario.
-- c). Las otras TRES (VIDEO INDICA 3) preguntas deben tener respuestas incorrectas 
-- Contestada correctamente significa que la respuesta indicada en la tabla respuestas
-- es exactamente igual al texto indicado en la tabla de preguntas.

-- Insertar datos en la tabla Preguntas 
INSERT INTO Preguntas (id, pregunta, respuesta_incorrecta)
VALUES
    (1, '¿Qué protocolo se utiliza para enviar correos electrónicos?', 'HTTP'),
    (2, '¿En qué lenguaje de programación se escribió el kernel de Linux?', 'C++'),
    (3, '¿Qué significa "HTML" en términos de programación web?', 'Hyper Text Makeup Language'),
    (4, '¿Cuál es la unidad básica de almacenamiento en un sistema de cómputo?', 'Kilobyte'),
    (5, '¿Qué empresa desarrolló el primer microprocesador comercial?', 'IBM');
	
select * from Preguntas;

-- Insertar datos en la tabla Usuarios
INSERT INTO Usuarios (id, nombre, edad)
VALUES
    (6, 'Ana', 28),
    (7, 'David', 24),
    (8, 'Sofía', 31),
    (9, 'Gabriel', 22),
    (10, 'Lucía', 29);
	
select * from Usuarios;

-- Insertar respuestas correctamente en la tabla Respuestas
INSERT INTO Respuestas (id, respuesta, usuario_id, pregunta_id)
VALUES
    (11, 'HTTP', 6, 1), -- Respuesta correcta (usuario Ana)
    (12, 'HTTP', 7, 1), -- Respuesta correcta (usuario David)
    (13, 'HTTP', 8, 2),   -- Respuesta correcta (usuario Sofia)
    (14, 'Java', 9, 3),    -- Respuesta incorrecta (usuario Gabriel)
    (15, 'Almacenar y acceder a datos', 10, 4), -- Respuesta incorrecta (usuario Lucia)
    (16, 'Uniform Resource Locator', 6, 1); -- Respuesta incorrecta (usuario Ana)
	
select * from Respuestas;

--- Cuenta la cantidad de respuestas correctas totales por usuario (independiente de la pregunta).
SELECT
    Usuarios.id,
    Usuarios.nombre,
    COUNT(*) AS respuestas_correctas
FROM Usuarios
JOIN Respuestas ON Usuarios.id = Respuestas.usuario_id
JOIN Preguntas ON Respuestas.pregunta_id = Preguntas.id
GROUP BY Usuarios.id, Usuarios.nombre;


---  Por cada pregunta, en la tabla preguntas, cuenta cuántos usuarios respondieron correctamente. 
SELECT
    Preguntas.id AS pregunta_id,
    Preguntas.pregunta,
    COUNT(DISTINCT Respuestas.usuario_id) AS usuarios_correctos
FROM Preguntas
LEFT JOIN Respuestas ON Preguntas.id = Respuestas.pregunta_id
GROUP BY Preguntas.id, Preguntas.pregunta;


---Implementa un borrado en cascada de las respuestas al borrar un usuario. Prueba la

ALTER TABLE Respuestas
ADD CONSTRAINT fk_usuario_respuestas
FOREIGN KEY (usuario_id) REFERENCES Usuarios(id)
ON DELETE CASCADE;
---implementación borrando el primer usuario.
DELETE FROM Usuarios
WHERE id = 1;


-- Crear la restricción CHECK para evitar insertar usuarios menores de 18 años

alter table Usuarios
Add constraint chk_edad_mayor_18 check(edad >=18 );
