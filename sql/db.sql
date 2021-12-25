CREATE DATABASE IF NOT EXISTS lojadiscos;
USE lojadiscos;

DROP TABLE IF EXISTS AUTOR, DISCO, GENERO, GENEROS_DISCO, PRODUTO,FORNECEDOR, FORNECE, FUNCIONARIO, CARGO, CARGO_FUNCIONARIO,
DEPARTAMENTO, CLIENTE, DESCONTO, ENCOMENDA_CLIENTE, STATUS_ENCOMENDA;

CREATE TABLE AUTOR
(
    IdAut           INT PRIMARY KEY AUTO_INCREMENT,
    Nome            VARCHAR(64) NOT NULL
);

CREATE TABLE DISCO
(
    IdDisc          INT PRIMARY KEY AUTO_INCREMENT,
    Autor           INT NOT NULL,
    Titulo          VARCHAR(128) NOT NULL,
    AnoLançamento   YEAR NOT NULL,
    Formato         ENUM('LP','EP','K7','CD') NOT NULL,
    NumFaixas       INT NOT NULL,
    Duracao         TIME NOT NULL,
    Descricao       TEXT,
    FOREIGN KEY(Autor) REFERENCES AUTOR(IdAut)
);

CREATE TABLE GENERO(
    IdGen       INT PRIMARY KEY AUTO_INCREMENT,
    Genero      VARCHAR(32) NOT NULL
);

CREATE TABLE GENEROS_DISCO(
    IdDisc          INT NOT NULL,
    IdGen           INT NOT NULL,
    PRIMARY KEY(IdDisc,IdGen),
    FOREIGN KEY(IdDisc) REFERENCES DISCO(IdDisc),
    FOREIGN KEY(IdGen) REFERENCES GENERO(IdGen)
);

CREATE TABLE PRODUTO
(
    IdProd          INT PRIMARY KEY AUTO_INCREMENT,
    IdDisc          INT NOT NULL UNIQUE,
    Valor           DECIMAL(6,2) NOT NULL,
    NumExemplares   INT NOT NULL,
    FOREIGN KEY(IdDisc) REFERENCES DISCO(IdDisc) 
);

CREATE TABLE FORNECEDOR
(
    IdFornecedor    INT PRIMARY KEY AUTO_INCREMENT,
    NomeFornecedor  VARCHAR(64) NOT NULL,
    Cidade          VARCHAR(32),
    Rua             VARCHAR(64) NOT NULL,
    Num             INT NOT NULL,
    Andar           VARCHAR(6),
    CP              VARCHAR(12) NOT NULL,
    Email           VARCHAR(32) NOT NULL,
    Telefone        VARCHAR(12) NOT NULL
);

CREATE TABLE PEDIDO_FORNECEDOR
(
    Fornecedor      INT NOT NULL, 
    Produto         INT NOT NULL,
	NumUnidades     INT NOT NULL,
	DataPedido      DATE NOT NULL,
    -- PRIMARY KEY(Fornecedor,Produto),
    FOREIGN KEY(Fornecedor) REFERENCES FORNECEDOR(IdFornecedor),
    FOREIGN KEY(Produto) REFERENCES PRODUTO(IdProd)
);

CREATE TABLE FUNCIONARIO 
(
    ID           INT PRIMARY KEY AUTO_INCREMENT,
    Nome         VARCHAR(64) NOT NULL,
    DataNasc     DATE NOT NULL,
    Sexo         ENUM('M','F'),
    Cidade      VARCHAR(32),
    Rua         VARCHAR(64) NOT NULL,
    Num         INT NOT NULL,
    Andar       VARCHAR(6),
    CP          VARCHAR(12) NOT NULL,
    Login       VARCHAR(32) NOT NULL,
    Senha       VARCHAR(32) NOT NULL
);

CREATE TABLE CARGO
(
    ID            INT PRIMARY KEY AUTO_INCREMENT,
    Nome          VARCHAR(64) NOT NULL,
    Salario       DECIMAL(7,2) NOT NULL,
    Descricao     TEXT
);

CREATE TABLE CARGO_FUNCIONARIO
(
    IdCargo     INT NOT NULL,
    IdFunc      INT NOT NULL,
    PRIMARY KEY(IdCargo,IdFunc),
    FOREIGN KEY(IdCargo) REFERENCES CARGO(ID),
    FOREIGN KEY(IdFunc) REFERENCES FUNCIONARIO(ID)
);

CREATE TABLE DEPARTAMENTO
(
    ID             INT PRIMARY KEY AUTO_INCREMENT,
    NomeDepartamento VARCHAR(64) NOT NULL,
    Gerente         INT NOT NULL,
    FOREIGN KEY(Gerente) REFERENCES FUNCIONARIO(ID),
    Descricao     TEXT
);

CREATE TABLE CLIENTE
(
    ID     INT PRIMARY KEY AUTO_INCREMENT,
    Nome   VARCHAR(23) NOT NULL,
    DataNasc DATE NOT NULL,
    Sexo         ENUM('M','F'),
    Cidade      VARCHAR(32),
    Rua         VARCHAR(64) NOT NULL,
    Num         INT NOT NULL,
    Andar       VARCHAR(6),
    CP          VARCHAR(12) NOT NULL,
    Email       VARCHAR(32) NOT NULL,
    Senha       VARCHAR(8) NOT NULL,
    Telefone    VARCHAR(9) NOT NULL
);

CREATE TABLE DESCONTO
(
    ID              INT PRIMARY KEY AUTO_INCREMENT,
    CodigoDesconto  CHAR(8) NOT NULL,
    ValorDesconto   DECIMAL(6,2) NOT NULL,
    DataInicio      DATE NOT NULL,
    DataFim         DATE NOT NULL
);

CREATE TABLE ENCOMENDA_CLIENTE
(
    ID INT PRIMARY KEY AUTO_INCREMENT,
    DataPagamento DATE NOT NULL,
    ValorTotal DECIMAL(6,2) NOT NULL,
    DescontoAplicado INT ,
    Cliente INT NOT NULL,
    FOREIGN KEY(DescontoAplicado) REFERENCES DESCONTO(ID),
    FOREIGN KEY(Cliente) REFERENCES CLIENTE(ID)
);

CREATE TABLE STATUS_ENCOMENDA
(
    Id_Status   INT PRIMARY KEY AUTO_INCREMENT,
    NumPedido   INT NOT NULL,
    StatusEncomenda ENUM('Pago','Pendente','Cancelado', 'Entregue') NOT NULL,
    Descricao TEXT,
    FOREIGN KEY(NumPedido) REFERENCES ENCOMENDA_CLIENTE(ID)
);

-- INSERÇÕES

INSERT INTO FUNCIONARIO (Nome, DataNasc, Sexo, Cidade, Rua, Num, Andar, CP, Login, Senha) VALUES
('João', '1993-01-01', NULL, 'Porto', 'Rua Manuel', 34, NULL, '965039458', 'joao@gmail.com', 'dfkelosd'),
('Maria', '1967-05-01', 'F', 'Lisboa', 'Rua Lima', 54, '3º', '459340239', 'maria@gmail.com', 'gmdslore'),
('Pedro', '1979-06-08', 'M', 'Lisboa', 'Rua João II', 222, NULL, '485932058', 'pedro', 'esigdleo'),
('Joana', '1999-04-07', NULL, 'Madrid', 'Rua da Paz', 453, '5º', '432345678', 'joana', 'efgldskt'),
('Carlos', '1999-01-10', 'M', 'Braga', 'Rua Botafogo', 654, '7º', '978656742', 'carlos@hotmail.com', 'fodnvfds'),
('Marcos', '1987-12-12', 'M', 'Braga', 'Rua sequeira', 2, '6º', '165432789', 'marcos@gmail.com', 'prdfesak'),
('Carla', '2000-05-04', NULL, 'Porto', 'Rua da Paz', 566, NULL, '678345639', 'carla@gmail.com', 'rocmdfrt');

INSERT INTO CARGO (Nome, Salario, Descricao) VALUES
('Gerente', 1000.00, 'Gerente da empresa'),
('Vendedor', 500.00, 'Vendedor da empresa'),
('Gerente de Marketing', 300.00, 'Gerente do departamento de marketing'),
('Enhenheiro de Software', 800.00, NULL),
('Estagiário', 200.00, NULL);

INSERT INTO CARGO_FUNCIONARIO (IdCargo, IdFunc) VALUES
(1,1), (3,2),(2,3),(2,4),(4,5),(5,6),(5,7);

INSERT INTO DEPARTAMENTO (NomeDepartamento, Gerente, Descricao) VALUES
('Administração', 1, NULL),
('Marketing', 3, 'Departamento responsável por publicidade e RE'),
('TI', 4, 'Departamento lorem ipsum');


INSERT INTO CLIENTE (Nome, DataNasc, Sexo, Cidade, Rua, Num, Andar, CP, Email, Senha, Telefone) VALUES
('António', '2000-10-23', NULL, 'Braga', 'Rua Zé', 4353, '4º', 4593843, 'antonio32@gmail.com', 'skfjeror', '843954834'),
('Rita', '1999-10-15', 'F', 'Lisboa', 'Rua camará', 55, NULL, 2390598, 'rita234@gmail.com', 'sdfklsdy', '948394839'),
('Joana', '2000-10-23', NULL, 'Braga', 'Rua dom manuel', 22, '4º', 4593843, 'joana47@gmail.com', 'skfjeror', '843954834'),
('Carlos', '2001-06-18', 'M', 'Porto', 'Rua Amalia', 43, '2º', 4593843, 'car@hotmail.com', 'edef3e3r', '999948346'),
('João', '2009-06-15', 'M', 'Porto', 'Rua Peixoto', 7788, '4º', 4593843, 'jmc@hotmail.com', '2324fef3', '748349999'),
('Maria', '2008-07-15', 'F', 'Aveiro', 'Rua Maria Rita', 96, '7º', 4593843, 'mar@hotmail.com', '58473473', '998667346'),
('Afonso', '1995-05-16', 'M', 'Aveiro', 'Rua bandeirantes', 444, NULL, 4593843, 'afonso@gamil.com', '5sdfklsd', '843954834'),
('Joana Carla', '1996-10-14', NULL, 'Braga', 'Rua 31 de janeiro', 967, NULL, 4593843, 'joama@gmail.com', 'euh23ouh', '979048393'),
('Marcos', '1995-12-04', 'M', 'Aveiro', 'Rua Manuel de arriaga', 234, '1º', 4346542, 'marcos111@gmail.com', 'fgslgfwq', '904376949');

INSERT INTO DESCONTO (CodigoDesconto, ValorDesconto, DataInicio, DataFim) VALUES
('A3C2OZ23', 10.00, '2021-10-01', '2022-01-01'), ('FELZNATL', 5.00, '2021-12-20', '2022-01-01');

INSERT INTO ENCOMENDA_CLIENTE  (DataPagamento, ValorTotal, DescontoAplicado, Cliente) VALUES
('2021-05-10', 50.00, NULL, 1),
('2021-06-12', 60.00, NULL, 2),
('2021-12-20', 6.00, 2, 3),
('2021-12-21', 864.00, 2, 4),
('2018-06-17', 222.00, NULL, 3),
('2021-10-13', 450.00, 1, 3),
('2021-09-03', 743.00, NULL, 4),
('2019-03-04', 22.00, NULL, 1),
('2019-04-04', 11.00, NULL, 1),
('2021-04-28', 34.00, NULL, 3),
('2021-10-11', 17.00, 1, 3),
('2021-12-22', 18.00, 2, 4),
('2021-07-31', 190.00, NULL, 6),
('2021-08-01', 20.00, NULL, 6),
('2021-09-02', 111.00, NULL, 6),
('2021-10-03', 122.00, NULL, 9),
('2021-06-01', 19.00, NULL, 9);

INSERT INTO STATUS_ENCOMENDA(NumPedido, StatusEncomenda, Descricao) VALUES
(1, 'Entregue', 'pedido entregue ao cliente'),
(2, 'Pendente', 'pedido pendente de pagamento'),
(3, 'Pago', 'pedido pago'),
(4, 'Cancelado', 'pedido cancelado'),
(5, 'Pendente', 'pedido pendente de pagamento'),
(6, 'Pago', 'pedido pago'),
(7, 'Cancelado', 'pedido cancelado'),
(8, 'Pendente', 'pedido pendente de pagamento'),
(9, 'Pago', 'pedido pago'),
(10, 'Entregue', 'pedido entregue ao cliente'),
(11, 'Entregue', 'pedido entregue ao cliente'),
(12, 'Entregue', 'pedido entregue ao cliente'),
(13, 'Entregue', 'pedido entregue ao cliente'),
(14, 'Entregue', 'pedido entregue ao cliente'),
(15, 'Entregue', 'pedido entregue ao cliente'),
(16, 'Cancelado', 'pedido cancelado'),
(17, 'Cancelado', 'pedido cancelado');

INSERT INTO AUTOR (Nome) VALUES 
('Daví Bowimar'), ('John Coltrane'), ('Boogarins'), ('Mandragora'), ('Pavement'),('Ryuichi Sakamoto'),('Caetano Veloso');

INSERT INTO GENERO (Genero) VALUES
('Rock'), ('Pop'), ('Jazz'), ('Eletrónica'), ('Trance'), ('Psicodélico'), ('Experimental'), ('Samba'), ('World Music');

INSERT INTO DISCO (Autor, Titulo, AnoLançamento, Formato, NumFaixas, Duracao, Descricao) VALUES 
(1, 'Live at Bar do Zé', 1975, 'LP', 10, '01:11:12', 'Maiores sucessos gravado ao vivo no Bar do Ze.'),
(2, 'A Love Supreme', 1964, 'CD', 4, '00:39:12', 'Divisor de aguas no jazz modal. CD inclui livreto e faixas adicionais.'),
(1, 'A Ascensão e a Queda de Daví Bowimar e as Aranhas Marcianas', 1975, 'LP', 12, '00:59:12', NULL),
(3, 'Sombrou Dúvida', 2018, 'LP', 11, '00:59:12', 'Mais novo disco da banda goiana.'),
(3, 'Sombrou Dúvida', 2018, 'CD', 11, '00:59:12', 'Mais novo disco da banda goiana.'),
(4, '100% Fritação Bootleg', 2011, 'K7', 6, '00:30:12', 'Fita não oficial de apresentação no Universo Paralelo 2011'),
(5, 'Crooked Rain, Crooked Rain', 1994, 'LP', 12, '00:42:20', 'LP expandido remasterizado e esterelizado.'),
(5, 'Brighten the Corners', 1996, 'LP', 12, '01:01:10', 'LP expandido remasterizado e esterelizado.'),
(6, 'Live in Osaka', 2001, 'CD', 10, '00:45:10', NULL),
(7, 'Araçá Azul', 1973, 'LP', 10, '00:38:10', 'Controverso e experimental'),
(7, 'Domingo', 1967, 'CD', 9, '00:31:10', 'Com Gal Costa');

INSERT INTO GENEROS_DISCO (IdDisc, IdGen) VALUES
(1, 1), (2, 3), (6, 4), (6,5), (3,1), (4,1), (4,6),(5,1), (5,6), (7,1), (8,1), (9,4), (9,7), (9,9), (10,1), (10,8), (10,9), (11, 8), (11,9);

INSERT INTO PRODUTO (IdDisc, Valor, NumExemplares) VALUES
(1, 40.00, 20), (2, 35.00, 10), (6, 200.00, 1), (3, 65.00, 50), (5, 30.00, 0), (7, 50.00, 20), (8, 50.00, 18), (9, 30.00, 10), (10, 50.00, 8), (11, 25.00, 44);

INSERT INTO FORNECEDOR (NomeFornecedor, Cidade, Rua, Num, Andar, CP, Email, Telefone) VALUES
('Balaclava Records', 'São Paulo', 'Rua Tchurosbango Todosbagos', 392, NULL, '333999444', 'balaclava@gmail.com', '554199754118'),
('Casa Modal', NULL, 'Avenida da França', 1024, NULL, '4100176', 'casamodal@outlook.com', '925845291'),
('Big Phono', 'Londres', 'Earl Longjohnson Street', 5, '5Esq', '123455921', 'johnmclovin@bigphono.com', '44123456789');

INSERT INTO PEDIDO_FORNECEDOR (Fornecedor, Produto, NumUnidades, DataPedido) VALUES
(1, 1, 25, '2020-10-21'), 
(2, 2, 13, '2020-09-03'),
(2, 5, 17, '2019-09-03'),
(2, 6, 17, '2019-01-05'),
(3, 7, 51, '2019-03-20'),
(3, 9, 18, '2020-03-21'),
(1, 10, 2, '2021-06-21'),
(1, 8, 1, '2021-07-21'),
(1, 7, 1, '2021-08-16'),
(3, 4, 1, '2021-09-16'),
(3, 4, 1, '2021-10-17'),
(2, 5, 1, '2021-11-15'),
(2, 6, 1, '2021-12-03'),
(2, 8, 5, '2021-10-18');

DROP VIEW IF EXISTS DISCO_GENERO;


CREATE VIEW DISCO_GENERO   
(IdDisc, Titulo, AnoLançamento, Duracao, Formato, Descricao, Autor, Generos) 
AS       
    SELECT IdDisc, Titulo, AnoLançamento, Duracao, Formato, Descricao, AUTOR.Nome, GROUP_CONCAT(Genero)
    FROM DISCO JOIN AUTOR ON (Autor = IdAut) NATURAL JOIN GENEROS_DISCO NATURAL JOIN GENERO 
    GROUP BY Titulo
    ORDER BY Titulo   
;
