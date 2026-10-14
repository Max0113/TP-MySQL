-- Exercice 1 : Création de la base (LDD)

-- 1.1) 
Drop database if exists atlascar;
create database atlascar;

-- 1.3)
USE atlascar;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS Location_Equipement, Location, Equipement, Equeipement, Client, Vehicule, Categorie, Agence;
SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE Agence ( -- 1) Agence
    id_agence  INT AUTO_INCREMENT,
    nom_agence  VARCHAR(100) NOT NULL,
    ville  VARCHAR(100) NOT NULL,
    telephone  VARCHAR(20), 
    CONSTRAINT pk_agence PRIMARY KEY (id_agence),
    CONSTRAINT uq_agence_telephone UNIQUE (telephone)
);

CREATE TABLE Categorie ( -- 2) Categorie

    code_cat  CHAR(3),
    libelle VARCHAR(50),
    tarif_jour  DECIMAL(8,2) NOT NULL,
    CONSTRAINT pk_categorie PRIMARY KEY (code_cat),
    CONSTRAINT ck_categorie_tarif CHECK (tarif_jour > 0)
);

CREATE TABLE Vehicule ( -- 3) Vehicule
    immatriculation  VARCHAR(15),
    marque           VARCHAR(50) NOT NULL,
    modele           VARCHAR(50) NOT NULL,
    annee            INT NOT NULL CHECK (annee > 0),
    kilometrage      INT NOT NULL DEFAULT 0,
    carburant        VARCHAR(15) NOT NULL,
    code_cat         CHAR(3) NOT NULL,
    id_agence        INT NOT NULL,
    CONSTRAINT pk_vehicule PRIMARY KEY (immatriculation),
    CONSTRAINT uq_vehicule_immat UNIQUE (immatriculation),
    CONSTRAINT ck_vehicule_km CHECK (kilometrage >= 0),
    CONSTRAINT ck_vehicule_carburant
        CHECK (carburant IN ('Essence', 'Diesel', 'Hybride', 'Electrique')),
    CONSTRAINT fk_vehicule_categorie FOREIGN KEY (code_cat)  REFERENCES Categorie(code_cat),
    CONSTRAINT fk_vehicule_agence    FOREIGN KEY (id_agence) REFERENCES Agence(id_agence)
);

CREATE TABLE Client ( -- 4) Client
    id_client  INT AUTO_INCREMENT,
    cin        VARCHAR(10) NOT NULL,
    nom        VARCHAR(100) NOT NULL,
    prenom     VARCHAR(100) NOT NULL,
    ville      VARCHAR(100),
    telephone  VARCHAR(20),
    date_permis DATE,
    CONSTRAINT pk_client PRIMARY KEY (id_client),
    CONSTRAINT uq_client_cin UNIQUE (cin)
);

CREATE TABLE Location ( -- 5) Location
    id_location  INT AUTO_INCREMENT,
    date_debut  DATE NOT NULL,
    date_fin   DATE,
	km_depart  INT NOT NULL DEFAULT 0,
    km_retour  INT DEFAULT 0,
    id_client   INT NOT NULL,
    immatriculation  VARCHAR(15) NOT NULL,
    CONSTRAINT pk_location PRIMARY KEY (id_location),
    CONSTRAINT ck_location_dates CHECK (date_fin IS NULL OR date_fin >= date_debut),
    CONSTRAINT fk_location_client   FOREIGN KEY (id_client)   REFERENCES Client(id_client),
    CONSTRAINT fk_location_vehicule FOREIGN KEY (immatriculation) REFERENCES Vehicule(immatriculation)
);

CREATE TABLE Equipement ( -- 6) Equipement
    code_equip  VARCHAR(10),
    libelle     VARCHAR(100) NOT NULL,
    prix_jour   DECIMAL(6,2),
    CONSTRAINT pk_equip PRIMARY KEY (code_equip),
    CONSTRAINT ck_equipement_prix_jour CHECK (prix_jour > 0)
);

CREATE TABLE Location_Equipement ( -- 7) Location_Equipement 
    id_location    INT NOT NULL,
    code_equip  VARCHAR(10) NOT NULL,
    quantite       SMALLINT NOT NULL DEFAULT 1,
    CONSTRAINT pk_location_equipement PRIMARY KEY (id_location, code_equip),
    CONSTRAINT ck_le_quantite CHECK (quantite >= 1),
    CONSTRAINT fk_le_location   FOREIGN KEY (id_location)   REFERENCES Location(id_location),
    CONSTRAINT fk_le_equip FOREIGN KEY (code_equip) REFERENCES Equipement(code_equip)
);

-- 1.4)
ALTER TABLE client -- a)
ADD email varchar(100),
ADD Constraint uq_client_email UNIQUE (email);

ALTER TABLE location -- b)
ADD CONSTRAINT ck_loc_km CHECK ( km_retour > km_depart ) ;

ALTER TABLE vehicule -- c)
ADD status varchar(100) DEFAULT 'disponible', 
ADD CONSTRAINT ck_vehicule_status CHECK ( status in ('disponible' , 'maintenance') ) ;

ALTER TABLE agence -- d)
MODIFY telephone VARCHAR(100) ;

DROP TABLE IF EXISTS Brouillon; -- e)
CREATE TABLE Brouillon (
    id INT PRIMARY KEY AUTO_INCREMENT
);

-- 1.5)
SHOW TABLES;
DESCRIBE vehicule ;
SHOW CREATE TABLE location; 

-- Exercice 2 : Manipulation des données (LMD) 

-- 2.1)
INSERT INTO agence (id_agence, nom_agence, ville, telephone) VALUES
 (1, 'AtlasCar Agadir Centre',       'Agadir',    '0528211001'),
 (2, 'AtlasCar Aeroport Al Massira', 'Agadir',    '0528839002'),
 (3, 'AtlasCar Taghazout',           'Taghazout', '0528200303'),
 (4, 'AtlasCar Tiznit',              'Tiznit',    '0528860404'),
 (5, 'AtlasCar Inezgane',            'Inezgane',  '0528330505');

INSERT INTO categorie (code_cat, libelle, tarif_jour) VALUES
 ('ECO', 'Economique', 250.00),
 ('CIT', 'Citadine',   300.00),
 ('COM', 'Compacte',   380.00),
 ('SUV', 'SUV',        550.00),
 ('LUX', 'Luxe',      1200.00);

INSERT INTO vehicule (immatriculation, marque, modele, annee, kilometrage, carburant, code_cat, id_agence) VALUES
 ('10231-A-40', 'Dacia',      'Logan',    2021,  68000, 'Diesel',     'ECO', 1),
 ('10452-B-40', 'Dacia',      'Sandero',  2022,  41000, 'Essence',    'ECO', 1),
 ('20876-A-40', 'Renault',    'Clio',     2023,  22000, 'Essence',    'CIT', 2),
 ('20901-D-40', 'Peugeot',    '208',      2024,   9000, 'Hybride',    'CIT', 2),
 ('31555-A-40', 'Hyundai',    'Accent',   2020, 112000, 'Diesel',     'ECO', 3),
 ('32010-B-40', 'Volkswagen', 'Golf',     2022,  54000, 'Diesel',     'COM', 1),
 ('40117-A-40', 'Toyota',     'Corolla',  2024,  15000, 'Hybride',    'COM', 2),
 ('45220-H-40', 'Dacia',      'Duster',   2023,  37000, 'Diesel',     'SUV', 3),
 ('47001-A-40', 'Hyundai',    'Tucson',   2025,   4000, 'Hybride',    'SUV', 2),
 ('50333-B-40', 'Kia',        'Picanto',  2025,      0, 'Essence',    'ECO', 5),
 ('51212-A-40', 'Renault',    'Megane',   2024,  12000, 'Electrique', 'COM', 5),
 ('52008-B-40', 'Peugeot',    '3008',     2023,  46000, 'Diesel',     'SUV', 1);

INSERT INTO client (id_client, cin, nom, prenom, ville, telephone, date_permis) VALUES
 (1,  'JB123456', 'Alaoui',     'Youssef', 'Agadir',     '0661000001', '2012-05-14'),
 (2,  'JE234567', 'Benali',     'Salma',   'Inezgane',   '0662000002', '2018-09-02'),
 (3,  'J345678',  'El Idrissi', 'Omar',    'Agadir',     '0663000003', '2005-03-20'),
 (4,  'JM456789', 'Ait Lahcen', 'Fatima',  'Tiznit',     '0664000004', '2020-11-11'),
 (5,  'BE567890', 'Chraibi',    'Mehdi',   'Casablanca', '0665000005', '2015-07-07'),
 (6,  'JC678901', 'Ouchen',     'Nadia',   'Agadir',     '0666000006', '2023-06-30'),
 (7,  'EE789012', 'Tazi',       'Karim',   'Marrakech',  '0667000007', '2010-01-15'),
 (8,  'JH890123', 'Amrani',     'Hind',    'Agadir',     '0668000008', '2019-04-22'),
 (9,  'JK901234', 'Bakkali',    'Rachid',  'Taroudant',  '0669000009', '2016-08-08'),
 (10, 'JA012345', 'Ouali',      'Samira',  'Agadir',     NULL,         '2021-02-28');

INSERT INTO location (id_location, id_client, immatriculation, date_debut, date_fin, km_depart, km_retour) VALUES
 (1,  1, '10231-A-40', '2026-01-05', '2026-01-10',  60000,  60620),
 (2,  2, '20876-A-40', '2026-01-12', '2026-01-15',  15000,  15310),
 (3,  3, '45220-H-40', '2026-02-01', '2026-02-08',  30000,  31150),
 (4,  5, '47001-A-40', '2026-02-14', '2026-02-21',   1000,   2100),
 (5,  1, '32010-B-40', '2026-03-03', '2026-03-05',  48000,  48400),
 (6,  4, '10452-B-40', '2026-03-20', '2026-03-27',  36000,  36900),
 (7,  7, '40117-A-40', '2026-04-02', '2026-04-12',  10000,  11800),
 (8,  9, '31555-A-40', '2026-04-15', '2026-04-18', 108000, 108450),
 (9,  2, '20901-D-40', '2026-05-01', '2026-05-04',   5000,   5280),
 (10, 3, '52008-B-40', '2026-05-10', '2026-05-20',  40000,  42100),
 (11, 5, '45220-H-40', '2026-06-01', '2026-06-15',  33000,  35200),
 (12, 1, '20876-A-40', '2026-06-20', '2026-06-22',  18000,  18250),
 (13, 6, '10231-A-40', '2026-07-01', '2026-07-08',  64000,  65100),
 (14, 7, '47001-A-40', '2026-07-10', '2026-07-24',   2000,   3500),
 (15, 9, '51212-A-40', '2026-08-01', '2026-08-06',   9000,   9800),
 (16, 3, '40117-A-40', '2026-08-10', '2026-08-14',  13000,  13700),
 (17, 2, '32010-B-40', '2026-09-20', NULL,          53500,   NULL),
 (18, 5, '20901-D-40', '2026-09-25', NULL,           8500,   NULL),
 (19, 4, '31555-A-40', '2025-12-20', '2025-12-28', 104000, 105000);

INSERT INTO equipement (code_equip, libelle, prix_jour) VALUES
 ('GPS',   'GPS',                        30.00),
 ('SIEGE', 'Siege bebe',                 25.00),
 ('GAL',   'Galerie de toit',            40.00),
 ('COND',  'Conducteur supplementaire',  50.00),
 ('WIFI',  'Routeur Wi-Fi',              35.00);

INSERT INTO location_Equipement (id_location, code_equip, quantite) VALUES
 (3,  'GPS',   1), (3,  'GAL',   1),
 (4,  'SIEGE', 2), (4,  'GPS',   1),
 (7,  'COND',  1),
 (10, 'SIEGE', 1),
 (11, 'GAL',   1), (11, 'COND',  1),
 (13, 'GPS',   1),
 (14, 'GPS',   1), (14, 'SIEGE', 2);

-- 2.3) 
INSERT INTO vehicule
(immatriculation, marque, modele, annee, carburant, code_cat, id_agence)
VALUES
('60001-A-40', 'Renault', 'Kardian', 2026, 'Essence', 'CIT', 5);

SELECT * FROM vehicule
WHERE immatriculation = '60001-A-40';

-- kilometrage = 0
-- status      = disponible

-- 2.4) 
INSERT INTO client
(cin, nom, prenom, ville, telephone, date_permis)
VALUES
('JX999999', 'VotreNom', 'VotrePrenom', 'Agadir', '0612345678', '2026-01-01');

SELECT * FROM client ;

-- id_client = 11

-- 2.5) 
UPDATE categorie
SET tarif_jour = tarif_jour * 1.10
WHERE code_cat = 'SUV';

SELECT * FROM categorie
WHERE code_cat = 'SUV';

-- 2.6)
UPDATE client
SET email = 'y.alaoui@mail.ma'
WHERE nom = 'Alaoui'
  AND prenom = 'Youssef';

UPDATE client
SET email = 's.benali@mail.ma'
WHERE nom = 'Benali'
  AND prenom = 'Salma';
  
-- 2.7)
UPDATE location
SET date_fin = '2026-09-27',
    km_retour = 54100
WHERE immatriculation = '32010-B-40';

SELECT *
FROM location
WHERE immatriculation = '32010-B-40';

-- 2.8)
UPDATE vehicule
set status = 'maintenance'
where marque = 'Hyundai' AND modele = 'Accent';

SELECT * from vehicule
WHERE marque = 'Hyundai' AND modele = 'Accent';

-- 2.9)
DELETE FROM equipement
WHERE code_equip = 'WIFI';

DELETE FROM equipement
WHERE code_equip = 'GPS'; -- ERROR

SELECT * FROM equipement;

-- 2.10)
DELETE FROM location_equipement; -- delete all element of element
DROP TABLE Location_Equipement; -- delete table 
SELECT * from location_equipement;

-- Exercice 3 : Interrogation de la base   

-- A. Sélections simples 
-- 3.1)
SELECT immatriculation , marque , modele , carburant
FROM vehicule
WHERE carburant IN ('Electrique','Hybride');

-- 3.2)
SELECT * 
FROM client
WHERE nom LIKE "A%";

-- 3.3)
SELECT *
FROM vehicule v
WHERE (v.annee BETWEEN 2023 AND 2025 ) AND (v.kilometrage < 30000);

-- 3.4)
SELECT * 
FROM location l
WHERE l.date_fin IS NULL ;

-- 3.5)
SELECT DISTINCT nom , ville 
FROM client 
ORDER BY nom , ville;

-- B. Jointures 
-- 3.6)
SELECT v.immatriculation , v.marque , v.modele , c.libelle , c.tarif_jour , a.nom_agence
FROM vehicule v
JOIN categorie c on v.code_cat = c.code_cat
JOIN agence a on v.id_agence = a.id_agence;

-- 3.7)
SELECT l.date_debut , c.nom , c.prenom  , v.modele , v.marque
FROM location l 
JOIN client c on l.id_client = c.id_client
JOIN vehicule v on l.immatriculation = v.immatriculation
WHERE YEAR(l.date_debut) >= 2026 ;

-- 3.8)
SELECT l.id_location,
    DATEDIFF(l.date_fin, l.date_debut) AS nombre_jours,
    c.tarif_jour,
    DATEDIFF(l.date_fin, l.date_debut) * c.tarif_jour AS montant_base
FROM location l
JOIN vehicule v on v.immatriculation = l.immatriculation
JOIN categorie c on v.code_cat = c.code_cat
Where l.date_fin IS NOT NULL 
ORDER BY montant_base DESC;

-- 3.9)
SELECT
    a.id_agence,
    a.nom_agence,
    v.immatriculation,
    v.marque,
    v.modele
FROM Agence a
LEFT JOIN Vehicule v
    ON v.id_agence = a.id_agence
ORDER BY a.id_agence;

-- 3.10)
SELECT
    c.id_client,
    c.nom,
    c.prenom
FROM Client c
LEFT JOIN Location l
    ON c.id_client = l.id_client
WHERE l.id_location IS NULL;

-- C. Fonctions de groupe 
-- 3.11)
SELECT a.id_agence, COUNT(v.id_vehicule) AS nombre_vehicules
FROM agence a
LEFT JOIN vehicule v ON a.id_agence = v.id_agence
GROUP BY a.id_agence;

-- 3.12)
SELECT v.categorie,
       COUNT(l.id_location) AS nombre_locations,
       SUM(v.kilometrage) AS total_kilometres
FROM vehicule v
JOIN location l ON v.id_vehicule = l.id_vehicule
WHERE l.date_fin < CURDATE()
GROUP BY v.categorie;

-- 3.13)
SELECT c.id_client,
       SUM(l.prix) AS chiffre_affaires
FROM client c
JOIN location l ON c.id_client = l.id_client
GROUP BY c.id_client
ORDER BY chiffre_affaires DESC;

-- 3.14)
SELECT c.id_client, COUNT(l.id_location) AS nombre_locations
FROM client c
JOIN location l ON c.id_client = l.id_client
GROUP BY c.id_client
HAVING COUNT(l.id_location) >= 3;

-- 3.15)
SELECT carburant,
       AVG(kilometrage) AS moyenne,
       MIN(kilometrage) AS minimum,
       MAX(kilometrage) AS maximum
FROM vehicule
GROUP BY carburant
HAVING AVG(kilometrage) > 20000;

-- D. Sous-requêtes 
-- 3.16) 
select *
from vehicule
Where kilometrage > (select AVG(kilometrage) FROM vehicule) ;


-- 3.17) 
Select *
From vehicule
Where immatriculation NOT IN (
Select immatriculation from location
) ;

-- 3.18) 
SELECT
    c.id_client,
    c.nom,
    c.prenom
FROM Client c 
WHERE c.id_client IN (
    SELECT l.id_client
    FROM Location l
    WHERE l.immatriculation IN (
        SELECT v.immatriculation
        FROM Vehicule v
        WHERE v.code_cat = 'SUV' -- 5 vehicule de SUV
    ) -- tout client que deja loue une vehicule de SUV '15'
); -- givem nom and peronom 


-- 3.19) 
Select 
	v1.immatriculation,
    v1.marque,
    v1.modele,
    v1.kilometrage
from vehicule v1
where v1.kilometrage < all ( 
	-- here comaprte all kimtage of all center with center agadir 
    -- v1.kilometrage < all(3000 , 5000 , 6000) ++ v1.kilometrage < 3000 AND v1.kilometrage < 3000 AND v1.kilometrage < 6000
	Select v2.kilometrage
    From vehicule v2
    Where v2.id_agence = 1 -- he Collect all kilometrage of all vehicule for agence AtlasCar Agadir Centre
);

SELECT
    v.immatriculation,
    v.marque,
    v.modele,
    v.kilometrage
FROM Vehicule v
WHERE v.kilometrage < ALL (
    SELECT v2.kilometrage
    FROM Vehicule v2
    JOIN Agence a
        ON v2.id_agence = a.id_agence
    WHERE a.nom_agence = 'AtlasCar Agadir Centre'
);

SELECT
    v1.immatriculation,
    v1.marque,
    v1.modele,
    v1.kilometrage
FROM vehicule v1
WHERE v1.kilometrage < (
    SELECT MIN(v2.kilometrage)
    FROM vehicule v2
    WHERE v2.id_agence = 1
);

-- 3.20) 
select 
	c.id_client,
    c.nom,
    c.prenom
from client c
where NOT EXISTS (
	Select 1
    FROM Location l
    JOIN Vehicule v
        ON l.immatriculation = v.immatriculation
    WHERE l.id_client = c.id_client
      AND v.carburant = 'Hybride'
);

-- E. Opérateurs ensemblistes 
-- 3.21)
SELECT ville FROM agence
UNION
SELECT ville FROM client;

SELECT ville FROM agence
UNION ALL
SELECT ville FROM client;

-- 3.22)
SELECT ville FROM agence
INTERSECT
SELECT ville FROM client;

SELECT DISTINCT ville
FROM agence
WHERE ville IN (
    SELECT ville
    FROM client
);


 

