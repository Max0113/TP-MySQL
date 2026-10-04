USE atlascar ;

-- 1) Question 1 
ALTER TABLE client 
ADD email varchar(100),
ADD Constraint uq_client_email UNIQUE (email);

-- 2) Question 2 
ALTER TABLE location
ADD CONSTRAINT ck_loc_km CHECK ( km_retour > km_depart ) ;

-- 3) Question 3
ALTER TABLE vehicule
ADD status varchar(100) DEFAULT 'disponible', 
ADD CONSTRAINT ck_vehicule_status CHECK ( status in ('disponible' , 'maintenance') ) ;

-- 4) Question 4
ALTER TABLE agence
MODIFY telephone VARCHAR(100) ;

-- 5) Question 5
DROP TABLE IF EXISTS Brouillon;
CREATE TABLE Brouillon (
    id INT PRIMARY KEY AUTO_INCREMENT
);