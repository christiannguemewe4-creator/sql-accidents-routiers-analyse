-- Quels véhicules sont les plus dangereux pour leurs usagers (voiture, moto, vélo, trottinette…)
SELECT  famille_vehicule,
  COUNT(*) AS nb_usagers ,
SUM(est_tue) AS nb_tues,
 ROUND(100 * SUM(est_tue) / COUNT(*), 2)  AS taux_mortalite_pct                
FROM usagers 
JOIN vehicules USING(id_vehicule)
WHERE categorie_usager <> 'Piéton'
GROUP BY famille_vehicule
ORDER BY taux_mortalite_pct DESC;
-- CONCLUSION (type de véhicule, hors piétons) :
-- Les deux-roues motorisés sont les plus dangereux pour leurs usagers :
-- 4,11 % des usagers impliqués tués, soit 1,8 fois plus qu'en voiture (2,26 %).
-- Ils représentent 16,9 % des usagers impliqués (19 519),
-- mais 27,4 % des tués (803 sur 2 934).
-- Le vélo est presque aussi meurtrier (3,95 %) malgré une vitesse plus faible.
-- Hypothèse : motards et cyclistes n'ont aucune carrosserie pour les protéger.
-- La trottinette est moins meurtrière (1,49 %). Hypothèse : usage surtout
-- urbain, sur de courtes distances et à vitesse limitée.
-- En nombre, la voiture reste la première cause de décès : 55,8 % des tués
-- (1 638), car elle concentre la majorité des usagers (72 388).
-- Les groupes « Autre » et NULL sont trop petits pour conclure.
-- Action : campagnes ciblées sur les deux-roues (équipements de protection,
-- formation) et pistes cyclables séparées de la circulation.