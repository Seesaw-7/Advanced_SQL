USE bikes;

select concat(e1.first_name, ' ', e2.last_name) as employee_name,
        concat(e2.first_name, ' ', e2.last_name) as manager_name
from employees e1
join employees e2
on e1.manager_id = e2.employee_id

-- recursive CTE
-- base case
SELECT 
    e.employee_id, 
    e.first_name, 
    e.last_name, 
    e.manager_id, 
    CAST(CONCAT(e.first_name, ' ', e.last_name) AS CHAR(1000)) AS Manager -- cuz in later recursive CTE, this char will go very LONG
FROM employees e 
WHERE e.manager_id IS NULL;

WITH RECURSIVE orgchart AS ( -- RECURSIVE keyword
    SELECT 
        e.employee_id, 
        e.first_name, 
        e.last_name, 
        e.manager_id, 
        CAST(CONCAT(e.first_name, ' ', e.last_name) AS CHAR(1000)) AS Manager
    FROM employees e 
    WHERE e.manager_id IS NULL
    UNION ALL -- connect base case and recursive case
    SELECT 
        e.employee_id, -- if this is changed to oc.employee_id, the command will run forever,
        e.first_name,  -- cuz old employee_id will be inserted into the orgchart,
        e.last_name,   -- making oc.employee_id = e.manager_id continues be matched without termination
        e.manager_id, 
        CAST(CONCAT(e.first_name, ' ', e.last_name, '->', oc.Manager) AS CHAR(1000)) AS Manager 
    FROM employees e
    join orgchart oc
    on oc.employee_id = e.manager_id
)
SELECT * FROM orgchart;

-- hard to use join to perform recursive CTE, so we use union all to combine cases


-- join is done horizontally (adding columns)
SELECT 
    e.first_name AS employee_first_name, 
    e.last_name AS employee_last_name, 
    d.first_name AS dependent_first_name, 
    d.last_name AS dependent_last_name
FROM employees e 
JOIN dependents d 
ON e.employee_id = d.employee_id;

-- union is done vertically (adding rows)
SELECT first_name, last_name FROM employees
UNION
SELECT first_name, last_name FROM dependents;

SELECT first_name, last_name, salary FROM employees
UNION
SELECT first_name, last_name, null FROM dependents; -- must make the number of columns aligned

-- INTERSECT

-- EXCEPT


-- Temp Tables (remain for the duration of a session, beyond one query)
CREATE TEMPORARY TABLE empinfo AS 
SELECT 
    e.first_name, 
    e.last_name, 
    e.salary, 
    d.department_name 
FROM employees e 
JOIN departments d 
ON e.department_id = d.department_id;

SELECT AVG(salary) 
FROM empinfo 
WHERE department_name = 'Marketing';

SELECT AVG(salary) 
FROM empinfo 
WHERE department_name = 'Shipping';

DESC empinfo;

-- temp tables can be dropped
-- temp tables cannot be shown with `SHOW TABLES`


-- view, last for many sessions unless manually dropped
CREATE VIEW bikeorg AS
WITH RECURSIVE orgchart AS ( -- RECURSIVE keyword
    SELECT 
        e.employee_id, 
        e.first_name, 
        e.last_name, 
        e.manager_id, 
        CAST(CONCAT(e.first_name, ' ', e.last_name) AS CHAR(1000)) AS Manager
    FROM employees e 
    WHERE e.manager_id IS NULL
    UNION ALL -- connect base case and recursive case
    SELECT 
        e.employee_id, -- if this is changed to oc.employee_id, the command will run forever,
        e.first_name,  -- cuz old employee_id will be inserted into the orgchart,
        e.last_name,   -- making oc.employee_id = e.manager_id continues be matched without termination
        e.manager_id, 
        CAST(CONCAT(e.first_name, ' ', e.last_name, '->', oc.Manager) AS CHAR(1000)) AS Manager 
    FROM employees e
    join orgchart oc
    on oc.employee_id = e.manager_id
)
SELECT * FROM orgchart;

SHOW FULL TABLES; -- table types can be shown (view/base table)

DROP VIEW bikeorg;

SHOW TABLES;
