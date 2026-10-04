USE atlascar;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS Location_Equipement, Location, Equipement, Equeipement, Client, Vehicule, Categorie, Agence;
SET FOREIGN_KEY_CHECKS = 1;

-- 1) Agence
CREATE TABLE Agence (
    id_agence  INT AUTO_INCREMENT,
    nom_agence  VARCHAR(100) NOT NULL,
    ville  VARCHAR(100) NOT NULL,
    telephone  VARCHAR(20), 
    CONSTRAINT pk_agence PRIMARY KEY (id_agence),
    CONSTRAINT uq_agence_telephone UNIQUE (telephone)
);

-- 2) Categorie
CREATE TABLE Categorie (
    code_cat  CHAR(3),
    libelle VARCHAR(50),
    tarif_jour  DECIMAL(8,2) NOT NULL,
    CONSTRAINT pk_categorie PRIMARY KEY (code_cat),
    CONSTRAINT ck_categorie_tarif CHECK (tarif_jour > 0)
);

-- 3) Vehicule
CREATE TABLE Vehicule (
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

-- 4) Client
CREATE TABLE Client (
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

-- 5) Location
CREATE TABLE Location (
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

-- 6) Equipement
CREATE TABLE Equipement (
    code_equip  VARCHAR(10),
    libelle     VARCHAR(100) NOT NULL,
    prix_jour   DECIMAL(6,2),
    CONSTRAINT pk_equip PRIMARY KEY (code_equip),
    CONSTRAINT ck_equipement_prix_jour CHECK (prix_jour > 0)
);

-- 7) Location_Equipement (clé primaire composée)
CREATE TABLE Location_Equipement (
    id_location    INT NOT NULL,
    code_equip  VARCHAR(10) NOT NULL,
    quantite       SMALLINT NOT NULL DEFAULT 1,
    CONSTRAINT pk_location_equipement PRIMARY KEY (id_location, code_equip),
    CONSTRAINT ck_le_quantite CHECK (quantite >= 1),
    CONSTRAINT fk_le_location   FOREIGN KEY (id_location)   REFERENCES Location(id_location),
    CONSTRAINT fk_le_equip FOREIGN KEY (code_equip) REFERENCES Equipement(code_equip)
);