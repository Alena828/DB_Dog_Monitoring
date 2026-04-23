use dog_db;
SELECT * 
FROM information_schema.TRIGGERS 
WHERE TRIGGER_SCHEMA = 'dog_db';
SELECT ROUTINE_NAME AS procedure_name,
       ROUTINE_SCHEMA AS database_name,
       ROUTINE_DEFINITION AS definition
FROM INFORMATION_SCHEMA.ROUTINES
WHERE ROUTINE_TYPE = 'PROCEDURE'  
AND ROUTINE_SCHEMA = 'dog_db';


SELECT ROUTINE_NAME AS function_name,
       ROUTINE_SCHEMA AS database_name,
       ROUTINE_DEFINITION AS definition
FROM INFORMATION_SCHEMA.ROUTINES
WHERE ROUTINE_TYPE = 'FUNCTION' 
AND ROUTINE_SCHEMA = 'dog_db';

 
 drop function initials;
 DELIMITER //
 CREATE FUNCTION initials(surname varchar(40) , name varchar
 (15) , patronymic varchar(20))
 RETURNS VARCHAR(45)
 DETERMINISTIC
 BEGIN
 DECLARE results VARCHAR(45) ;
 SET results = surname;
 IF patronymic IS NOT NULL AND patronymic != '' THEN
   SET results = CONCAT(results, ' ', SUBSTRING(name, 1, 1), '.', SUBSTRING(patronymic , 1, 1) , '. ');
 ELSE
 SET results = CONCAT( results , ' ' , SUBSTRING(name, 1, 1), '.
 ' ) ;
 END IF;
 RETURN results ;
 END //
 DELIMITER ;
 
 update kennel_owner SET patronymic_kennel_owner= NULL where id_kennel_owner = 2;
 use dog_db;
 -- простой запрос
 SELECT
 surname_kennel_owner ,
 name_kennel_owner,
 patronymic_kennel_owner ,
 initials(surname_kennel_owner , name_kennel_owner, patronymic_kennel_owner) AS initials
 FROM
 kennel_owner;
 
 -- сложный запрос
SELECT 
    k.name_kennel,
    initials(ko.surname_kennel_owner, ko.name_kennel_owner, ko.patronymic_kennel_owner) AS owner_full_name
FROM 
    kennel k
JOIN 
    kennel_owner ko ON k.id_kennel_owner = ko.id_kennel_owner;
 
 drop procedure kennel_and_owner;
 DELIMITER //
 CREATE PROCEDURE kennel_and_owner(kennel_name VARCHAR(20)  ,
 owner_surname VARCHAR(40) ,
 owner_name VARCHAR(15) ,
 owner_patronymic VARCHAR(20))
 BEGIN
 DECLARE owner_id int ;
 DECLARE kennel_id int ;
-- проверка владельца

 SELECT id_kennel_owner
 INTO owner_id
 FROM kennel_owner
 WHERE kennel_owner.surname_kennel_owner = owner_surname AND kennel_owner.name_kennel_owner =
 owner_name AND kennel_owner.patronymic_kennel_owner = owner_patronymic;
 IF owner_id IS NULL THEN
 INSERT INTO kennel_owner (surname_kennel_owner, name_kennel_owner, patronymic_kennel_owner, phone_kennel_owner) 
 VALUES ( owner_surname , owner_name , owner_patronymic , NULL);
 SET owner_id = LAST_INSERT_ID() ;
 END IF;
 
SELECT id_kennel
 INTO kennel_id
 FROM  kennel
 WHERE name_kennel = kennel_name AND id_kennel_owner=owner_id;
 
 IF kennel_id IS NULL THEN
 INSERT INTO kennel (name_kennel, id_kennel_owner)
 VALUES (kennel_name , owner_id);
 SET kennel_id = LAST_INSERT_ID() ;
 END IF;
 END //
 DELIMITER ;
 
Select* from kennel;
Select* from kennel_owner;
call kennel_and_owner('Питомник1','Петровa','Алёна','Александровна') ;
Select* from kennel_owner where surname_kennel_owner ='Петровa' and name_kennel_owner =  'Алёна' and patronymic_kennel_owner = 'Александровна' ;
Select* from kennel where name_kennel = 'Питомник1';

call kennel_and_owner('Питомник11','Петровa','Алёна','Александровна') ;
Select* from kennel_owner;
Select* from kennel where name_kennel = 'Питомник11' or id_kennel_owner=1;

call kennel_and_owner('Питомник250','Петров','Алксей','Александрович') ;
Select* from kennel_owner;
Select* from kennel where name_kennel = 'Питомник250';

DELETE FROM kennel where id_kennel=255;
DELETE FROM kennel where id_kennel=256;
DELETE FROM kennel_owner where id_kennel_owner=62;