 create database localdeventa;
 show databases;
 use localdeventa;
-- hasta aqui hemos creado la bd, mostramos las que estan
-- y utilizamos la db usuarios

create table vendedores (
	id int not null auto_increment,
    nombre char(25) not null,
    area varchar(45) not null,
    primary key (id)
    );
-- creamos la tabla dentro de nuestra bd, ademas asignamos tipos de variables
-- y tambien definimos cual es nuestra primary key (PK)
    
create table poductos (
	id int not null auto_increment,
    nombre char(25) not null,
    vendido_por int not null,
    marca varchar(45) not null,
    precio int not null,
    primary key (id),
    foreign key (vendido_por) references vendedores(id)
    );
-- creamos nuestra segunda bd pero esta ves le asignamos
-- un nuevo atributo, le decimos que tiene como llave foranea
-- el id de los vendedores y creamos "vendido_por" para
-- enlazarlo con la otra tabla
rename table vendedores to vendedor; -- le cambiamos los nombres de las tablas a ambas
rename table poductos to producto;
