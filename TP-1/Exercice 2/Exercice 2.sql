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
