SELECT
    c.id_client,
    c.nom,
    c.prenom
FROM Client c 
WHERE c.id_client IN (
    SELECT l.id_client
    FROM Location l
    WHERE l.immatriculation IN (
        SELECT v.immatriculation
        FROM Vehicule v
        WHERE v.code_cat = 'SUV' -- 5 vehicule de SUV
    ) -- tout client que deja loue une vehicule de SUV '15'
); -- givem nom and peronom 

Select * from Categorie;