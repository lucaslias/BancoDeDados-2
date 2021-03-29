/*
tabelas:
Cliente (CPF, nome, telefone, e-mail)
Produto (Código, nome, descrição, valor_unitário)
Venda (CPF_Cliente, Código_Produto, Quantidade, Data(Formato DATE))



a) Uma Function que Retorne uma tabela:
(Nome_Cliente, Nome_Produto, Quantidade, Valor_Total)
 */

CREATE FUNCTION fn_venda()
RETURNS @table TABLE(
nomecli VARCHAR(50),
nomeprod VARCHAR(50),
quantidade SMALLINT,
total MONEY
)
AS
BEGIN
	INSERT INTO @table (nomecli,nomeprod,quantidade,total)
		SELECT c.nome, p.nomeProd, v.quantidade, (v.quantidade * p.valorProd) as total
		FROM cliente as c INNER JOIN venda as v
		ON c.cpf = v.fk_cpf
		INNER JOIN produto as p
		ON p.codigoProd = v.fk_codProduto
	RETURN 
END

select * from fn_venda()


/*
b) Uma Scalar Function que Retorne a soma dos produtos comprados na Última Compra
*/
CREATE FUNCTION fn_ultimaCompra()
RETURNS MONEY
AS
BEGIN
	DECLARE @valortotal MONEY
	DECLARE @codCompra SMALLINT

	SET @valortotal = (SELECT TOP(1) codigoVenda from venda ORDER BY codigoVenda DESC)


	SET @valortotal = 
		(SELECT (p.valorProd * v.quantidade) as valor
		FROM produto as p INNER JOIN venda as v
		ON p.codigoProd = v.fk_codProduto
		WHERE v.codigoVenda = 4
		)


	RETURN @valortotal
END

SELECT dbo.fn_ultimaCompra() AS 'valor da ultima venda'
