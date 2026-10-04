USE atlascar;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS Location_Equipement, Location, Equipement, Equeipement, Client, Vehicule, Categorie, Agence;
SET FOREIGN_KEY_CHECKS = 1;

-- 1) Agence
CREATE TABLE Agence (
    id_agence  INT AUTO_INCREMENT,
    nom        VARCHAR(100) NOT NULL,
    ville      VARCHAR(100) NOT NULL,
    telephone  VARCHAR(20),
    CONSTRAINT pk_agence PRIMARY KEY (id_agence),
    CONSTRAINT uq_agence_telephone UNIQUE (telephone)
);

-- 2) Categorie
-- code_cat : CHAR(3) car le code a une longueur fixe de 3 caractères.
-- tarif_jour : DECIMAL(8,2) car montant monétaire exact (pas d'arrondi flottant).
CREATE TABLE Categorie (
    code_cat    CHAR(3),
    tarif_jour  DECIMAL(8,2) NOT NULL,
    CONSTRAINT pk_categorie PRIMARY KEY (code_cat),
    CONSTRAINT ck_categorie_tarif CHECK (tarif_jour > 0)
);

-- 3) Vehicule
CREATE TABLE Vehicule (
    id_vehicule      INT AUTO_INCREMENT,
    immatriculation  VARCHAR(15),
    marque           VARCHAR(50),
    modele           VARCHAR(50),
    kilometrage      INT NOT NULL DEFAULT 0,
    carburant        VARCHAR(15),
    code_cat         CHAR(3) NOT NULL,
    id_agence        INT NOT NULL,
    CONSTRAINT pk_vehicule PRIMARY KEY (id_vehicule),
    CONSTRAINT uq_vehicule_immat UNIQUE (immatriculation),
    CONSTRAINT ck_vehicule_km CHECK (kilometrage >= 0),
    CONSTRAINT ck_vehicule_carburant
        CHECK (carburant IN ('Essence', 'Diesel', 'Hybride', 'Electrique')),
    CONSTRAINT fk_vehicule_categorie FOREIGN KEY (code_cat)  REFERENCES Categorie(code_cat),
    CONSTRAINT fk_vehicule_agence    FOREIGN KEY (id_agence) REFERENCES Agence(id_agence)
);

-- 4) Client
CREATE TABLE Client (
    id_client  INT AUTO_INCREMENT,
    cin        VARCHAR(10) NOT NULL,
    nom        VARCHAR(100) NOT NULL,
    prenom     VARCHAR(100) NOT NULL,
    CONSTRAINT pk_client PRIMARY KEY (id_client),
    CONSTRAINT uq_client_cin UNIQUE (cin)
);

-- 5) Location
CREATE TABLE Location (
    id_location  INT AUTO_INCREMENT,
    date_debut   DATE NOT NULL,
    date_fin     DATE NULL,
    id_client    INT NOT NULL,
    id_vehicule  INT NOT NULL,
    CONSTRAINT pk_location PRIMARY KEY (id_location),
    CONSTRAINT ck_location_dates CHECK (date_fin IS NULL OR date_fin >= date_debut),
    CONSTRAINT fk_location_client   FOREIGN KEY (id_client)   REFERENCES Client(id_client),
    CONSTRAINT fk_location_vehicule FOREIGN KEY (id_vehicule) REFERENCES Vehicule(id_vehicule)
);

-- 6) Equipement
CREATE TABLE Equipement (
    id_equipement  INT AUTO_INCREMENT,
    libelle        VARCHAR(100) NOT NULL,
    prix_jour      DECIMAL(6,2),
    CONSTRAINT pk_equipement PRIMARY KEY (id_equipement),
    CONSTRAINT ck_equipement_prix_jour CHECK (prix_jour > 0)
);

-- 7) Location_Equipement (clé primaire composée)
CREATE TABLE Location_Equipement (
    id_location    INT NOT NULL,
    id_equipement  INT NOT NULL,
    quantite       SMALLINT NOT NULL DEFAULT 1,
    CONSTRAINT pk_location_equipement PRIMARY KEY (id_location, id_equipement),
    CONSTRAINT ck_le_quantite CHECK (quantite >= 1),
    CONSTRAINT fk_le_location   FOREIGN KEY (id_location)   REFERENCES Location(id_location),
    CONSTRAINT fk_le_equipement FOREIGN KEY (id_equipement) REFERENCES Equipement(id_equipement)
);