SELECT
    id_client,
    nom,
    prenom
FROM Client
WHERE id_client IN (
    SELECT id_client
    FROM Location 
    WHERE immatriculation IN (
        SELECT immatriculation
        FROM Vehicule 
        WHERE code_cat = 'SUV' -- 5 vehicule de SUV
    ) -- tout client que deja loue une vehicule de SUV '15'
); -- givem nom and peronom 

Select * from Categorie;