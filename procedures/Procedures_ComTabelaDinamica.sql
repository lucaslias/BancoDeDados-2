CREATE DATABASE empresa
GO
USE empresa

/*
-Considere a tabela Produto com os seguintes atributos: Produto (Codigo | Nome | Valor)
-Considere a tabela ENTRADA e a tabela SAÍDA com os seguintes atributos: (Codigo_Transacao | Codigo_Produto | Quantidade | Valor_Total)
-Cada produto que a empresa compra, entra na tabela ENTRADA. 
-Cada produto que a empresa vende, entra na tabela SAIDA.
-Criar uma procedure que receba um código (‘e’ para ENTRADA e ‘s’ para SAIDA), 
-criar uma exceção de erro para código inválido, receba o codigo_transacao, codigo_produto e a quantidade e
	preencha a tabela correta, com o valor_total de cada transação de cada produto.


	CONSTRAINT FK_ID_Autor FOREIGN KEY (ID_Autor) REFERENCES tbl_Autor (ID_Autor)
*/

CREATE TABLE tbl_Produto (
CodigoProduto SMALLINT PRIMARY KEY,
Nome VARCHAR(30) NOT NULL,
Valor MONEY NOT NULL
)

CREATE TABLE tbl_Entrada(
ID_Transacao SMALLINT IDENTITY,
CodigoProduto SMALLINT,
Quantidade SMALLINT NOT NULL,
ValorTotal MONEY NOT NULL,
CONSTRAINT PK_CodigoProdutoEntrada PRIMARY KEY (CodigoProduto, ID_Transacao),
CONSTRAINT FK_CodigoProdutoEntrada FOREIGN KEY (CodigoProduto) REFERENCES tbl_Produto(CodigoProduto),
)

CREATE TABLE tbl_Saida(
ID_Transacao SMALLINT IDENTITY,
CodigoProduto SMALLINT,
Quantidade SMALLINT NOT NULL,
ValorTotal MONEY NOT NULL,
CONSTRAINT PK_CodigoProdutoSaida PRIMARY KEY (CodigoProduto, ID_Transacao),
CONSTRAINT FK_CodigoProdutoSaida FOREIGN KEY (CodigoProduto) REFERENCES tbl_Produto(CodigoProduto),
)

ALTER PROCEDURE p_insercao(@procedimento CHAR(1) , @codigoProduto SMALLINT, @nome VARCHAR(30), @valor MONEY, @quantidade SMALLINT)
AS

	DECLARE @tabela VARCHAR(7)
	DECLARE @query VARCHAR(MAX)
	DECLARE @valorTotal Money
	DECLARE @erro VARCHAR(MAX)

	SET @valorTotal = @valor * @quantidade
	print @valorTotal


	IF (@procedimento = 'e')
	BEGIN
		SET @tabela = 'Entrada'
	END
	ELSE
	BEGIN
		IF(@procedimento = 's')
		BEGIN
			SET @tabela = 'Saida'
		END
		ELSE
		BEGIN
			RAISERROR('Codigo de transacao invalido', 16, 1)
		END
	END

	SET @query = 'INSERT INTO tbl_'+@tabela+' VALUES (' + CAST(@codigoProduto AS varchar(4)) +','+ CAST(@quantidade AS varchar(4)) + ',' + CAST(@valorTotal AS VARCHAR(15)) + ')'
	Print @query

	BEGIN TRY
		INSERT INTO tbl_Produto VALUES (@codigoProduto, @nome, @valor)
		EXEC (@query)
	END TRY
	BEGIN CATCH
		SET @erro = ERROR_MESSAGE()
		IF (@erro LIKE '%primary%')
		BEGIN
			RAISERROR('ID produto do produto duplicado', 16, 1)
		END
		ELSE
		BEGIN
			RAISERROR('Erro de processamento', 16, 1)
		END
	END CATCH

	EXEC p_insercao @procedimento = 'e', @codigoProduto = 100, @nome = 'videogame', @valor = 200.00, @quantidade = 2
	EXEC p_insercao @procedimento = 's', @codigoProduto = 101, @nome = 'jogo', @valor = 10.00, @quantidade = 5

	

	SELECT * FROM tbl_Entrada
	SELECT * FROM tbl_Saida
	SELECT * FROM tbl_Produto

	DELETE from tbl_Produto WHERE CodigoProduto = 100
	DELETE from tbl_Entrada WHERE CodigoProduto = 100

