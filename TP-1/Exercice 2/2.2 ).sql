-- 2.2) 
-- a)
-- Resultat attendu :
-- Erreur : le CIN 'JB123456' existe déjà.
-- Contrainte : UNIQUE sur client.cin

-- INSERT INTO client (cin, nom, prenom, ville, telephone, date_permis)
-- VALUES ('JB123456', 'Test', 'Client', 'Agadir', '0600000000', '2020-01-01');

-- b)
-- Resultat attendu :
-- Erreur : la catégorie 'XXX' n'existe pas.
-- Contrainte : FOREIGN KEY code_cat -> categorie(code_cat)

-- INSERT INTO vehicule
-- (immatriculation, marque, modele, annee, kilometrage, carburant, code_cat, id_agence)
-- VALUES
-- ('99999-X-40', 'Test', 'Test', 2026, 0, 'Essence', 'XXX', 1);

-- c) 
-- Resultat attendu :
-- Erreur : le kilométrage ne peut pas être négatif.
-- Contrainte : CHECK sur kilometrage

-- INSERT INTO vehicule
-- (immatriculation, marque, modele, annee, kilometrage, carburant, code_cat, id_agence)
-- VALUES
-- ('99998-X-40', 'Test', 'Test', 2026, -50, 'Essence', 'ECO', 1);

-- b) 
-- Resultat attendu :
-- Erreur : GPL n'est pas une valeur autorisée pour carburant.
-- Contrainte : CHECK / ENUM sur carburant

-- INSERT INTO vehicule
-- (immatriculation, marque, modele, annee, kilometrage, carburant, code_cat, id_agence)
-- VALUES
-- ('99997-X-40', 'Test', 'Test', 2026, 0, 'GPL', 'ECO', 1);

-- e)  
-- Resultat attendu :
-- Erreur : date_fin doit être >= date_debut.
-- Contrainte : CHECK sur les dates

-- INSERT INTO location
-- (id_client, immatriculation, date_debut, date_fin, km_depart, km_retour)
-- VALUES
-- (1, '10231-A-40', '2026-10-10', '2026-10-05', 70000, 70500);

-- f) 
-- Resultat attendu :
-- Erreur : l'agence n°1 est référencée par plusieurs véhicules.
-- Contrainte : FOREIGN KEY de vehicule vers agence

-- DELETE FROM agence
-- WHERE id_agence = 1;

-- g)
-- Resultat attendu :
-- Erreur : CIN obligatoire.
-- Contrainte : NOT NULL sur cin

-- INSERT INTO client (nom, prenom, ville, telephone, date_permis)
-- VALUES ('Test', 'Client', 'Agadir', '0600000000', '2020-01-01');
