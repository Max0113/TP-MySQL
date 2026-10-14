-- 3.21)
SELECT ville FROM agence
UNION
SELECT ville FROM client;

SELECT ville FROM agence
UNION ALL
SELECT ville FROM client;
-- 3.22)
SELECT ville FROM agence
INTERSECT
SELECT ville FROM client;

SELECT DISTINCT ville
FROM agence
WHERE ville IN (
    SELECT ville
    FROM client
);