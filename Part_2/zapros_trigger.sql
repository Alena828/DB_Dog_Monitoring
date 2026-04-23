USE dog_db;

SELECT* FROM information_schema.triggers where TRIGGER_SCHEMA='dog_db';

CREATE TABLE IF NOT EXISTS breed_statistics (
    id_breed INT PRIMARY KEY,
	name_breed CHAR(44) NOT NULL,
    dog_count INT NOT NULL DEFAULT 0
);

INSERT INTO breed_statistics (id_breed, name_breed, dog_count)
SELECT 
    b.id_breed,
    b.name_breed,
    COUNT(d.id_dog) as dog_count  
FROM breed b
LEFT JOIN dog d ON b.id_breed = d.id_breed
GROUP BY b.id_breed, b.name_breed;

SELECT * FROM breed_statistics;



DELIMITER //
CREATE TRIGGER trigger_breed_insert
    AFTER INSERT ON breed               
    FOR EACH ROW                        
    INSERT INTO breed_statistics (id_breed, name_breed, dog_count)
    VALUES (NEW.id_breed, NEW.name_breed, 0); 

DELIMITIR ;

DELIMITER //
CREATE TRIGGER trigger_breed_update
    AFTER UPDATE ON breed               
    FOR EACH ROW
    UPDATE breed_statistics 
    SET name_breed = NEW.name_breed     
    WHERE id_breed = NEW.id_breed;      

DELIMITIR ;


DELIMITER //

CREATE TRIGGER trigger_breed_delete
    AFTER DELETE ON breed               
    FOR EACH ROW
    DELETE FROM breed_statistics 
    WHERE id_breed = OLD.id_breed;      

DELIMITER ;



DELIMITER //

CREATE TRIGGER trigger_dog_insert
    AFTER INSERT ON dog                 
    FOR EACH ROW
	UPDATE breed_statistics 
    SET dog_count = dog_count + 1  
	WHERE id_breed = NEW.id_breed;

DELIMITER ;


DELIMITER //

CREATE TRIGGER trigger_dog_delete
    AFTER DELETE ON dog                 
    FOR EACH ROW
    UPDATE breed_statistics 
    SET dog_count = dog_count - 1       
    WHERE id_breed = OLD.id_breed;      
    
    UPDATE breed_statistics 
    SET dog_count = 0                 
    WHERE id_breed = OLD.id_breed AND dog_count < 0;

DELIMITER ;


DELIMITER //

CREATE TRIGGER trigger_dog_update_breed
    AFTER UPDATE ON dog                 
    FOR EACH ROW
    IF OLD.id_breed != NEW.id_breed  THEN
	     UPDATE breed_statistics 
		 SET dog_count = dog_count - 1   
		 WHERE id_breed = OLD.id_breed;
		
		 UPDATE breed_statistics 
		 SET dog_count = 0 
		 WHERE id_breed = OLD.id_breed AND dog_count < 0;
	END IF;
            
	UPDATE breed_statistics 
	SET dog_count = dog_count + 1   
	WHERE id_breed = NEW.id_breed;

DELIMITER ;



INSERT INTO dog_db.breed (id_breed, name_breed) VALUES (62, 'Бульбульдог');
SELECT * FROM dog_db.breed_statistics;

UPDATE dog_db.breed SET name_breed='Гавгавдог' where id_breed=62;
SELECT * FROM dog_db.breed_statistics;

INSERT INTO dog_db.dog (id_dog,name_dog, birth_date,id_gender,number_in_kennel,id_kennel,id_breed,id_parents_of_dog) VALUES (22787,'Бобик','2017-05-15',2, 3000,249,62,20);
SELECT * FROM dog_db.breed_statistics;

UPDATE dog_db.dog SET id_breed = 6 WHERE id_dog = 22787;
SELECT * FROM dog_db.breed_statistics;

DELETE FROM dog_db.dog where id_dog=22787;
SELECT * FROM dog_db.breed_statistics;

DELETE FROM dog_db.breed WHERE id_breed=62;
SELECT * FROM dog_db.breed_statistics;



