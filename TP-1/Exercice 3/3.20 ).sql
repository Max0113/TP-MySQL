use atlascar;
select * from vehicule;

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
