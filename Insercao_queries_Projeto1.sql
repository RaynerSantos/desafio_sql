-- Inserção de dados e queries
use ecommerce;

show tables;
-- idClient, Fname, Minit, Lname, CPF, Address
insert into clients (Fname, Minit, Lname, CPF, Address) 
	values  ('Maria', 'M', 'Silva', 12346789, 'rua silva de prata 29, Carangola - Cidade das flores'),
			('Matheus', 'O', 'Pimentel', 987654321, 'rua alameda 289, Centro - Cidade das flores'),
            ('Ricardo', 'F', 'Silva', 45678913, 'avenida alameda vinho 1009, Centro - Cidade das flores'),
            ('Julia', 'S', 'França', 789123456, 'rua lajeiras 861, Centro - Cidade das flores'),
            ('Roberta', 'G', 'Assis', 98745631, 'avenida koller 19, Centro - Cidade das flores'),
            ('Isabela', 'M', 'Cruz', 654789123, 'rua alameda das flores 28, Centro - Cidade das flores');
   

-- idProduct, Pname, classification_kids boolean, category('Eletrônico', 'Vestimenta', 'Brinquedos', 'Alimentos', 'Móveis'), avaliacao, size
insert into product (Pname, classification_kids, category, avaliacao, size) values
	('Fone de ouvido', false, 'Eletrônico', '4', null),
    ('Barbie Elsa', true, 'Brinquedos', '3', null),
    ('Body Carters', true, 'Vestimenta', '5', null),
    ('Microfone Vedo - Youtuber', false, 'Eletrônico', '4', null),
    ('Sofá retrátil', false, 'Móveis', '3', '3x57x80'),
    ('Farinha de arroz', false, 'Alimentos', '2', null),
    ('Fire Stick Amazon', false, 'Eletrônico', '3', null);

truncate table orders;
-- idOrder, idOrderClient, orderStatus, orderDescription, sendvalue, paymentCash
insert into orders (idOrderClient, orderStatus, orderDescription, sendvalue, paymentCash) values 
	(1, default, 'compra via aplicativo', null, 1),
    (2, default, 'compra via aplicativo', 50, 0),
    (3, 'Confirmado', null, null, 1),
    (4, default, 'compra via web site', 150, 0),
    (2, default, 'compra via aplicativo', null, 1);
    
select * from orders;


-- idPOproduct, idPOorder, poQuantity, poStatus
insert into productOrder (idPOproduct, idPOorder, poQuantity, poStatus) values
	(1, 1, 2, null),
    (2, 1, 1, null),
    (3, 2, 1, null);
    

-- storageLocation, quantity
insert into productStorage (storageLocation, quantity) values
	('Rio de Janeiro', 1000),
    ('Rio de Janeiro', 500),
    ('São Paulo', 10),
    ('São Paulo', 100),
    ('São Paulo', 10),
    ('Brasília', 60);


-- idLproduct, idLstorage, location
insert into storageLocation (idLproduct, idLstorage, location) values
	(1, 2, 'RJ'),
    (2, 6, 'GO');


-- idSupplier, SocialName, CNPJ, contact
insert into supplier (SocialName, CNPJ, contact) values
	('Almeida e filhos', 123456789123456, '21985474'),
    ('Eletrônicos Silva', 854519649143457, '21985484'),
    ('Eletrônicos Valma', 934567893934695, '21975474');
    

-- idPsSupplier, idPsProduct, quantity
insert into productSupplier (idPsSupplier, idPsProduct, quantity) values
	(1, 1, 500),
    (1, 2, 400),
    (2, 4, 633),
    (3, 3, 5),
    (2, 5, 10);


-- idSeller, SocialName, AbstName, CNPJ, CPF, location, contact
insert into seller (SocialName, AbstName, CNPJ, CPF, location, contact) values
	('Tech eletronics', null, 123456789456321, null, 'Rio de Janeiro', 219946287),
    ('Botique Durgas', null, null, 123456783, 'Rio de Janeiro', 219567898),
    ('Kids World', null, 456789123654485, null, 'São Paulo', 1198657484);


-- idPseller, idPproduct, prodQuantity
insert into productSeller (idPseller, idPproduct, prodQuantity) values
	(1,6,80),
    (2,7,10);


select count(*) as 'Número de clientes' from clients;
select * from clients as c, orders as o where c.idClient = idOrderClient;

select * from clients as c inner join orders as o on c.idClient = idOrderClient;

-- Recuperar nome do cliente, ordem e status do pedido
select concat(Fname, " ", Lname) as 'Client', idOrder as 'Order', orderStatus as 'Status' from clients as c inner join orders as o on c.idClient = o.idOrderClient;

-- Recuperar quantos pedidos foram realizados pelos clientes
select c.idClient, Fname, count(*) as Number_of_orders from clients as c 
		inner join orders as o on c.idClient = o.idOrderClient
        group by idClient;
  
  
-- Recuperação de pedido com produto associado
select * from clients as c
	inner join orders as o on c.idClient = o.idOrderClient
    inner join productOrder p on p.idPOorder = o.idOrder
    group by idClient;
    

-- Recuperar nome do cliente, CPF, status do pedido, descrição, nome do produto, sua categoria e quantidade por cada compra de cliente
select concat(Fname, ' ', Lname) as 'Client', CPF, orderStatus, orderDescription, Pname as 'Product_Name', category, poQuantity as 'Quantity' from clients as c
	inner join orders as o on c.idClient = o.idOrderClient
    inner join productorder as po on po.idPOorder = o.idOrder
    inner join product as p on p.idProduct = po.idPOproduct;
    

-- Recuperar a soma total da quantidade no estoque por cidade
select storageLocation, sum(quantity) as 'total_quantity' from productstorage
	group by storageLocation;
    

-- Recuperar os fornecedores de cada um dos produtos
select SocialName, CNPJ, contact, Pname as 'Product_Name', category, quantity from product as p 
	inner join productsupplier as ps on ps.idPsProduct = p.idProduct
	inner join supplier as s on s.idSupplier = ps.idPsSupplier;
    

-- Recuperar média de avaliação dos produtos para os pedidos que estão em processamento
select avg(avaliacao) as 'Média de avaliação' from orders as o
	inner join productorder as po on o.idOrder = po.idPOorder
    inner join product as p on p.idProduct = po.idPOproduct
    where orderStatus = "Em processamento";


    -- Recuperar avaliação dos produtos para todos os pedidos que estão em processamento
    select Pname as 'Product Name', category, classification_kids, avaliacao from orders as o
	inner join productorder as po on o.idOrder = po.idPOorder
    inner join product as p on p.idProduct = po.idPOproduct
    where orderStatus = "Em processamento";
    
    
-- Quantidade de pedidos que foram feitos por cada cliente
select concat(Fname, ' ', Lname) as 'Complete_Name', count(*) as 'Order_Quantity' from orders as o 
	inner join clients as c on o.idOrderClient = c.idClient
	group by Fname
    order by count(*) desc;
    

-- Algum vendedor também é fornecedor?
select * from seller as s 
	inner join productseller as ps on s.idSeller = ps.idPseller
	inner join product as p on ps.idPproduct = p.idProduct
    inner join productsupplier as pds on p.idProduct = pds.idPsProduct
    inner join supplier as sp on pds.idPsSupplier = sp.idSupplier;


-- Relação de produtos fornecedores e estoques
show tables;
select * from supplier;
select * from productsupplier;
select * from product;
select * from productstorage;

select SocialName as 'Fornecedor', Pname as 'Produto', category as 'Categoria', storageLocation as 'Estoque', pst.quantity as 'Quantidade' from supplier as s
	inner join productsupplier as psu on s.idSupplier = psu.idPsSupplier
    inner join product as p on p.idProduct = psu.idPsProduct
    inner join productstorage as pst on pst.idProdStorage = p.idProduct;


-- Relação de nomes dos fornecedores e nomes dos produtos;
select SocialName as 'Fornecedor', Pname as 'Produto', category as 'Categoria' from supplier as s
	inner join productsupplier as psu on s.idSupplier = psu.idPsSupplier
    inner join product as p on p.idProduct = psu.idPsProduct;
    
    
