USE hr;

-- 1.1 Uma vista para os empregados onde é possivel ter acesso ao id, primeiro nome, último nome e salário (incluindo comissão quando existe)
CREATE OR REPLACE VIEW v_employees AS
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, SALARY + IFNULL(COMMISSION_PCT, 0)*SALARY AS FULL_SALARY
FROM employees;

-- testar vista
SELECT * FROM v_employees;


-- 1.2 Atualize a comissão do empregado cujo id é 100 para 25%. Consulte a vista e verifique a alteração do resultado na vista.
UPDATE employees SET COMMISSION_PCT = 0.25 WHERE EMPLOYEE_ID = 100;

-- confirmar a atualização do salário do empregado 100
SELECT * FROM v_employees WHERE EMPLOYEE_ID = 100;


-- 1.3 Crie uma vista v_job que permite obter os valores mínimo, médio e máximo do salário de cada função (JOB_ID)
CREATE OR REPLACE VIEW v_salaries AS
SELECT JOB_ID, MIN(SALARY) SAL_MINIMO, AVG(SALARY) SAL_MEDIO, MAX(SALARY) SAL_MAXIMO
FROM employees
GROUP BY JOB_ID;


-- 1.4 Utilize a vista anterior para obter a lista de JOB_ID e salários médios para as funções cujo salário médio é superior a 10000.
SELECT * 
FROM v_salaries
WHERE SAL_MEDIO > 10000;


-- 2.1 Quais os índices da tabela employees e os vários atributos (tipo de índice, sequência, etc)
SHOW INDEX FROM employees;


-- 2.2 Adicione um índice para o telefone de empregados e volte a verificar os índices existentes
CREATE UNIQUE INDEX ix_telemployees ON employees (phone_number);
-- verificar indices para confirmar criação
SHOW INDEX FROM employees;

-- 2.3 Remova o índice que adicionou no ponto anterior
DROP INDEX ix_telemployees ON employees;