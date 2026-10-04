-- 2.7)
UPDATE location
SET date_fin = '2026-09-27',
    km_retour = 54100
WHERE immatriculation = '32010-B-40';

SELECT *
FROM location
WHERE immatriculation = '32010-B-40';