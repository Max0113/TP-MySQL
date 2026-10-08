Select * from agence ;
-- AtlasCar Agadir Centre|

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