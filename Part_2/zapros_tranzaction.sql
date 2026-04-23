USE dog_db;
CREATE USER IF NOT exists 'user1'@'localhost' IDENTIFIED BY '1234';
GRANT SELECT, INSERT, UPDATE ON dog_db.breed TO 'user1'@'localhost';

CREATE USER IF NOT exists 'user2'@'localhost' IDENTIFIED BY '4321';
GRANT SELECT, INSERT, UPDATE ON dog_db.* TO 'user2'@'localhost';


-- User1
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION; 
SELECT * FROM dog_db.breed WHERE id_breed=10;

-- User2
START TRANSACTION; 
UPDATE dog_db.breed SET name_breed='Лабрадудль' WHERE id_breed=10;  
SELECT * FROM dog_db.breed WHERE id_breed=10;

-- User1
SELECT * FROM dog_db.breed WHERE id_breed=10; 

-- User2
COMMIT;

-- User1
SELECT * FROM dog_db.breed WHERE id_breed=10;
COMMIT;