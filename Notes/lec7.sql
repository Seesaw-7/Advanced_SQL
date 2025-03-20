SELECT route_type_id, name, length, 
       FIRST_VALUE(name) OVER (PARTITION BY route_type_id ORDER BY length) AS shortest_trail
FROM trails;
-- Every row in the partition gets the same first value based on ORDER BY length.

SELECT route_type_id, name, length, 
       LEAD(name) OVER (PARTITION BY route_type_id ORDER BY length) AS next_trail,
       LEAD(length) OVER (PARTITION BY route_type_id ORDER BY length) AS next_length
FROM trails;
