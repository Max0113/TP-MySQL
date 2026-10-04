SET SQL_SAFE_UPDATES = 0;

-- 2.6)
UPDATE client
SET email = 'y.alaoui@mail.ma'
WHERE nom = 'Alaoui'
  AND prenom = 'Youssef';

UPDATE client
SET email = 's.benali@mail.ma'
WHERE nom = 'Benali'
  AND prenom = 'Salma';