SELECT p.park, AVG(t.length) 
FROM trails t 
JOIN parks p ON t.park_id = p.id 
GROUP BY p.park;

SELECT AVG(length) 
FROM trails 
WHERE park_id = 22;

-- window function, they don't collapse
SELECT name, length, 
       AVG(length) OVER () AS avglength 
FROM trails 
WHERE park_id = 22;

SELECT 
    route_type_id, 
    name, 
    length, 
    AVG(length) OVER (PARTITION BY route_type_id) AS avgLength
FROM trails 
WHERE park_id = 22;

SELECT 
    route_type_id, 
    name, 
    length, 
    AVG(length) OVER (PARTITION BY route_type_id ORDER BY length) AS avgLength
FROM trails 
WHERE park_id = 22;
-- it calculates rolling averages (on currantly accumulated sum) instead of the static average
-- order by orders within each window section

SELECT 
    route_type_id, 
    name, 
    length, 
    AVG(length) OVER (PARTITION BY route_type_id) AS avgLength
FROM trails 
WHERE park_id = 22
ORDER BY length; -- this use the static average, but lose the partition


SELECT 
    route_type_id, 
    name, 
    length, 
    MIN(length) OVER (PARTITION BY route_type_id) AS avgLength
FROM trails 
WHERE park_id = 22;


SELECT route_type_id, name, length, 
       RANK() OVER (PARTITION BY route_type_id ORDER BY length) AS minlength 
FROM trails 
WHERE park_id = 22;
-- The reason RANK() ranks based on length is due to the syntax structure of the OVER() clause, specifically the ORDER BY inside it.

-- DENSE_RANK()
SELECT route_type_id, name, length, 
       DENSE_RANK() OVER (PARTITION BY route_type_id ORDER BY length) AS minlength 
FROM trails 
WHERE park_id = 22;

-- ROW_NUMBER()
SELECT route_type_id, name, length, 
       ROW_NUMBER() OVER (PARTITION BY route_type_id ORDER BY length) AS rownum, 
       DENSE_RANK() OVER (PARTITION BY route_type_id ORDER BY length) AS dense_rank 
FROM trails 
WHERE park_id = 22;

-- Modular window function
SELECT route_type_id, name, length, 
       ROW_NUMBER() OVER w AS rownum, 
       DENSE_RANK() OVER w AS ranked 
FROM trails 
WHERE park_id = 22
WINDOW w AS (PARTITION BY route_type_id ORDER BY length);

-- Ntile
SELECT route_type_id, name, length, 
       NTILE(5) OVER w AS bucket -- will have 5 buckets
FROM trails 
WHERE park_id = 22 AND route_type_id = 2
WINDOW w AS (PARTITION BY route_type_id ORDER BY length) ;

-- CUME_DIST()
SELECT route_type_id, name, length, 
       CUME_DIST() OVER w AS bucket 
FROM trails 
WHERE park_id = 22 AND route_type_id = 2
WINDOW w AS (PARTITION BY route_type_id ORDER BY length) ;
