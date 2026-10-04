SET SQL_SAFE_UPDATES = 0;

-- 2.5) 
UPDATE categorie
SET tarif_jour = tarif_jour * 1.10
WHERE code_cat = 'SUV';

SELECT * FROM categorie
WHERE code_cat = 'SUV';