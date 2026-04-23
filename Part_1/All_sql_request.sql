use dog_db;

-- 1a
EXPLAIN
SELECT 
dog.id_dog AS "ID Собаки",
dog.name_dog AS "Кличка",
gender.name_gender AS "Пол",
country.name_country AS "Cтрана микрочипа",
medical_service.name_medical_service AS "Медицинская услуга"
FROM 
dog 
JOIN gender ON dog.id_gender = gender.id_gender
JOIN microchip ON microchip.id_dog=dog.id_dog
JOIN country ON microchip.id_country = country.id_country
JOIN medical_service_record ON medical_service_record.id_dog = dog.id_dog 
JOIN medical_service ON  medical_service.id_medical_service = medical_service_record.id_medical_service
WHERE microchip.id_country=1
AND dog.id_gender=2
AND medical_service.id_medical_service=15
GROUP BY
dog.id_dog,dog.name_dog,gender.name_gender,country.name_country,medical_service.name_medical_service;



-- 1b
USE dog_db;
EXPLAIN
SELECT 
    dog.id_dog AS "ID Собаки",
    dog.name_dog AS "Кличка",
    gender.name_gender AS "Пол",
    country.name_country AS "Страна микрочипа",
    medical_service.name_medical_service AS "Медицинская услуга",
    COUNT(medical_service_record.id_record) AS "Количество раз оказания услуги"
FROM 
    dog 
    JOIN gender ON dog.id_gender = gender.id_gender
    JOIN microchip ON microchip.id_dog = dog.id_dog
    JOIN country ON microchip.id_country = country.id_country
    JOIN medical_service_record ON medical_service_record.id_dog = dog.id_dog
    JOIN medical_service ON medical_service.id_medical_service = medical_service_record.id_medical_service
WHERE 
    microchip.id_country = 1
    AND dog.id_gender = 2
    AND medical_service.id_medical_service = 19
GROUP BY
    dog.id_dog,dog.name_dog,gender.name_gender,country.name_country,medical_service.name_medical_service
HAVING COUNT(medical_service_record.id_record)>=2
ORDER BY COUNT(medical_service_record.id_record) desc; 

-- 2
explain
SELECT
kennel.id_kennel AS "ID Питомника",
kennel.name_kennel AS "Название питомника",
region.name_region AS "Регион хозяина",
COUNT(microchip.id_microchip) AS "Кол-во микрочипов"
FROM
microchip
JOIN dog ON microchip.id_dog=dog.id_dog
JOIN kennel ON dog.id_kennel=kennel.id_kennel
JOIN dog_ownership ON dog_ownership.id_dog=dog.id_dog
JOIN owner ON owner.id_owner=dog_ownership.id_owner
JOIN region ON owner.id_region=region.id_region
WHERE kennel.id_kennel=4
AND owner.id_region=7
group by
kennel.id_kennel,
kennel.name_kennel,
region.name_region;

-- 3a
explain
SELECT
owner.id_owner,
owner.surname_owner AS "Фамилия",
owner.name_owner AS "Имя",
owner.patronymic_owner AS "Отчество",
COUNT(dog_ownership.id_owner) AS "Кол-во собак"
FROM
dog_ownership
JOIN owner ON dog_ownership.id_owner=owner.id_owner
WHERE dog_ownership.date_end is NULL
GROUP BY owner.id_owner, owner.surname_owner,owner.patronymic_owner
HAVING COUNT(dog_ownership.id_owner)=(
SELECT 
    COUNT(dog_ownership.id_owner) as count_dog_for_owner
    FROM
    dog_ownership
    WHERE dog_ownership.date_end is NULL 
    GROUP BY dog_ownership.id_owner
    ORDER BY count_dog_for_owner 
    LIMIT 1
);


-- 3b
SELECT
owner.id_owner,
owner.surname_owner AS "Фамилия",
owner.name_owner AS "Имя",
owner.patronymic_owner AS "Отчество",
COUNT(dog_ownership.id_owner) AS "Кол-во собак"
FROM
dog_ownership
JOIN owner ON dog_ownership.id_owner=owner.id_owner
WHERE dog_ownership.date_end is NULL
GROUP BY owner.id_owner, owner.surname_owner,owner.patronymic_owner
HAVING COUNT(dog_ownership.id_owner)=(
SELECT 
    COUNT(dog_ownership.id_owner) as count_dog_for_owner
    FROM
    dog_ownership
	WHERE dog_ownership.date_end is NULL 
    GROUP BY dog_ownership.id_owner
    ORDER BY count_dog_for_owner DESC
    LIMIT 1
);


-- 4
explain
SELECT
owner_with_count.count_dog_for_owner AS "Кол-во собак",
COUNT(owner_with_count.count_dog_for_owner) AS "Число хозяев"
FROM (
SELECT 
    COUNT(dog_ownership.id_owner) as count_dog_for_owner
    FROM
    dog_ownership
	WHERE dog_ownership.date_end is NULL 
    GROUP BY dog_ownership.id_owner
) AS owner_with_count 
GROUP BY owner_with_count.count_dog_for_owner
ORDER BY owner_with_count.count_dog_for_owner;

-- 5
explain
SELECT 
    manufacturer.id_manufacturer,
    manufacturer.name_manufacturer AS "Производитель",
    COUNT(DISTINCT m.id_dog) AS "Кол-во чипированных собак",
    COUNT(DISTINCT v.id_vet_clinic) AS "Кол-во ветклиник"
FROM 
    manufacturer 
    LEFT JOIN (
        SELECT id_microchip, id_manufacturer, id_dog 
        FROM microchip 
        WHERE id_dog IS NOT NULL 
    )  m ON manufacturer.id_manufacturer = m.id_manufacturer
    LEFT JOIN (
        SELECT id_dog, id_veterinarian 
        FROM medical_service_record 
    ) ms ON m.id_dog = ms.id_dog
    LEFT JOIN (
    SELECT id_veterinarian, id_vet_clinic
    FROM veterinarian 
    ) v ON ms.id_veterinarian = v.id_veterinarian
GROUP BY 
    manufacturer.id_manufacturer, manufacturer.name_manufacturer;


-- 6
SELECT 
    kennel.id_kennel AS "ID Питомника",
    kennel.name_kennel AS "Название питомника",
    COUNT(d.id_dog) AS "Число собак"
FROM 
    kennel 
     JOIN dog d ON d.id_kennel = kennel.id_kennel
GROUP BY 
    kennel.id_kennel
HAVING 
    COUNT(d.id_dog) >= (   -- >
        SELECT COUNT(dd.id_dog) 
        FROM dog dd 
        WHERE dd.id_kennel = 2 
    )
ORDER BY 
     COUNT(d.id_dog);

 
-- 7
explain
SELECT 
    o.id_owner,
    o.surname_owner AS "Фамилия",
    o.name_owner AS "Имя",
    o.patronymic_owner AS "Отчество"
FROM 
    owner o
WHERE 
    NOT EXISTS (
        SELECT 1 
        FROM dog_ownership do
        JOIN dog d ON do.id_dog = d.id_dog
        WHERE do.id_owner = o.id_owner
        AND d.id_breed = 2
    )
GROUP BY o.id_owner;


-- 8
explain
SELECT 
    m.id_manufacturer,
    m.name_manufacturer,
    b.id_breed,
    b.name_breed,
    COALESCE(dog_counts.cnt, 0) AS "Количество собак"
FROM 
    manufacturer m
    CROSS JOIN breed b
    LEFT JOIN (
        SELECT 
            mc.id_manufacturer,
            d.id_breed,
            COUNT(DISTINCT d.id_dog) AS cnt
        FROM 
            microchip mc
            JOIN dog d ON mc.id_dog = d.id_dog
        WHERE 
            mc.id_dog IS NOT NULL
        GROUP BY 
            mc.id_manufacturer,
            d.id_breed
    ) dog_counts ON m.id_manufacturer = dog_counts.id_manufacturer 
                AND b.id_breed = dog_counts.id_breed and  m.id_manufacturer<11 and b.id_breed <10
ORDER BY 
    m.id_manufacturer,
    b.id_breed;   
