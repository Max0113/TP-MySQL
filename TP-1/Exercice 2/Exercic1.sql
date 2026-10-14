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

