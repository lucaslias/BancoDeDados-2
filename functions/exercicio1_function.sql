CREATE DATABASE exercicio1Function
GO
USE exercicioFunction

CREATE TABLE produto1(
codigoPro SMALLINT PRIMARY KEY IDENTITY,
nome VARCHAR(50) NOT NULL,
valor MONEY NOT NULL,
qntEstoque SMALLINT NOT NULL
)

insert into produto1 VALUES 
('arroz', 10.00, 10),
('feijao', 15.00, 4),
('acucar', 9.00, 8)

select * from produto1

/*
a)Fazer uma Function que verifique, na tabela produtos (codigo, nome, valor unit�rio e qtd estoque)
Quantos produtos est�o com estoque abaixo de um valor de entrada
*/

CREATE FUNCTION fn_abaixoProduto(@qnt SMALLINT)
RETURNS SMALLINT
AS
BEGIN
	DECLARE @numero SMALLINT
	SET @numero = (SELECT COUNT(codigoPro) FROM produto1 WHERE qntEstoque < @qnt)

	RETURN @numero
END

SELECT dbo.fn_abaixoProduto(5) AS 'produto com pouco estoque'

/*
b)Fazer uma function que liste o c�digo, o nome e a quantidade dos produtos que est�o com o estoque 
abaixo de um valor de entrada
*/

CREATE FUNCTION fn_tabelaAbaixoProduto(@qnt SMALLINT)
RETURNS @table TABLE(
cod SMALLINT,
nome VARCHAR(50),
quantidade SMALLINT
)
AS
BEGIN
	INSERT INTO @table (cod,nome,quantidade)
		SELECT codigoPro, nome, qntEstoque FROM produto1 WHERE qntEstoque < @qnt
	RETURN 
END

select * from fn_tabelaAbaixoProduto(5)