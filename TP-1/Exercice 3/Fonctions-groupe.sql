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