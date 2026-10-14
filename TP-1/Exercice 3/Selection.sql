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



