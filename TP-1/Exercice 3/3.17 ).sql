Select *
From vehicule
Where immatriculation NOT IN (
Select immatriculation from location
) ;

Select * from location
Where immatriculation = '50333-B-40';