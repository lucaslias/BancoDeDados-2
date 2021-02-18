CREATE DATABASE exercicioUnionView
GO
USE exercicioUnionView

CREATE TABLE curso(
codigoCurso INT NOT NULL,
nomeCurso VARCHAR(70) NOT NULL,
siglaCurso VARCHAR(10) NOT NULL,
PRIMARY KEY (codigoCurso)
)

CREATE TABLE aluno(
ra CHAR(7) NOT NULL,
nomeAluno VARCHAR(250) NOT NULL,
codigoCurso INT NOT NULL,
PRIMARY KEY (ra),
FOREIGN KEY (codigoCurso) REFERENCES curso(codigoCurso)
)

CREATE TABLE palestrante(
codigoPalestrante INT IDENTITY(1001,1),
nomePalestrante VARCHAR(250) NOT NULL,
empresa VARCHAR(100) NOT NULL,
PRIMARY KEY (codigoPalestrante)
)

CREATE TABLE palestra(
codigoPalestra INT IDENTITY(2001,1),
tituloPalestra VARCHAR(MAX) NOT NULL,
cargaHoraria INT NOT NULL,
dataPalestra DATETIME NOT NULL,
CodigoPalestrante INT NOT NULL,
PRIMARY KEY (codigoPalestra),
FOREIGN KEY (CodigoPalestrante) REFERENCES palestrante(CodigoPalestrante)
)

CREATE TABLE alunoInscrito(
ra CHAR(7) NOT NULL,
codigoPalestra INT NOT NULL,
PRIMARY KEY (ra,codigoPalestra),
FOREIGN KEY (ra) REFERENCES aluno(ra),
FOREIGN KEY (codigoPalestra) REFERENCES palestra(codigoPalestra)
)

CREATE TABLE aluno_nao(
rg VARCHAR(9) NOT NULL,
orgaoExp CHAR(5) NOT NULL,
nome VARCHAR(250) NOT NULL,
PRIMARY KEY (rg,orgaoExp)
)

CREATE TABLE alunoNaoInscrito(
codigoPalestra INT NOT NULL,
rg VARCHAR(9) NOT NULL,
orgaoExp CHAR(5) NOT NULL,
PRIMARY KEY (codigoPalestra,rg,orgaoExp),
FOREIGN KEY (codigoPalestra) REFERENCES palestra(codigoPalestra),
FOREIGN KEY (rg,orgaoExp) REFERENCES aluno_nao(rg,orgaoExp),
)

INSERT INTO curso VALUES
(1, 'curso1', 'cs1'),
(2, 'curso2', 'cs2'),
(3, 'curso3', 'cs3')
SELECT * FROM curso

INSERT INTO aluno VALUES
(1234567, 'joao', 1),
(7654321, 'maria', 2),
(1237654, 'jose', 3)
SELECT * FROM aluno

INSERT INTO palestrante VALUES
('paulo', 'pauloscorp'),
('paulao', 'paulaoinc'),
('paulinho', 'paulinholtda')
SELECT * FROM palestrante

INSERT INTO palestra VALUES
('aprenda a programar', 15, '12-02-2020', 1003),
('motivos para nao usar wordpress',1, '14-02-2021',1002)
SELECT * FROM palestra

INSERT INTO alunoInscrito VALUES
(1234567,2001),
(7654321,2002),
(1237654,2002)
SELECT * FROM alunoInscrito

INSERT INTO aluno_nao VALUES
(123456789, 'abc', 'renan'),
(987654321, 'ssp', 'lady anne')
SELECT * FROM aluno_nao

INSERT INTO alunoNaoInscrito VALUES
(2002, 123456789, 'abc'),
(2002, 987654321, 'ssp')
SELECT * FROM alunoNaoInscrito

-- Num_Documento, Nome_Pessoa, Titulo_Palestra, Nome_Palestrante, Carga_Horária e Data
-- A condição da consulta é o código da palestra
-- O Num_Documento se referencia ao RA para alunos e RG + Orgao_Exp para não alunos
-- ordenada pelo Nome_Pessoa. 
-- Fazer uma view de select que forneça a saída conforme se pede. 

CREATE VIEW v_todasPessoas
AS
SELECT	CAST(aluno.ra AS VARCHAR(25)) AS numDocumento, 
		aluno.nomeAluno as nome,
		alunoInscrito.codigoPalestra as codiguin
FROM aluno INNER JOIN alunoInscrito
ON aluno.ra = alunoInscrito.ra
UNION
SELECT	CAST(alunoNaoInscrito.rg + ' - ' + aluno_nao.orgaoExp AS VARCHAR(25)),
		aluno_nao.nome,
		alunoNaoInscrito.codigoPalestra
FROM aluno_nao INNER JOIN alunoNaoInscrito
ON aluno_nao.rg = alunoNaoInscrito.rg AND aluno_nao.orgaoExp = alunoNaoInscrito.orgaoExp

select * from  v_todasPessoas

CREATE VIEW v_palestrantesPalestras
AS
SELECT palestra.tituloPalestra,palestrante.nomePalestrante, palestra.cargaHoraria, palestra.dataPalestra, palestra.codigoPalestra
FROM palestra INNER JOIN palestrante
ON palestra.CodigoPalestrante = palestrante.codigoPalestrante

select * from  v_palestrantesPalestras

CREATE VIEW v_lista
AS
SELECT v_todasPessoas.numDocumento, v_todasPessoas.nome, v_palestrantesPalestras.tituloPalestra, v_palestrantesPalestras.nomePalestrante,
			v_palestrantesPalestras.cargaHoraria, v_palestrantesPalestras.dataPalestra
from v_palestrantesPalestras INNER JOIN v_todasPessoas
ON v_palestrantesPalestras.codigoPalestra = v_todasPessoas.codiguin
WHERE v_todasPessoas.codiguin = 2002

select * from  v_lista ORDER BY v_lista.nome


