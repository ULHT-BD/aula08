# aula08
Nas aulas anteriores utilizámos a linguagem SQL para efetuar criação de tabelas assim como consultas de dados, recuperando dados e efetuando operações sobre estes de forma a obter a informação desejada. Nesta aula olhamos para duas formas de otimização usando vistas e índices.
Bom trabalho!

[0. Requisitos](#0-requisitos)

[1. Views](#1-views)

[2. Indexes](#2-indexes)

[3. Trabalho de Casa](#3-trabalho-de-casa)

[4. Resoluções](#4-resoluções)

[Bibliografia e Referências](#bibliografia-e-referências)

[Outros](#outros)

## 0. Requisitos
Requisitos: Para esta aula, precisa de ter o ambiente de trabalho configurado ([Docker](https://www.docker.com/products/docker-desktop/) com [base de dados HR](https://github.com/ULHT-BD/aula03/blob/main/docker_db_aula03.zip) e [DBeaver](https://dbeaver.io/download/)). Caso ainda não o tenha feito, veja como fazer seguindo o passo 1 da [aula03](https://github.com/ULHT-BD/aula03/edit/main/README.md#1-prepare-o-seu-ambiente-de-trabalho).

Caso já tenha o docker pode iniciá-lo usando o comando ```docker start mysgbd``` no terminal, ou através do interface gráfico do docker-desktop:
<img width="1305" alt="image" src="https://user-images.githubusercontent.com/32137262/194916340-13af4c85-c282-4d98-a571-9c4f7b468bbb.png">

Deve também ter o cliente DBeaver.

## Relembre
Na aula07, vimos como podemos criar tabelas utilizando a cláusula CREATE TABLE e especificando o esquema da relação. Uma forma alternativa de criar tabelas é utilizando diretamente o resultado de um SELECT noutra tabela utilizando a sintaxe:

``` sql
CREATE TABLE tabela_copia AS
SELECT *
FROM tabela_origem;
```

Podemos evidentemente criar cópias iguais ou alteradas contendo apenas alguns atributos ou tuplos. Relembre o exercício 3.4 onde criou a tabela employees2 identica à tabela employees. Utilizando a sintaxe acima, poderia ter feito simplesmente:

``` sql
CREATE TABLE employees2 AS
SELECT *
FROM employees;
```

Note que neste caso o conteúdo também é copiado, no entanto pode filtrar de acordo que as condições que introduzir na cláusula SELECT.

## 1. Views
Vistas ou views em SQL são uma espécie de tabelas virtuais construídas a partir do resultado de uma execução de uma outra query. Podem ser vistas como o resultado de um SELECT ao qual foi dado atribuido um nome. Assim as vistas mantêm a estrutura de linhas/colunas e podem ser acedidas tal como uma tabela no entanto não são armazenadas de forma persistente pelo que não ocupam espaço adicional no disco. Cada vez que há um acesso a uma vista a query que lhe deu origem é recalculada.

A sintaxe para criarmos uma vista é semelhante a criar uma tabela com base numa query:
``` sql
CREATE VIEW v_tabela AS
SELECT col1, col2
FROM tabela;
```

Apesar de não ser obrigatório, é comum distinguir as vistas com um prefixo por exemplo ```v_```, ```view```, para facilmente distinguir uma tabela de uma vista.

Por exemplo podemos partir da relação estudante(numero, nome, nota_teorica, nota_pratica) e construir uma relação que mostra apenas o número e a nota final dos alunos aprovados:
``` sql
CREATE VIEW v_estudante_aprovado AS
SELECT numero, 0.5*nota_teorica + 0.5*nota_pratica as nota_final
FROM estudante
WHERE nota_teorica > 9.5 and + nota_pratica > 9.5;
```

Podemos depois executar queries sobre esta vista tal como fazemos sobre tabels, por exemplo:
``` sql
SELECT * FROM v_estudante_aprovado;
```

Podemos alterar vistas existentes usando o ```CREATE OR REPLACE VIEW```, por exemplo para alterar os atributos ecolhidos ou condição da query. Exemplo:
``` sql
CREATE OR REPLACE VIEW v_estudante_aprovado AS
SELECT numero, nome, nota_teorica + nota_pratica as nota_final
FROM estudante
WHERE nota_teorica > 9.5 and + nota_pratica > 9.5;
```

Uma vista pode ser apagada utilizando a cláusula ```DROP VIEW```:
``` sql
DROP VIEW vista;
```

Exemplo:
``` sql
DROP VIEW v_estudante_aprovado;
```

### Exercícios
Para cada uma das alíneas seguintes, escreva a query que permite obter:
1. Uma vista para os empregados onde é possivel ter acesso ao id, primeiro nome, último nome e salário (incluindo comissão quando existe)
2. Atualize a comissão do empregado cujo id é 100 para 25%. Consulte a vista e verifique a alteração do resultado na vista.
3. Crie uma vista v_job que permite obter os valores mínimo, médio e máximo do salário de cada função (JOB_ID)
4. Utilize a vista anterior para obter a lista de JOB_ID e salários médios para as funções cujo salário médio é superior a 10000.

## 2. Indexes
A criação de índices permite adicionar estruturas auxiliares que permitem otimizar a performance da execução das queries na base de dados. Podemos ter índices primários ou índices secundários.
Para verificar os índices de uma tabela podemos usar

``` sql
SHOW INDEX FROM tabela;
```
Um índice pode ser criado sobre um ou vários atributos, para criar um índice numa relação usamos a sintaxe:
``` sql
CREATE INDEX indice_nome ON tabela (atributos);
```

Por exemplo para criar um índice sobre o nif de um aluno, faríamos:
``` sql
CREATE INDEX ix_nifaluno ON aluno (nif);
```

Neste caso, sabemos que o nif é único para cada aluno e podemos adicionar essa restrição ao índice:
``` sql
CREATE UNIQUE INDEX ix_nifaluno ON aluno (nif);
```

Podemos apagar um índice utilizando a sintaxe:
``` sql
DROP INDEX ix_nifaluno ON aluno;
```

### Exercícios
Para cada uma das alíneas seguintes, escreva a query que permite obter:
1. Quais os índices da tabela employees e os vários atributos (tipo de índice, sequência, etc)
2. Adicione um índice para o telefone de empregados e volte a verificar os índices existentes
3. Remova o índice que adicionou no ponto anterior


## 3. Trabalho de Casa
Neste trabalho de casa irá começar a utilizar e a trabalhar na base de dados do projeto de base de dados. Comece por descarregar e examinar o [enunciado](https://moodle.ensinolusofona.pt/mod/resource/view.php?id=143098) do projeto e os respetivos [ficheiros de dados](https://moodle.ensinolusofona.pt/mod/resource/view.php?id=143097).

0. (opcional) Caso tenha tido dificuldade a criar uma nova base de dados no trabalho de casa da aula anterior, poderá dar a volta ao problema criando um novo container baseado na imagem db que criou na aula03 com novo mapping do port 3307

``` sh
docker run --name mysgbd_novo -p 3307:3306 -d db
```

Precisa agora de criar uma nova ligação (ou atualizar a antiga) para ligar à instância de MariaDB do container que acabou de criar.
<img width="1007" alt="image" src="https://user-images.githubusercontent.com/32137262/193685274-c7175ac4-881a-4b59-b019-273713ca8633.png">
* host: ```localhost```
* port: ```3307```
* user: ```root```
* password: ```admin```

<img width="680" alt="image" src="https://user-images.githubusercontent.com/32137262/202258030-d9e452f7-4cde-4aa3-b42f-a403d59e80cc.png">

1. Comece por criar a base de dados deisiflix e as tabelas load_movies, load_people, load_genres e load_voting correspondentes conforme o esquema apresentado no enunciado.
![image](https://user-images.githubusercontent.com/32137262/202258325-537b56a6-16eb-4d48-b224-73e4025a2ad6.png)

2. Carregue os dados utilizando a função import data no dbeaver carregando cada ficheiro de dados na tabela respetiva e mapeando as respetivas colunas. Confirme o correto carregamento dos dados.
<img width="353" alt="image" src="https://user-images.githubusercontent.com/32137262/202258869-122d343b-9024-4920-aaff-ef54e06c0ea8.png">

3. Os sistemas de Gestão de Base de Dados oferecem ferramentas de profiling que permitem medir a performance de execucao das queries. Neste trabalho iremos usar o profiler do MySQL para medir o tempo de execução de uma query antes e depois da criação de um índice de forma a verificar o ganho de performance. Active o profiler no MySQL usando a instrução para alterar a flag e iniciar a medição de performance nas queries seguintes:
``` sql
SET profiling=1;
flush status;
```

nota: o ```show profiles``` é o método mais antigo para profiling das queries mas que vamos usar aqui por ser mais simples. Será futuramente substituido pelo Performance Schema (incluí um mesmo exemplo com [show profiles](https://github.com/ULHT-BD/aula08/blob/main/Profiling_ShowProfiles.sql) e [performance schema](https://github.com/ULHT-BD/aula08/blob/main/Profiling_PerformanceSchema.sql) sobre uma [bd exemplo](https://github.com/ULHT-BD/aula08/blob/main/Profiling_SetupDB.sql) no repositório para quem esteja interessado).

4. Para testar a performance vamos usar a query
``` sql
SELECT sql_no_cache * 
FROM load_genres lg 
WHERE id_movie >400000 
ORDER BY id_movie DESC LIMIT 5;
```

nota: sql_no_cache permite garantir que não há otimização pelo MariaDB através da utilização de resultados desta query em cache

5. Crie um índice sobre o atributo movie_id

6. Execute novamente a mesma query

7. Utilize o comando:
``` sql
SHOW profiles;
```

Verifique o tempo de execução da query antes e depois do indice de forma a observar a melhoria que o índice introduziu. 

8. Adicione os índices pedidos nas restantes relações.


Bom trabalho!

NOTA: submeta a sua resposta ao trabalho de casa no moodle contendo a criação de base de dados, tabelas e índices num script sql. O ficheiro de texto com o nome TPC_a08_[N_ALUNO].sql (exemplo: TPC_a08_12345.sql para o aluno número 12345).


## 4. Resoluções
[Resolução dos exercícios em aula](https://github.com/ULHT-BD/aula08/blob/main/aula08_resolucao.sql)

[Resolução do trabalho de casa](https://github.com/ULHT-BD/aula08/blob/main/TPC_a08_resolucao.sql)

## Bibliografia e Referências
* [mysqltutorial - CREATE TABLE](https://www.mysqltutorial.org/mysql-create-table/)
* [mysqltutorial - Data Types](https://www.mysqltutorial.org/mysql-data-types.aspx)
* [MySQL - Data Types](https://dev.mysql.com/doc/refman/8.0/en/data-types.html)
* [mysqltutorial - Storage Engines](https://www.mysqltutorial.org/understand-mysql-table-types-innodb-myisam.aspx)
* [w3schools - MySQL Functions](https://www.w3schools.com/mysql/mysql_ref_functions.asp)

## Outros
Para dúvidas e discussões pode juntar-se ao grupo slack da turma através do [link](
https://join.slack.com/t/ulht-bd/shared_invite/zt-1iyiki38n-ObLCdokAGUG5uLQAaJ1~fA) (atualizado 2022-11-03)
