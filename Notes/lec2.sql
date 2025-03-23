CREATE DATABASE IF NOT EXISTS umich_emp;

USE umich_emp;

CREATE TABLE IF NOT EXISTS dept (
    dept_id INT AUTO_INCREMENT PRIMARY KEY,
    dept_name VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS employees (
    umid BIGINT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    uniqname VARCHAR(50) UNIQUE NOT NULL,
    age INT CHECK(age >= 17),
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES dept(dept_id)
);

INSERT INTO dept(dept_name) VALUES ('Teaching Staff');
INSERT INTO dept(dept_name) VALUES ('Executive');
INSERT INTO dept(dept_name) VALUES ('ITS');

INSERT INTO employees(first_name, last_name, uniqname, umid, age, dept_id)
VALUES ('Brinda', 'Mehra', 'brinda', 12345, 24, 2);

INSERT INTO employees (first_name, last_name, uniqname, umid, age, dept_id) 
VALUES ('Elaine', 'Czarnik', 'eczarnik', 67891, 29, 1);

SELECT * FROM employees

CREATE UNIQUE INDEX idx_uniqname ON employees(uniqname);

SHOW INDEX FROM employees;
-- There would be 2 index for uniqname, because sql automatically create index for columns with UNIQUE constraint

SET autocommit = 0; -- disables auto-committing after each statement

BEGIN; -- explicitly starts a transaction
SAVEPOINT original;

INSERT INTO employees(first_name, last_name, uniqname, umid, age, dept_id) values (
    'Michael', 'Hess', 'mlhess', 445533, 21, 3
);

SAVEPOINT new1;

INSERT INTO employees(first_name, last_name, uniqname, umid, age, dept_id) values (
    'Brinda', 'Gokul', 'bgokul', 667744, 32, 1
);

SELECT * FROM employees;

ROLLBACK TO SAVEPOINT new1;

COMMIT -- save the transaction