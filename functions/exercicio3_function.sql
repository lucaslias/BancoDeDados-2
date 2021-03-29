CREATE DATABASE exercicio3Function
GO
USE exercicio3Function

CREATE TABLE funcionario(
codigof SMALLINT PRIMARY KEY IDENTITY,
nome VARCHAR(50) NOT NULL,
salario MONEY NOT NULL
)

CREATE TABLE dependente(
codDependente SMALLINT PRIMARY KEY IDENTITY,
nomedep VARCHAR(50) NOT NULL,
salariodep MONEY NOT NULL,
codigoFun SMALLINT,
CONSTRAINT fk_codigof FOREIGN KEY (codigoFun) references funcionario(codigof)
)

INSERT INTO funcionario VALUES
('joao', 1000.00),
('maria', 1001.00)

INSERT INTO dependente VALUES
('bruno', 800.00, 1),
('bruna', 801.00, 1),
('luan', 700.00, 2),
('luana', 701.00, 2)

/*
a) Uma Function que Retorne uma tabela:
(Nome_Funcionário, Nome_Dependente, Salário_Funcionário, Salário_Dependente)
*/
CREATE FUNCTION fn_funcionario()
RETURNS @table TABLE(
nomefun VARCHAR(50),
nomedep VARCHAR(50),
salariofun MONEY,
salariodep MONEY
)
AS
BEGIN
	INSERT INTO @table (nomefun,nomedep,salariofun,salariodep)
		SELECT f.nome, d.nomedep, f.salario, d.salariodep
		FROM funcionario as f INNER JOIN dependente as d
		ON f.codigof = d.codigoFun
	RETURN 
END

select * from fn_funcionario()

/*
b) Uma Scalar Function que Retorne a soma dos Salários dos dependentes, mais a do funcionário.
*/
CREATE FUNCTION fn_somaSalario(@codigoFunc SMALLINT)
RETURNS MONEY
AS
BEGIN
	DECLARE @valortotal MONEY

	SET @valortotal = 
		(SELECT salario + 
		(
			SELECT SUM(d.salariodep)
			FROM funcionario as f INNER JOIN dependente as d
			ON f.codigof = d.codigoFun
			WHERE f.codigof = @codigoFunc
		)
		from funcionario WHERE codigof = @codigoFunc)

	RETURN @valortotal
END

SELECT dbo.fn_somaSalario(2) AS 'soma dos salarios'
