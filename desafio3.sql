-- creación de la base de datos -- 
CREATE DATABASE desafio3-Patricio-Carrasco-321;
-- creamos la tabla usuario -- 
CREATE TABLE usuario (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    rol VARCHAR(50)
);
-- ingresamos 5 usuarios donde al menos 1 es administrador -- 
INSERT INTO usuario (email, nombre, apellido, rol)
VALUES
    ('usuario1@dl.com', 'Juan', 'Perez', 'usuario'),
    ('usuario2@dl.com', 'María', 'Gómez', 'usuario'),
    ('usuario3@dl.com', 'Pedro', 'Ramírez', 'administrador'),
    ('usuario4@dl.com', 'Laura', 'Martínez', 'usuario'),
    ('usuario5@dl.com', 'Carlos', 'López', 'usuario');

--  creamos la tabla post --
CREATE TABLE post (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    contenido TEXT NOT NULL,
    fecha_creacion TIMESTAMP,
    fecha_actualizacion TIMESTAMp,
    destacado BOOLEAN NOT NULL,
    usuario_id BIGINT
);
-- ingresamos datos en la tabla – 
-- Insertar 5 posts en la tabla "post"
INSERT INTO post (fecha_creacion, fecha_actualizacion, destacado, usuario_id, titulo, contenido)
VALUES
    (CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, true, 1, 'big data', 'informacion de big data'),
    (CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, true, 1, 'analisis de datos', 'informacion de analisis de datos'),
    (CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, false, 2, 'ciencia de datos', 'informacion de ciencia de datos'),
    (CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, false, 3, 'estadisticas', 'informacion de estadisticas'),
    (CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, true, NULL, 'machine learning', 'informacion de machine learning');

-- creamos la tabla comentarios --
CREATE TABLE comentarios (
    id SERIAL PRIMARY KEY,
    contenido VARCHAR,
    fecha_creacion TIMESTAMP,
    usuario_id BIGINT,
    post_id BIGINT
);
-- Insertar 5 comentarios en la tabla "comentarios"
INSERT INTO comentarios (contenido, fecha_creacion, usuario_id, post_id)
VALUES
    ('excelente', CURRENT_TIMESTAMP, 1, 1),
    ('no me gusto', CURRENT_TIMESTAMP, 2, 1),
    ('no se entiende', CURRENT_TIMESTAMP, 3, 1),
    ('me gusta', CURRENT_TIMESTAMP, 1, 2),
    ('falta mas contenido', CURRENT_TIMESTAMP, 2, 2);
-- Cruza los datos de la tabla usuarios y posts mostrando las siguientes columnas. nombre e email del usuario junto al título y contenido del post. –
-- me debería mostrar los 4 post donde 2 se repiten x el administrador --
SELECT u.nombre, u.email, p.titulo, p.contenido
FROM usuario u
JOIN post p ON u.id = p.usuario_id;

-- Muestra el id, título y contenido de los posts de los administradores. El administrador puede se -- cualquier id y debe ser seleccionado dinámicamente. --
SELECT p.id, p.titulo, p.contenido
FROM post p
JOIN usuario u ON p.usuario_id = u.id
WHERE u.rol = 'administrador';

 -- Cuenta la cantidad de posts de cada usuario. La tabla resultante debe mostrar el id e email del usuario junto con la cantidad de posts de cada usuario. (1 Punto) Hint importante: Aquí hay diferencia entre utilizar inner join, left join o right join, prueba con todas y con eso determina cual es la correcta. No da lo mismo la tabla desde la que se parte.
-- decidí probar con cada una para ver que me datos me mostraba--
SELECT u.id, u.email, COUNT(p.id) AS cantidad_posts
FROM usuario u
INNER JOIN post p ON u.id = p.usuario_id
GROUP BY u.id, u.email;
-- ** me muestra solo 3 usuarios y su cantidad de post **

SELECT u.id, u.email, COUNT(p.id) AS cantidad_posts
FROM usuario u
LEFT JOIN post p ON u.id = p.usuario_id
GROUP BY u.id, u.email;
-- ** aquí me muestra los 5 usuarios, pero en 2 usuarios me pone 0 comentarios **

-- ** por último usamos un RIGHT JOIN donde me arroja el null sin id **
SELECT u.id, u.email, COUNT(p.id) AS cantidad_posts
FROM usuario u
RIGHT JOIN post p ON u.id = p.usuario_id
GROUP BY u.id, u.email;

-- Muestra el email del usuario que ha creado más posts. Aquí la tabla resultante tiene un único registro y muestra solo el email.
SELECT u.email
FROM usuario u
JOIN post p ON u.id = p.usuario_id
GROUP BY u.email
ORDER BY COUNT(p.id) DESC
LIMIT 1;

-- Muestra la fecha del último post de cada usuario
SELECT u.id, u.email, MAX(p.fecha_creacion) AS fecha_ultimo_post
FROM usuario u
LEFT JOIN post p ON u.id = p.usuario_id
GROUP BY u.id, u.email
ORDER BY COUNT(p.id) DESC;

-- Muestra el título y contenido del post (artículo) con más comentarios
SELECT p.titulo, p.contenido
FROM post p
LEFT JOIN comentarios c ON p.id = c.post_id
GROUP BY p.id, p.titulo, p.contenido
ORDER BY COUNT(c.id) DESC
LIMIT 1;
-- Muestra en una tabla el título de cada post, el contenido de cada post y el contenido de cada comentario asociado a los posts mostrados, junto con el email del usuario que lo escribió
-- (aquí no entendí bien al tratar de juntar todas las tablas ya que se repiten los id, títulos pero quieren ver además los comentarios)
SELECT p.titulo AS "Título del Post",
       p.contenido AS "Contenido del Post",
       c.contenido AS "Contenido del Comentario",
       u.email AS "Email del Usuario"
FROM posts p
LEFT JOIN comentarios c ON p.id = c.post_id
LEFT JOIN usuarios u ON c.usuario_id = u.id;

-- Muestra el contenido del último comentario de cada usuario. --
SELECT email AS "Email del Usuario", contenido AS "Contenido del Último Comentario"
FROM (
    SELECT u.email, c.contenido,
           ROW_NUMBER() OVER (PARTITION BY u.id ORDER BY c.fecha_creacion DESC) AS rn
    FROM usuario u
    JOIN comentarios c ON u.id = c.usuario_id
) subquery
WHERE rn = 1;

-- Muestra los emails de los usuarios que no han escrito ningún comentario. (1 Punto) Hint: Recuerda el uso de Having
SELECT u.email
FROM usuario u
LEFT JOIN comentarios c ON u.id = c.usuario_id
GROUP BY u.email
HAVING COUNT(c.id) = 0;
