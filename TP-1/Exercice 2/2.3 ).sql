use atlascar ;
SET SQL_SAFE_UPDATES = 0;

-- 2.3) 
INSERT INTO vehicule
(immatriculation, marque, modele, annee, carburant, code_cat, id_agence)
VALUES
('60001-A-40', 'Renault', 'Kardian', 2026, 'Essence', 'CIT', 5);

SELECT * FROM vehicule
WHERE immatriculation = '60001-A-40';

-- kilometrage = 0
-- status      = disponible