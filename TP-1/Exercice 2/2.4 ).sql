use atlascar ;
SET SQL_SAFE_UPDATES = 0;

-- 2.4) 
INSERT INTO client
(cin, nom, prenom, ville, telephone, date_permis)
VALUES
('JX999999', 'VotreNom', 'VotrePrenom', 'Agadir', '0612345678', '2026-01-01');

SELECT * FROM client ;

-- id_client = 11