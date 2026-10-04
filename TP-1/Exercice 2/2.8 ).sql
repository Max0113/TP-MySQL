-- 2.8)
UPDATE vehicule
set status = 'maintenance'
where marque = 'Hyundai' AND modele = 'Accent';

SELECT * from vehicule
WHERE marque = 'Hyundai' AND modele = 'Accent';