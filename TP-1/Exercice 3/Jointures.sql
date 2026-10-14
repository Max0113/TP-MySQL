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

 