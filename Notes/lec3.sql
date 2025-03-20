USE bikes;

DESC employees;

SELECT e.employee_id, e.first_name, e.lASt_name, e.salary FROM employees e
WHERE e.salary IN (
    SELECT salary FROM employees
    ORDER BY salary DESC
)
LIMIT 1

-- subquery
SELECT e.employee_id, e.first_name, e.lASt_name, e.salary FROM employees e
WHERE e.salary IN (
    SELECT MAX(e.salary) FROM employees e
) OR (
    e.salary > (
        SELECT avg(e.salary) * 1.2 FROM employees e
    )
)

SELECT e.employee_id, e.first_name, e.lASt_name, e.salary FROM employees e
WHERE e.salary IN (
    SELECT max(e.salary) FROM employees e
)


--derived table
SELECT citysalary.city, citysalary.total_salary
FROM (
    SELECT l.city, SUM(e.salary) AS total_salary
    FROM employees e
    JOIN departments d on e.department_id = d.department_id
    JOIN locations l on d.location_id =  l.location_id-- multiple table JOINs
    GROUP BY l.city
) AS citysalary -- must have table aliAS for derived tables
WHERE citysalary.total_salary > 30000



-- SELECT employees whose salary are greater than the average salary of their department
-- correlated subquery
SELECT e1.employee_id, e1.salary, e1.department_id FROM employees e1 -- could use table aliAS for any table
WHERE e1.salary > (SELECT avg(e2.salary) FROM employees e2 WHERE e1.department_id = e2.department_id);
-- could directly compare with the single SELECTed result

-- indpt subquery
SELECT e1.employee_id, e1.salary, e1.department_id FROM employees e1
WHERE e1.salary > (
        SELECT avg_salary FROM (
            SELECT AVG(salary) AS avg_salary, department_id
            FROM employees 
            GROUP BY department_id
        ) avg_s
        WHERE e1.department_id = avg_s.department_id
    );

-- JOIN
SELECT e1.employee_id, e1.salary, e1.department_id FROM employees e1
JOIN (
    SELECT AVG(e2.salary) AS avg_salary, e2.department_id
    FROM employees e2
    GROUP BY department_id
) avg_s
ON avg_s.department_id = e1.department_id


-- CTE
WITH citysalary AS (
    SELECT l.city, SUM(e.salary) AS total_salary
    FROM employees e
    JOIN departments d on e.department_id = d.department_id
    JOIN locations l on d.location_id =  l.location_id-- multiple table JOINs
    GROUP BY l.city
)
SELECT cs.total_salary > 3000 FROM citysalary cs

WITH citysalary AS (
    SELECT l.city, SUM(e.salary) AS total_salary
    FROM employees e
    JOIN departments d on e.department_id = d.department_id
    JOIN locations l on d.location_id =  l.location_id
    GROUP BY l.city
)
SELECT cs.city, cs.total_salary FROM citysalary cs WHERE cs.total_salary > 30000 
UNION ALL -- with CTE, we can reuse the table citysalary
SELECT cs.city, cs.total_salary FROM citysalary cs WHERE cs.total_salary < 15000 

-- but for derived tables, we must rewrite the table definition
SELECT citysalary.city, citysalary.total_salary
FROM (
    SELECT l.city, SUM(e.salary) AS total_salary
    FROM employees e
    JOIN departments d ON e.department_id = d.department_id
    JOIN locations l ON d.location_id =  l.location_id
    GROUP BY l.city
) AS citysalary
WHERE citysalary.total_salary > 30000
UNION ALL
SELECT citysalary.city, citysalary.total_salary
FROM (
    SELECT l.city, SUM(e.salary) AS total_salary
    FROM employees e
    JOIN departments d ON e.department_id = d.department_id
    JOIN locations l ON d.location_id =  l.location_id
    GROUP BY l.city
) AS citysalary
WHERE citysalary.total_salary < 15000