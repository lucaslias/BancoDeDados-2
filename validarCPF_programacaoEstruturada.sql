CREATE DATABASE validaCpf
GO 
USE validaCpf

DECLARE @cpf  CHAR(11)
DECLARE @numero INT
DECLARE	@soma INT
DECLARE @resto INT

DECLARE	@digitoUm INT
DECLARE	@digitoDois INT

DECLARE @cont INT
DECLARE @contDigUm INT
DECLARE @contDigDois INT

SET @cont = 1
SET @soma = 0
SET @contDigUm = 10
SET @contDigDois = 11
SET @cpf = '22233366638'

-------------------- valida se todos os numeros sao iguais -----------------------

DECLARE @novoCont INT
DECLARE @outroValor INT
DECLARE @contValida INT

SET @novoCont = 1
SET @contValida = 1
SET @outroValor = CAST(SUBSTRING(@cpf,1, 1) as int)

WHILE (@novoCont <= 10)
BEGIN
	SET @novoCont = @novoCont + 1

	IF(@outroValor = CAST(SUBSTRING(@CPF, @novoCont, 1) as INT))
	BEGIN
		SET @contValida = @contValida + 1
	END
	
END

IF (@contValida = 11)
BEGIN
	PRINT 'Esse numero nao é valido, pois é todo igual'
	set noexec on
END








---------------------- Validacao dos digitos de cpf -----------------------
WHILE (@cont <= 9)
BEGIN
	SET @numero = CAST(SUBSTRING(@cpf,  @cont, 1) as INT)
	SET @soma = @soma + (@numero * @contDigUm)
	SET @contDigUm = @contDigUm - 1
	SET @cont = @cont + 1
END

SET @resto = @soma % 11
SET @digitoUm = CAST(SUBSTRING(@cpf, 10, 1) as INT)

IF(@resto < 2)
BEGIN
	IF(@digitoUm = 0)
	BEGIN
		PRINT 'O digito um é valido'
	END
END
ELSE
BEGIN
	IF(@digitoUm = (11 - @resto))
	BEGIN
		 PRINT 'O digito um é valido'
	END
	ELSE
	BEGIN
		PRINT 'O primeiro digito não é valido'
	END
END

SET @cont = 1
SET @soma = 0
SET @resto = 0

WHILE (@cont <= 10)
BEGIN
	SET @numero = CAST(SUBSTRING(@cpf,  @cont, 1) as INT)
	SET @soma = @soma + (@numero * @contDigDois)
	SET @contDigDois = @contDigDois - 1
	SET @cont = @cont + 1
END

SET @resto = @soma % 11
SET @digitoDois = CAST(SUBSTRING(@cpf, 11, 1) as INT)

IF(@resto < 2)
BEGIN
	IF(@digitoDois = 0)
	BEGIN
		PRINT 'O digito dois é valido'
	END
END
ELSE
BEGIN
	IF(@digitoDois = (11 - @resto))
	BEGIN
		 PRINT 'O digito dois é valido'
	END
	ELSE
	BEGIN
		PRINT 'O digito dois não é valido'
	END
END

set noexec off

