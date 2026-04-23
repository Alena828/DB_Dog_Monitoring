CREATE DATABASE IF NOT EXISTS dog_db;
USE dog_db;

CREATE TABLE IF NOT EXISTS country(
    id_country INT NOT NULL AUTO_INCREMENT,
    name_country CHAR(21) NOT NULL,
    code_country CHAR(3) NOT NULL,
    PRIMARY KEY (id_country)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS manufacturer(
    id_manufacturer INT NOT NULL AUTO_INCREMENT,
    name_manufacturer CHAR(25) NOT NULL,
    code_manufacturer CHAR(4) NOT NULL,
    PRIMARY KEY (id_manufacturer)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS breed(
    id_breed INT NOT NULL AUTO_INCREMENT,
    name_breed CHAR(44) NOT NULL,  
    PRIMARY KEY (id_breed)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS region(
    id_region INT NOT NULL AUTO_INCREMENT,
    name_region CHAR(34) NOT NULL,
    PRIMARY KEY (id_region)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS city(
    id_city INT NOT NULL AUTO_INCREMENT,  
    name_city CHAR(25) NOT NULL,
    PRIMARY KEY (id_city)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS gender(
    id_gender INT NOT NULL AUTO_INCREMENT,
    name_gender CHAR(7),
    PRIMARY KEY (id_gender)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS medical_service(
    id_medical_service INT NOT NULL AUTO_INCREMENT,
    name_medical_service CHAR(255),  
    PRIMARY KEY (id_medical_service)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS kennel_owner(
    id_kennel_owner INT NOT NULL AUTO_INCREMENT,
    surname_kennel_owner CHAR(40) NOT NULL,  
    name_kennel_owner CHAR(15) NOT NULL,
    patronymic_kennel_owner CHAR(20) NULL,
    phone_kennel_owner CHAR(20) NOT NULL,
    PRIMARY KEY (id_kennel_owner)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS vet_clinic(
    id_vet_clinic INT NOT NULL AUTO_INCREMENT,
    name_vet_clinic CHAR(200) NOT NULL,
    id_region INT NULL,
    id_city INT NOT NULL,
    address_in_city CHAR(200) NOT NULL,
    PRIMARY KEY (id_vet_clinic),
    INDEX id_region_idx (id_region ASC),
    CONSTRAINT fk_vet_clinic_region
       FOREIGN KEY (id_region)
       REFERENCES region(id_region)
       ON DELETE NO ACTION
       ON UPDATE NO ACTION,
    INDEX id_city_idx (id_city ASC),
    CONSTRAINT fk_vet_clinic_city
       FOREIGN KEY (id_city)
       REFERENCES city(id_city)
       ON DELETE NO ACTION
       ON UPDATE NO ACTION
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS owner(
    id_owner INT NOT NULL AUTO_INCREMENT,
    surname_owner CHAR(40) NOT NULL,  
    name_owner CHAR(15) NOT NULL,
    patronymic_owner CHAR(20) NULL,
    id_region INT NULL,
    id_city INT NOT NULL,
    address_in_city CHAR(200) NOT NULL,
    phone_owner CHAR(20) NOT NULL,
    PRIMARY KEY (id_owner),
    INDEX id_region_idx (id_region ASC),
    CONSTRAINT fk_owner_region
       FOREIGN KEY (id_region)
       REFERENCES region(id_region)
       ON DELETE NO ACTION
       ON UPDATE NO ACTION,
    INDEX id_city_idx (id_city ASC),
    CONSTRAINT fk_owner_city
       FOREIGN KEY (id_city)
       REFERENCES city(id_city)
       ON DELETE NO ACTION
       ON UPDATE NO ACTION
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS veterinarian(
    id_veterinarian INT NOT NULL AUTO_INCREMENT,
    surname_veterinarian CHAR(40) NOT NULL,  
    name_veterinarian CHAR(15) NOT NULL,
    patronymic_veterinarian CHAR(20) NULL,
    id_vet_clinic INT NULL,
    PRIMARY KEY (id_veterinarian),
    INDEX id_vet_clinic_idx (id_vet_clinic ASC),
    CONSTRAINT fk_veterinarian_clinic
       FOREIGN KEY (id_vet_clinic)
       REFERENCES vet_clinic(id_vet_clinic)
       ON DELETE NO ACTION
       ON UPDATE NO ACTION
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS kennel(
    id_kennel INT NOT NULL AUTO_INCREMENT,
    name_kennel CHAR(20) NOT NULL,  
    id_kennel_owner INT NOT NULL,
    id_breed INT NOT NULL,
    PRIMARY KEY (id_kennel),
    INDEX id_kennel_owner_idx (id_kennel_owner ASC),
    CONSTRAINT fk_kennel_owner
       FOREIGN KEY (id_kennel_owner)
       REFERENCES kennel_owner(id_kennel_owner)
       ON DELETE NO ACTION
       ON UPDATE NO ACTION,
    INDEX id_breed_idx (id_breed ASC),
    CONSTRAINT fk_kennel_breed
       FOREIGN KEY (id_breed)
       REFERENCES breed(id_breed)
       ON DELETE NO ACTION
       ON UPDATE NO ACTION
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS dog(
    id_dog INT NOT NULL AUTO_INCREMENT,
    name_dog CHAR(50) NOT NULL,  
    id_owner INT NOT NULL,
    birth_date DATE NOT NULL,
    id_gender INT NOT NULL,
    number_in_kennel INT NULL,
    id_kennel INT NULL,
    id_breed INT NULL,
    id_parents_of_dog INT NULL,
    PRIMARY KEY (id_dog),
    INDEX id_owner_idx (id_owner ASC),
    CONSTRAINT fk_dog_owner
       FOREIGN KEY (id_owner)
       REFERENCES owner(id_owner)
       ON DELETE NO ACTION
       ON UPDATE NO ACTION,
    INDEX id_gender_idx (id_gender ASC),
    CONSTRAINT fk_dog_gender
       FOREIGN KEY (id_gender)
       REFERENCES gender(id_gender)
       ON DELETE NO ACTION
       ON UPDATE NO ACTION,
    INDEX id_kennel_idx (id_kennel ASC),
    CONSTRAINT fk_dog_kennel
       FOREIGN KEY (id_kennel)
       REFERENCES kennel(id_kennel)
       ON DELETE NO ACTION
       ON UPDATE NO ACTION,
    INDEX id_breed_idx (id_breed ASC),
    CONSTRAINT fk_dog_breed
       FOREIGN KEY (id_breed)
       REFERENCES breed(id_breed)
       ON DELETE NO ACTION
       ON UPDATE NO ACTION
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS parents_of_dog(
    id_parents_of_dog INT NOT NULL AUTO_INCREMENT,
    id_mother INT NOT NULL,
    id_father INT NOT NULL,
    PRIMARY KEY (id_parents_of_dog),
    INDEX id_mother_idx (id_mother ASC),
    CONSTRAINT fk_mother_dog
       FOREIGN KEY (id_mother)
       REFERENCES dog(id_dog)
       ON DELETE NO ACTION
       ON UPDATE NO ACTION,
    INDEX id_father_idx (id_father ASC),
    CONSTRAINT fk_father_dog
       FOREIGN KEY (id_father)
       REFERENCES dog(id_dog)
       ON DELETE NO ACTION
       ON UPDATE NO ACTION
) ENGINE=InnoDB;

ALTER TABLE dog
ADD CONSTRAINT fk_dog_parents
    FOREIGN KEY (id_parents_of_dog)
    REFERENCES parents_of_dog(id_parents_of_dog)
    ON DELETE SET NULL
    ON UPDATE CASCADE;

CREATE TABLE IF NOT EXISTS microchip(
    id_microchip INT NOT NULL AUTO_INCREMENT,
    id_dog INT NOT NULL,
    id_country INT NOT NULL,
    id_manufacturer INT NOT NULL,
    number INT NOT NULL,
    PRIMARY KEY (id_microchip),
    INDEX id_dog_idx (id_dog ASC),
    CONSTRAINT fk_microchip_dog
       FOREIGN KEY (id_dog)
       REFERENCES dog(id_dog)
       ON DELETE NO ACTION
       ON UPDATE NO ACTION,
    INDEX id_country_idx (id_country ASC),
    CONSTRAINT fk_microchip_country
       FOREIGN KEY (id_country)
       REFERENCES country(id_country)
       ON DELETE NO ACTION
       ON UPDATE NO ACTION,
    INDEX id_manufacturer_idx (id_manufacturer ASC),
    CONSTRAINT fk_microchip_manufacturer
       FOREIGN KEY (id_manufacturer)
       REFERENCES manufacturer(id_manufacturer)
       ON DELETE NO ACTION
       ON UPDATE NO ACTION
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS dog_ownership(
    id_dog_ownership INT NOT NULL AUTO_INCREMENT,
    id_dog INT NOT NULL,
    id_owner INT NOT NULL,
    date_begin DATE NOT NULL,
    date_end DATE NULL,
    PRIMARY KEY (id_dog_ownership),
    INDEX id_dog_idx (id_dog ASC),
    CONSTRAINT fk_ownership_dog
       FOREIGN KEY (id_dog)
       REFERENCES dog(id_dog)
       ON DELETE NO ACTION
       ON UPDATE NO ACTION,
    INDEX id_owner_idx (id_owner ASC),
    CONSTRAINT fk_ownership_owner
       FOREIGN KEY (id_owner)
       REFERENCES owner(id_owner)  
       ON DELETE NO ACTION
       ON UPDATE NO ACTION
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS medical_service_record(
    id_record INT NOT NULL AUTO_INCREMENT,
    id_dog INT NOT NULL,
    id_veterinarian INT NOT NULL,
    id_medical_service INT NOT NULL,
    date DATE NOT NULL,
    PRIMARY KEY (id_record),
    INDEX id_dog_idx (id_dog ASC),
    CONSTRAINT fk_record_dog
       FOREIGN KEY (id_dog)
       REFERENCES dog(id_dog)
       ON DELETE NO ACTION
       ON UPDATE NO ACTION,
    INDEX id_veterinarian_idx (id_veterinarian ASC),
    CONSTRAINT fk_record_veterinarian
       FOREIGN KEY (id_veterinarian)
       REFERENCES veterinarian(id_veterinarian)
       ON DELETE NO ACTION
       ON UPDATE NO ACTION,
    INDEX id_medical_service_idx (id_medical_service ASC),
    CONSTRAINT fk_record_service
       FOREIGN KEY (id_medical_service)
       REFERENCES medical_service(id_medical_service)
       ON DELETE NO ACTION
       ON UPDATE NO ACTION
) ENGINE=InnoDB;