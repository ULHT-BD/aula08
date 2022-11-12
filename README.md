# aula08
Nas aulas anteriores utilizámos a linguagem SQL para efetuar consultas de dados, recuperando dados e efetuando operações sobre estes de forma a obter a informação desejada. Nesta aula olhamos para a cláusula CREATE e respetica sintaxe, um comando que nos permite criar novas relações de acordo com o esquema definido.
Bom trabalho!

[0. Requisitos](#0-requisitos)

[1. CREATE TABLE](#1-create-table)

[2. Tipos de Dados](#2-tipo-de-dados)

[3. Restrições de Integridade](#3-restrições-de-integridade)

[4. DESCRIBE e SHOW CREATE TABLE](#4-describe-e-show-create-table)

[5. ALTER TABLE](#5-alter-table)

[6. INSERT INTO SELECT](#6-insert-into-select)

[7. Trabalho de Casa](#7-trabalho-de-casa)

[Bibliografia e Referências](#bibliografia-e-referências)

[Outros](#outros)

## 0. Requisitos
Requisitos: Para esta aula, precisa de ter o ambiente de trabalho configurado ([Docker](https://www.docker.com/products/docker-desktop/) com [base de dados HR](https://github.com/ULHT-BD/aula03/blob/main/docker_db_aula03.zip) e [DBeaver](https://dbeaver.io/download/)). Caso ainda não o tenha feito, veja como fazer seguindo o passo 1 da [aula03](https://github.com/ULHT-BD/aula03/edit/main/README.md#1-prepare-o-seu-ambiente-de-trabalho).

Caso já tenha o docker pode iniciá-lo usando o comando ```docker start mysgbd``` no terminal, ou através do interface gráfico do docker-desktop:
<img width="1305" alt="image" src="https://user-images.githubusercontent.com/32137262/194916340-13af4c85-c282-4d98-a571-9c4f7b468bbb.png">

Deve também ter o cliente DBeaver.

## 1. CREATE TABLE
A cláusula ```CREATE TABLE``` permite criar uma nova relação de acordo com o esquema definido, esquema este que determina o conjunto de valores válidos para o modelo de dados a representar.

A sintaxe geral é 
``` sql
CREATE TABLE nome_relacao (
 definicao_coluna1,
 definicao_coluna2,
 ...,
 restricoes_integridade
)
```

onde cada definição de coluna é definida por
``` sql
nome_coluna tipo_dados [restricoes_integridade]
```

e cada restrição de integridade pode ser definida por
``` sql
[CONSTRAINT nome] restricao_integridade
```

Exemplo:
``` sql
CREATE TABLE pessoa (
  nif CHAR(9),
  nome VARCHAR(50),
  PRIMARY KEY(nif)
);
```

Podemos apagar relações (removendo também todo o seu conteúdo) recorrendo à instrução ```DROP TABLE```

Exemplo
``` sql
DROP TABLE pessoa;
```

## 2. Tipo de Dados
Uma base de dados pode conter vários tipos de dados diferentes. Na [aula 5](https://github.com/ULHT-BD/aula05), usámos já várias funções de linha que permitem manipular e efetuar operações com os principais tipos de dados numéricos, texto ou datas.

Quando definimos uma relação, no seu esquema, devemos definir o domínio (ou tipo de dados) de cada um dos seus atributos. O domínio é definido tendo em conta o tipo de dados que queremos representar, tamanho e operações que iremos efetuar sobre eles.

Em MySQL, podemos definir atributos de vários tipos numéricos:
![image](https://user-images.githubusercontent.com/32137262/200440871-ef59a65d-916c-4fbc-9dad-4f1a1e778b56.png)

Podemos ainda usar ```FLOAT```, números de vírgula flutuante simples de 32B e ```DOUBLE``` números de vírgula flutuante duplos 64B.

Podemos guardar valores de texto:
|Tipo|Descrição|
|---------|---------|
|```CHAR```|Sequência de caracteres de comprimento fixo|
|```VARCHAR```|Sequência de caracteres de comprimento variável|
|```TEXT```|Sequência de caracteres de comprimento variável longo (existem também ```TINYTEXT, MEDIUMTEXT, LONGTEXT```)|


Podemos ainda guardar valores de data e hora:
|Tipo|Descrição|
|---------|---------|
|```DATE```|Guarda a data no formato ano-mês-dia, e.g. 2022-11-08|
|```TIME```|Guarda a hora no formato hora:min:seg, e.g. 08:05:00|
|```DATETIME```|Guarda a data e hora no formato ano-mês-dia hora:minuto:segundo, e.g. 2022-11-08 08:05:00|
|```YEAR```|Guarda o ano, e.g. 2022|

Existem vários [outros](https://dev.mysql.com/doc/refman/8.0/en/data-types.html) tipos de dados, por exemplo JSON, espaciais, etc.

### Exercícios
Qual o tipo de dados que utilizaria para representar:
1. Nome próprio e apelido
2. NIF, cartao do cidadão, telefone ou código postal
3. Idade, salário, data de nascimento


## 3. Restrições de Integridade
Restrições de integridade são um conjunto de regras que queremos impôr ao nosso modelo de dados para garantir que o modelo de dados é válido (e.g. qualquer cidadão possui obrigatóriamente um número de cartão de cidadão, um número único e diferente para cada cidadão). Estas regras devem ser codificadas em SQL de forma a impôr a sua obrigatoriedade durante inserção ou manipulação dos dados.

Importante referir quatro restrições de integridade que podemos impôr em SQL:
|Restrição|SQL|Descrição|
|---------|---|---------|
|Primary Key|```PRIMARY KEY(col1, col2, ...)```|Chave primária, é um atributo obrigatório e único para cada tuplo. É o atributo que identifica de forma única cada um dos tuplos|
|Unique Key|```UNIQUE(col)```|Chave candidata, atributo cujos valores são obrigatoriamente únicos|
|Not Null|```NOT NULL```|Um valor tem de ser obrigatoriamente atribuido à coluna em questão. Não pode ser ```NULL```|
|Check|```CHECK(condição)```|O valor na coluna deve respeitar a condição indicada|

Exemplo:
``` sql
CREATE TABLE pessoa (
  nif CHAR(9),
  cartao_cidadao CHAR(8),
  nome VARCHAR(50) NOT NULL,
  idade TINYINT,
  CONSTRAINT pessoa_PrimaryKey PRIMARY KEY(nif),
  CONSTRAINT pessoa_CandidateKey UNIQUE(cartao_cidadao),
  CONSTRAINT pessoa_ColumnConstraint CHECK(idade >= 0 AND idade<150)
);
```


### Exercícios
Para cada uma das alíneas seguintes, escreva a query que permite criar e teste seguidamente inserir valores que não respeitam as restrições definidas:
1. A relação aluno(cartao_cidadao, nif, nome, apelido, email, idade), a idade deve ser superior a 18 e inferior a 100
2. A relação empregado(nome_proprio, apelido, nif, cartao_cidadao, niss, telefone, salario, rua, codigo_postal), o salário deve ser superior ao salário mínimo
3. A relação veiculo(matricula, tipo, marca, modelo, ano), onde a marca pode ser VW, Renault, Tesla ou BMW e tipo pode ser mercadorias ou passageiros
4. A relação employees2 cujo esquema é igual ao da relação employees.

Nota: quando não sabemos se uma relação existe podemos usar a cláusula ```IF NOT EXISTS``` para apenas criar caso a relação ainda não exista
Exemplo:
``` sql
CREATE TABLE IF NOT EXISTS pessoa (
  nif CHAR(9),
  nome VARCHAR(50),
  PRIMARY KEY(nif)
);
```

## 4. DESCRIBE e SHOW CREATE TABLE
As cláusulas ```DESCRIBE``` e ```SHOW CREATE TABLE``` permitem inspecionar a estrutura de uma relação já existente.

Exemplo:
``` sql
SHOW CREATE TABLE pessoa;
```

### Exercícios
Utilize a cláusula ```DESCRIBE``` e ```SHOW CREATE TABLE``` para verificar a estrutura da relação employees e compare com a employees2 que criou para verificar que são identicas.


## 5. ALTER TABLE
A Cláusula ```ALTER TABLE``` permite alterar o esquema de uma relação, nomeadamente renomear a tabela, adicionar ou alterar atributos. 

Exemplo, para alterar o nome da relação pessoa para cidadao:
``` sql
ALTER TABLE pessoa
RENAME TO cidadao;
```

Podemos adicionar atributos utilizando a cláusula ```ADD```
``` sql
ALTER TABLE pessoa
ADD telefone CHAR(9);
```
nota: podemos expliciar a ordem acrescentando ```FIRST``` para adicionar como primeira coluna ou ```AFTER col``` para adicionar após a coluna col. Podemos adicionar várias colunas utilizando uma cláusula ```ADD``` para cada coluna a adicionar.

A operação inversa ```DROP``` permite remover uma coluna da relação
``` sql
ALTER TABLE pessoa
DROP telefone;
```


Podemos modificar atributos utilizando a cláusula ```MODIFY```
``` sql
ALTER TABLE pessoa
MODIFY telefone CHAR(12);
```
nota: podemos expliciar a ordem acrescentando ```FIRST``` para modificar ordem para primeira coluna ou ```AFTER col``` ou para para após a coluna col. Podemos modificar várias colunas utilizando uma cláusula ```MODIFY``` para cada coluna a modificar.

Podemos também modificar nome de atributos, exemplo mudar ```telefone``` para ```tel```
``` sql
ALTER TABLE pessoa
CHANGE COLUMN telefone tel CHAR(9);
```

Podemos ainda usar o ```ALTER TABLE``` adicionar restrições de integridade a relações existentes utilizando a sintaxe ```ADD CONSTRAINT nome restricao_integridade```, exemplo:
``` sql
ALTER TABLE pessoa
ADD CONSTRAINT pessoa_ColumnConstraint CHECK(idade >= 0 AND idade<150);
```

A operação inversa ```DROP CONSTRAINT``` permite remover uma restrição da relação
``` sql
ALTER TABLE pessoa
DROP CONSTRAINT pessoa_ColumnConstraint;
```

### Exercícios
Para cada uma das alíneas seguintes, escreva a query que permite obter. Introduza valores para testar:
1. Altere o nome da relação veiculo para automóvel e o atributo tipo para transporte
2. Adicione à relação viatura o nome do proprietário e o nif do proprietário
3. Na relação veiculo, altere o nome próprio do proprietário para que possa conter 200 caracteres e adicione um atributo para alcunha.

## 6. INSERT INTO SELECT
A cláusula ```INSERT INTO SELECT``` permite executar uma query numa relação e inserir o resultado numa outra relação
``` sql
INSERT INTO nova_relacao
SELECT col1, col2, ...
FROM antiga_relacao
WHERE condição;
```

### Exercícios
Para cada uma das alíneas seguintes, escreva a query que permite obter:
1. Copiar o conteúdo da relação employees para employees2 para empregados cujo o salário esteja entre 3000 e 8000 e a data de contratação seja posterior a 1 de janeiro de 2008.
2. Copiar os nomes próprios, apelidos e salário de employees para a relação empregado, para os empregados cujo nome começa por 'a' e que recebem alguma comissão.

## 7. Trabalho de Casa
Escreva um ficheiro SQL que responda às seguintes alíneas
1. Criar a Base de Dados CML_Contratos

2. Observe o conjunto de dados disponibilizados no ficherio xls pela Plataforma de Dados Abertos da Câmara Municipal de Lisboa sobre [Contratos de empreitadas de obras públicas e contratos de aquisição de serviços](https://dados.cm-lisboa.pt/dataset/538fedd0-69f8-464b-85c3-08bd2ecde103/resource/23aa7744-844c-49e5-9643-74855c25055c/download/contratos-de-empreitadas-de-obras-publicas-e-de-aquisicao-de-servicos.xlsx). Escreva o código SQL que permite criar uma tabela na base de dados que criou e que permita guardar os dados tendo em atenção o tipo de dados e restrições de integridade adequado a cada coluna. Escolha 5 contratos de empreitada do ficheiro de dados e escreva o código para inserir os tuplos escolhidos.

3. Escreva o código SQL que permite obter, para cada Entidade(s) Adjudicatária(s), o número de contratos celebrados, o preço contratual total e médio e o preço total efetivo total e médio.


Bom trabalho!

SUGESTÃO: se o problema parecer difícil ou estiver com dificuldades em obter o resultado final correto, tente subdividir o problema em partes obtendo isoladamente cada uma das condições pedidas.

NOTA: submeta a sua resposta ao trabalho de casa no moodle, um exercício por linha, num ficheiro de texto com o nome TPC_a07_[N_ALUNO].sql (exemplo: TPC_a07_12345.sql para o aluno número 12345).


## Bibliografia e Referências
* [mysqltutorial - CREATE TABLE](https://www.mysqltutorial.org/mysql-create-table/)
* [mysqltutorial - Data Types](https://www.mysqltutorial.org/mysql-data-types.aspx)
* [MySQL - Data Types](https://dev.mysql.com/doc/refman/8.0/en/data-types.html)
* [mysqltutorial - Storage Engines](https://www.mysqltutorial.org/understand-mysql-table-types-innodb-myisam.aspx)
* [w3schools - MySQL Functions](https://www.w3schools.com/mysql/mysql_ref_functions.asp)

## Outros
Para dúvidas e discussões pode juntar-se ao grupo slack da turma através do [link](
https://join.slack.com/t/ulht-bd/shared_invite/zt-1iyiki38n-ObLCdokAGUG5uLQAaJ1~fA) (atualizado 2022-11-03)
