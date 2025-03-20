USE NatPark;

SHOW TABLES;

DESC trails;


-- Stored procedures
DELIMITER $$
CREATE PROCEDURE get_trails()
BEGIN
SELECT COUNT(trail_id) FROM trails;
END $$
DELIMITER;

CALL get_trails()

DROP PROCEDURE get_trails -- drop the predefined wrong procedure, and create a new one
-- actually just revise in-place would be okay

DELIMITER $$ -- states that the delimiter changes from ; to $$ 
CREATE PROCEDURE get_trails()
BEGIN
SELECT COUNT(id) FROM trails;
END $$ -- the actual usage of delimiter
DELIMITER; -- states that the delimiter change ends

CALL get_trails()

SHOW PROCEDURE STATUS WHERE DB = 'NatPark'


-- Stored procedure with single parameter
DELIMITER $$
CREATE PROCEDURE trail_length(IN trail_name VARCHAR(255))
BEGIN
SELECT length FROM trails WHERE name = trail_name;
END $$
DELIMITER;

CALL trail_length('Hermit Trail')

DELIMITER $$
CREATE PROCEDURE get_name_by_difficulty(IN difficulty_level INT)
BEGIN
SELECT name FROM trails WHERE difficulty_rating = difficulty_level;
END $$
DELIMITER;

CALL get_name_by_difficulty(7)


-- stored procedure with multiple parameters
DELIMITER $$
CREATE PROCEDURE get_name_by_difficulty_state(IN difficulty_level INT, IN state VARCHAR(255))
BEGIN
SELECT trails.name 
FROM trails 
JOIN states ON trails.state_id = states.id 
WHERE trails.difficulty_rating = difficulty_level
AND states.state_name = state;
END $$
DELIMITER;

CALL get_name_by_difficulty_state(7, 'Montana')


-- stored procedure with out parameter
DELIMITER $$

CREATE PROCEDURE getTrailsByDifficulty(
    IN difficulty_level VARCHAR(50), 
    OUT total_length DOUBLE -- cuz the length column of the table is double
)
BEGIN
    SELECT SUM(length) 
    INTO total_length 
    FROM trails 
    WHERE difficulty_rating = difficulty_level;
END $$

DELIMITER ;

SET @t_length = 0; -- has to be an initial value (but no type declaration?)
CALL getTrailsByDifficulty(3, @t_length);
SELECT @t_length AS 'total_length';


-- event scheduler
SHOW VARIABLES LIKE 'event_scheduler'-- sql root variables
SET GLOBAL event_scheduler = ON;
-- always make sure that it is on in a new environment before scheduling jobs

-- know the number of rabbits on the trail Fort Jefferson Loop

-- assume that every 10 second, you see a new minilop rabbit, and increase the number of minilop rabbits
CREATE TABLE FJL_rabbits (
    id INT AUTO_INCREMENT PRIMARY KEY,
    species VARCHAR(255) NOT NULL,
    rabbit_count INT
);

INSERT INTO FJL_rabbits (species, rabbit_count) 
VALUES 
    ('Holland Lop', 45), 
    ('Mini Lop', 40), 
    ('Rex Rabbit', 125);

SELECT * FROM FJL_rabbits;

DELIMITER $$
CREATE EVENT event_minilop
ON SCHEDULE EVERY 10 SECOND 
STARTS CURRENT_TIMESTAMP
DO 
    UPDATE FJL_rabbits 
    SET rabbit_count = rabbit_count + 1 
    WHERE species = 'Mini Lop';
DELIMITER ;

SHOW EVENTS;

DROP EVENT event_minilop


-- call the procedure in an event
DELIMITER $$
CREATE PROCEDURE erosion(
    IN trail_name VARCHAR(255), 
    IN erosion_rate FLOAT
)
BEGIN
    UPDATE trails
    SET length = COALESCE(length, 0) - erosion_rate
    WHERE name = trail_name;
END $$
DELIMITER ;

SELECT length FROM trails WHERE name = 'Fort Jefferson Loop'

DELIMITER $$
CREATE EVENT erosionrate
ON SCHEDULE EVERY 10 SECOND 
STARTS CURRENT_TIMESTAMP
DO 
    CALL erosion('Fort Jefferson Loop', 1);

DELIMITER ;

DROP EVENT erosionrate