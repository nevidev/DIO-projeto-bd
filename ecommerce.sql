-- criação do banco de dados para ecommerce
create database ecommerce;
use ecommerce;

-- criar tabela cliente
create table clients(
	idClient int auto_increment primary key,
    Fname varchar(10),
    Minit char(3),
    Lname varchar(20),
    Cpf char(11) not null,
    Address varchar(120),
    constraint cpf_cliente unique (cpf)
);
alter table clients auto_increment = 1;

-- criar tabela produto
create table product(
	idProduct int auto_increment primary key,
    Pname varchar(10) not null,
    Classification_kids bool default false,
    Category enum('Eletrônico','Vestimenta','Brinquedo','Alimento','Móveis') not null,
	Aval float default 0,
    Size varchar(10)
);

-- criar tabela pedido
create table orders(
	idOrder int auto_increment primary key,
    idClientOrder int,
    orderStatus enum('Cancelado', 'Enviado', 'Concluído', 'Processando') default 'Processando',
    about varchar(255),
    freight float default 10,
    payment enum('Cartão', 'Pix', 'Boleto'),
    constraint fk_orders_client foreign key (idClientOrder) references clients(idClient)
);

-- estoque
create table stock (
	idStock int auto_increment primary key,
    locale varchar(120),
    qtd int default 0
);
ALTER TABLE stock ADD COLUMN idProduct INT;
ALTER TABLE stock ADD CONSTRAINT fk_stock_product FOREIGN KEY (idProduct) REFERENCES product(idProduct);


-- fornecedor
create table supplier(
	idSup int auto_increment primary key,
    nameSup varchar (120) not null,
    cnpj char(15) not null,
    mail varchar(30),
    location varchar(120),
    constraint unique_cnpj unique (cnpj)
);

-- vendedor terceiro
create table seller(
	idSeller int auto_increment primary key,
    nameSeller varchar(120),
    cnpj char(15) not null unique,
    mail varchar(30),
    location varchar(120)
);

create table sellerProduct(
	idSeller int,
    idProduct int,
    qtd int not null,
    primary key (idSeller, idProduct),
    constraint fk_product_seller foreign key (idSeller) references seller(idSeller),
    constraint fk_product_product foreign key (idProduct) references product(idProduct)
);

CREATE TABLE order_items (
    idItem INT PRIMARY KEY,
    idOrder INT,
    idProduct INT,
    qtd INT,
    unitPrice DECIMAL(10,2),
    FOREIGN KEY (idOrder) REFERENCES orders(idOrder),
    FOREIGN KEY (idProduct) REFERENCES product(idProduct)
);
alter table order_items add unique (idOrder, idProduct);
ALTER TABLE order_items MODIFY idItem INT AUTO_INCREMENT;



show databases;
show tables;
INSERT INTO clients (Fname, Minit, Lname, Cpf, Address) VALUES
('Ana', 'M', 'Silva', '12345678901', 'Rua das Flores, 100'),
('Bruno', 'A', 'Costa', '23456789012', 'Av. Brasil, 200'),
('Carla', 'B', 'Souza', '34567890123', 'Rua Central, 300');

INSERT INTO product (Pname, Classification_kids, Category, Aval, Size) VALUES
('Celular', false, 'Eletrônico', 4.5, 'Médio'),
('Camiseta', false, 'Vestimenta', 4.2, 'G'),
('Boneco', true, 'Brinquedo', 4.8, 'Pequeno'),
('Chocolate', true, 'Alimento', 4.7, 'Pequeno'),
('Sofá', false, 'Móveis', 4.1, 'Grande');

INSERT INTO stock (locale, qtd, idProduct) VALUES
('Centro de Distribuição SP', 50, 1),
('Centro de Distribuição RJ', 100, 2),
('Loja BH', 30, 3),
('Loja Salvador', 80, 4),
('Loja Porto Alegre', 20, 5);

INSERT INTO supplier (nameSup, cnpj, mail, location) VALUES
('TechDistribuidora', '12345678000199', 'contato@tech.com', 'São Paulo'),
('ModaSul', '23456789000188', 'vendas@modasul.com', 'Porto Alegre');

INSERT INTO seller (nameSeller, cnpj, mail, location) VALUES
('Loja do João', '34567890000177', 'joao@lojajoao.com', 'Rio de Janeiro'),
('Brinquedos da Lu', '45678901000166', 'lu@brinquedoslu.com', 'Curitiba');

INSERT INTO sellerProduct (idSeller, idProduct, qtd) VALUES
(1, 1, 10),
(1, 2, 15),
(2, 3, 20),
(2, 4, 25);

INSERT INTO orders (idClientOrder, orderStatus, about, freight, payment) VALUES
(1, 'Enviado', 'Pedido com celular e camiseta', 15.00, 'Pix'),
(2, 'Processando', 'Pedido com boneco e chocolate', 10.00, 'Cartão');

INSERT INTO order_items (idOrder, idProduct, qtd, unitPrice) VALUES
(1, 1, 1, 1500.00),
(1, 2, 2, 50.00),
(2, 3, 1, 80.00),
(2, 4, 3, 10.00);

use ecommerce;
select * from clients;

-- consultando pedido e status dado cliente 
select Fname, Lname, idOrder, orderStatus from clients c, orders o where c.idClient = o.idClientOrder;
-- concatenando
select concat(Fname,' ', Lname) as name, idOrder, orderStatus from clients c, orders o where c.idClient = o.idClientOrder;


