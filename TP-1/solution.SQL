-- 4.1 Montant total de chaque location terminée, équipements compris
SELECT l.id_location,
DATEDIFF(l.date_fin, l.date_debut) _
(c.tarif_journalier +
COALESCE(SUM(e.prix_journalier _ le.quantite), 0)) AS montant_total
FROM location l
JOIN vehicule v ON l.id_vehicule = v.id_vehicule
JOIN categorie c ON v.id_categorie = c.id_categorie
LEFT JOIN location_equipement le ON l.id_location = le.id_location
LEFT JOIN equipement e ON le.id_equipement = e.id_equipement
WHERE l.date_fin < CURDATE()
GROUP BY l.id_location, l.date_debut, l.date_fin, c.tarif_journalier;

-- 4.2 Véhicule(s) le(s) plus loué(s) par agence, égalités incluses
SELECT a.id_agence, v.id_vehicule, COUNT(l.id_location) AS nombre_locations
FROM agence a
JOIN vehicule v ON a.id_agence = v.id_agence
JOIN location l ON l.id_vehicule = v.id_vehicule
GROUP BY a.id_agence, v.id_vehicule
HAVING COUNT(l.id_location) >= ALL (
SELECT COUNT(l2.id_location)
FROM vehicule v2
JOIN location l2 ON l2.id_vehicule = v2.id_vehicule
WHERE v2.id_agence = a.id_agence
GROUP BY v2.id_vehicule
);

-- 4.3 Client(s) ayant le plus dépensé, sans LIMIT
SELECT c.id_client, SUM(l.prix) AS total_depense
FROM client c
JOIN location l ON l.id_client = c.id_client
GROUP BY c.id_client
HAVING SUM(l.prix) >= ALL (
SELECT SUM(l2.prix)
FROM location l2
GROUP BY l2.id_client
);
