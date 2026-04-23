USE dog_db;
DROP view view_1;
SELECT* FROM information_schema.views where TABLE_SCHEMA='dog_db';

-- Создание view
CREATE VIEW view_1 as 
SELECT 
    manufacturer.id_manufacturer,
    manufacturer.name_manufacturer AS name_manufacturer,
    COUNT(DISTINCT m.id_dog) AS count_dog ,
    COUNT(DISTINCT v.id_vet_clinic) AS count_vet_clinic
FROM 
    manufacturer 
     JOIN (
        SELECT id_microchip, id_manufacturer, id_dog 
        FROM microchip 
        WHERE id_dog IS NOT NULL 
    )  m ON manufacturer.id_manufacturer = m.id_manufacturer
     JOIN (
        SELECT id_dog, id_veterinarian 
        FROM medical_service_record 
    ) ms ON m.id_dog = ms.id_dog
     JOIN (
    SELECT id_veterinarian, id_vet_clinic
    FROM veterinarian 
    ) v ON ms.id_veterinarian = v.id_veterinarian
GROUP BY 
    manufacturer.id_manufacturer, manufacturer.name_manufacturer;
    
SELECT * FROM view_1;

-- Простой запрос
SELECT name_manufacturer,
count_dog,
count_vet_clinic
FROM view_1
WHERE count_dog <=450 and count_vet_clinic >615;

-- Сложный запрос
SELECT 
    v.name_manufacturer,
    v.count_dog,
    v.count_vet_clinic,
    COUNT(ms.id_record) AS count_medical_service_record
FROM 
    view_1 as v 
JOIN microchip m ON v.id_manufacturer = m.id_manufacturer
JOIN medical_service_record ms ON m.id_dog = ms.id_dog
WHERE m.id_dog IS NOT NULL
GROUP BY v.name_manufacturer, v.count_dog, v.count_vet_clinic
ORDER BY count_medical_service_record DESC;

-- Проверка на доступ только для чтения
UPDATE view_1 set count_dog=20 where id_manufacturer =1; -- Ошибка. The target table of the UPDATE is not updateble
DELETE FROM view_1 WHERE id_manufacturer = 1; -- Ошибка. The target table of the DELETE is not updateble
INSERT INTO view_1 (id_manufacturer, name_manufacturer, count_dog, count_vet_clinic) 
VALUES (52, 'Производитель 52', 20, 30);        -- Ошибка. The target table of the INSERT is not insertable-into
