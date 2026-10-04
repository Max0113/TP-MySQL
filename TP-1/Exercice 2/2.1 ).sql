-- =====================================================================
-- TP 1 - AtlasCar : jeu de donnees (a executer apres la Partie 1)
-- =====================================================================
USE atlascar;

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
