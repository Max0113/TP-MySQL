-- 3.16) 
select *
from vehicule
Where kilometrage > (select AVG(kilometrage) FROM vehicule) ;


-- 3.17) 
Select *
From vehicule
Where immatriculation NOT IN (
Select immatriculation from location
) ;

-- 3.18) 
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


-- 3.19) 
Select 
	v1.immatriculation,
    v1.marque,
    v1.modele,
    v1.kilometrage
from vehicule v1
where v1.kilometrage < all ( 
	-- here comaprte all kimtage of all center with center agadir 
    -- v1.kilometrage < all(3000 , 5000 , 6000) ++ v1.kilometrage < 3000 AND v1.kilometrage < 3000 AND v1.kilometrage < 6000
	Select v2.kilometrage
    From vehicule v2
    Where v2.id_agence = 1 -- he Collect all kilometrage of all vehicule for agence AtlasCar Agadir Centre
);

SELECT
    v.immatriculation,
    v.marque,
    v.modele,
    v.kilometrage
FROM Vehicule v
WHERE v.kilometrage < ALL (
    SELECT v2.kilometrage
    FROM Vehicule v2
    JOIN Agence a
        ON v2.id_agence = a.id_agence
    WHERE a.nom_agence = 'AtlasCar Agadir Centre'
);

SELECT
    v1.immatriculation,
    v1.marque,
    v1.modele,
    v1.kilometrage
FROM vehicule v1
WHERE v1.kilometrage < (
    SELECT MIN(v2.kilometrage)
    FROM vehicule v2
    WHERE v2.id_agence = 1
);

-- 3.20) 
select 
	c.id_client,
    c.nom,
    c.prenom
from client c
where NOT EXISTS (
	Select 1
    FROM Location l
    JOIN Vehicule v
        ON l.immatriculation = v.immatriculation
    WHERE l.id_client = c.id_client
      AND v.carburant = 'Hybride'
);
