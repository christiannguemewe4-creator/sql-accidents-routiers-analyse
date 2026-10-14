SELECT
  agglomeration ,
  COUNT(DISTINCT num_acc)                  AS nb_accidents,
  SUM(est_tue)                             AS nb_tues,
  ROUND(100 * SUM(est_tue) / COUNT(*), 2)  AS taux_mortalite_pct
FROM caract 
JOIN usagers using(num_acc)
GROUP BY agglomeration
ORDER BY taux_mortalite_pct DESC;
-- CONCLUSION (ville / hors agglomération) :
-- La ville concentre la majorité des accidents (34 010, soit 62 %),
-- mais ils sont peu graves : 1,47 % des usagers impliqués tués.
-- Hors agglomération, il y a moins d'accidents (20 392, soit 38 %),
-- mais un usager impliqué y a 3,2 fois plus de risque de mourir (4,69 %).
-- Résultat : 38 % des accidents, mais 68 % des tués (2 323 sur 3 432).
-- Cela confirme l'hypothèse de la Q2 : les routes éclairées sont surtout
-- en ville, où la vitesse est plus basse, d'où leur faible mortalité.
-- Hypothèse : vitesse plus élevée hors agglomération (à vérifier avec vma).
-- Action : concentrer les contrôles de vitesse et la prévention sur les
-- routes hors agglomération.

-- =============================================
-- TABLE LIEUX_UNIQUE : une seule ligne par accident
-- (un accident à un carrefour a plusieurs lignes dans lieux)
-- =============================================
DROP TABLE IF EXISTS lieux_unique;

CREATE TABLE lieux_unique AS
SELECT
  TRIM(Num_Acc) AS num_acc,

  CASE MIN(CAST(TRIM(catr) AS SIGNED))
    WHEN 1 THEN 'Autoroute'
    WHEN 2 THEN 'Route nationale'
    WHEN 3 THEN 'Route départementale'
    WHEN 4 THEN 'Voie communale'
    WHEN 5 THEN 'Hors réseau public'
    WHEN 6 THEN 'Parc de stationnement'
    WHEN 7 THEN 'Route de métropole urbaine'
    WHEN 9 THEN 'Autre'
    ELSE NULL
  END AS categorie_route,

  MAX(CASE
        WHEN CAST(TRIM(vma) AS SIGNED) IN (10, 20, 30, 40, 50, 60, 70, 80, 90, 110, 130)
          THEN CAST(TRIM(vma) AS SIGNED)
        ELSE NULL
      END) AS vitesse_max

FROM lieux_brut
GROUP BY TRIM(Num_Acc);


SELECT COUNT(*) AS nb_lignes, COUNT(DISTINCT num_acc) AS nb_accidents
FROM lieux_unique;

SELECT
  agglomeration ,categorie_route,
  COUNT(DISTINCT num_acc)                  AS nb_accidents,
  SUM(est_tue)                             AS nb_tues,
  ROUND(100 * SUM(est_tue) / COUNT(*), 2)  AS taux_mortalite_pct
FROM caract 
JOIN usagers using(num_acc)
JOIN lieux_unique using(num_acc)
GROUP BY agglomeration, categorie_route
ORDER BY taux_mortalite_pct DESC;

SELECT SUM(est_tue) AS total_tues
FROM caract
JOIN usagers USING(num_acc)
JOIN lieux_unique USING(num_acc);
-- NOTE : on utilise lieux_unique et non lieux, car un accident à un carrefour
-- a plusieurs lignes dans lieux (15 645 accidents concernés), ce qui comptait
-- certains tués plusieurs fois (3 952 au lieu de 3 432).

-- CONCLUSION (zone x type de route) :
-- Les routes départementales hors agglomération sont le point noir :
-- 19 % des accidents (10 507), mais 46,4 % des tués (1 593 sur 3 432),
-- avec un taux de mortalité de 6,65 %.
-- Surprise : l'autoroute est 3,7 fois moins meurtrière (1,79 %)
-- malgré une vitesse de 130 km/h.
-- Hypothèse : voies séparées, pas de carrefours ni de véhicules en face,
-- alors que les départementales cumulent vitesse, virages et chocs frontaux.
-- En ville, les voies communales concentrent le plus d'accidents (21 233),
-- mais avec un faible taux (1,14 %). Hypothèse : vitesse limitée à 30-50 km/h.
-- Les taux des petits groupes (parcs de stationnement, hors réseau public,
-- autre : moins de 100 accidents chacun) sont peu fiables.
-- Action : priorité absolue aux départementales hors agglomération
-- (contrôles de vitesse, aménagements des carrefours, séparateurs de voies)

SELECT
  vitesse_max ,
  COUNT(DISTINCT num_acc)                  AS nb_accidents,
  SUM(est_tue)                             AS nb_tues,
  ROUND(100 * SUM(est_tue) / COUNT(*), 2)  AS taux_mortalite_pct
FROM caract 
JOIN usagers using(num_acc)
JOIN lieux_unique using(num_acc)
GROUP BY vitesse_max
ORDER BY vitesse_max DESC;

-- CONCLUSION (vitesse maximale autorisée) :
-- Les routes limitées à 80 km/h sont les plus meurtrières : 7,14 % des usagers
-- impliqués tués, et 34,7 % de tous les tués (1 190 sur 3 432).
-- Le taux ne suit pas la vitesse : 80 km/h est 2 fois plus meurtrier que
-- 90 km/h (3,54 %) et 130 km/h (3,40 %).
-- Hypothèse : les routes à 80 km/h sont surtout des départementales à double
-- sens (virages, carrefours, chocs frontaux), ce qui confirme le résultat
-- précédent sur les départementales hors agglomération.
-- En ville, la vitesse basse protège : 1,62 % à 50 km/h (24 811 accidents)
-- et 1,09 % à 30 km/h (8 937 accidents).
-- Prudence : 972 accidents n'ont pas de vitesse connue (NULL), et les groupes
-- à 10, 20, 40 et 60 km/h sont trop petits pour conclure.
-- Action : prioriser les routes à 80 km/h (contrôles, aménagements des
-- virages et carrefours) ; étendre les zones 30 en ville.