USE accidents_routiers;

-- =============================================
-- QUESTION 1 : Quand ont lieu les accidents les plus meurtriers ?
-- =============================================
SELECT
  MONTH(c.date_heure)                        AS mois,
  COUNT(DISTINCT c.num_acc)                  AS nb_accidents,
  SUM(u.est_tue)                             AS nb_tues,
  ROUND(100 * SUM(u.est_tue) / COUNT(*), 2)  AS taux_mortalite_pct
FROM caract c
JOIN usagers u ON c.num_acc = u.num_acc
GROUP BY mois
ORDER BY mois;
-- CONCLUSION (mois) :
-- L'été concentre le plus d'accidents (juillet : 5 209, juin : 5 135),
-- avec davantage de déplacements, de piétons et de deux-roues.
-- Août compte moins d'accidents (4 450) mais un taux de mortalité élevé (2,97 %),
-- probablement lié aux longs trajets des vacances.
-- L'automne et l'hiver sont les plus meurtriers : 3,06 % en octobre, 3,07 % en décembre.
-- Hypothèse : jours plus courts et conditions météo dégradées (à vérifier en Q2).
SELECT
  WEEKDAY(c.date_heure) + 1                 AS num_jour,
  CASE WEEKDAY(c.date_heure)
    WHEN 0 THEN 'Lundi'
    WHEN 1 THEN 'Mardi'
    WHEN 2 THEN 'Mercredi'
    WHEN 3 THEN 'Jeudi'
    WHEN 4 THEN 'Vendredi'
    WHEN 5 THEN 'Samedi'
    WHEN 6 THEN 'Dimanche'
  END                                       AS jour,
  COUNT(DISTINCT c.num_acc)                 AS nb_accidents,
  SUM(u.est_tue)                            AS nb_tues,
  ROUND(100 * SUM(u.est_tue) / COUNT(*), 2) AS taux_mortalite_pct
FROM caract c
JOIN usagers u ON c.num_acc = u.num_acc
GROUP BY num_jour, jour
ORDER BY num_jour;
-- CONCLUSION (jours) :
-- Le vendredi compte le plus d'accidents (8 976).
-- Le week-end est le plus meurtrier : samedi (594 tués) et dimanche
-- (taux de mortalité de 3,37 %, contre 2,32 % le lundi).
-- Samedi et dimanche concentrent 33 % des tués sur 2 jours sur 7.
-- Hypothèse : trajets de loisirs, sorties nocturnes (à vérifier avec les heures).


SELECT
  HOUR(c.date_heure)                 AS num_Heure,
  CASE HOUR(c.date_heure)
    WHEN 0 THEN '00h - 01h'
    WHEN 1 THEN '01h - 02h'
    WHEN 2 THEN '02h - 03h'
    WHEN 3 THEN '03h - 04h'
    WHEN 4 THEN '04h - 05h'
    WHEN 5 THEN '05h - 06h'
    WHEN 6 THEN '06h - 07h'
    WHEN 7 THEN '07h - 08h'
    WHEN 8 THEN '08h - 09h'
    WHEN 9 THEN '09h - 10h'
    WHEN 10 THEN '10h - 11h'
    WHEN 11 THEN '11h - 12h'
    WHEN 12 THEN '12h - 13h'
    WHEN 13 THEN '13h - 14h'
    WHEN 14 THEN '14h - 15h'
    WHEN 15 THEN '15h - 16h'
    WHEN 16 THEN '16h - 17h'
    WHEN 17 THEN '17h - 18h'
    WHEN 18 THEN '18h - 19h'
    WHEN 19 THEN '19h - 20h'
    WHEN 20 THEN '20h - 21h'
    WHEN 21 THEN '21h - 22h'
    WHEN 22 THEN '22h - 23h'
    WHEN 23 THEN '23h - 00h'
  END                                       AS HEURE,
  COUNT(DISTINCT c.num_acc)                 AS nb_accidents,
  SUM(u.est_tue)                            AS nb_tues,
  ROUND(100 * SUM(u.est_tue) / COUNT(*), 2) AS taux_mortalite_pct
FROM caract c
JOIN usagers u ON c.num_acc = u.num_acc
GROUP BY num_Heure, Heure
ORDER BY num_Heure;



SELECT
  HOUR(c.date_heure)                                AS heure,
  CONCAT(LPAD(HOUR(c.date_heure), 2, '0'), 'h')     AS heure_debut,
  COUNT(DISTINCT c.num_acc)                         AS nb_accidents,
  SUM(u.est_tue)                                    AS nb_tues,
  ROUND(100 * SUM(u.est_tue) / COUNT(*), 2)         AS taux_mortalite_pct
FROM caract c
JOIN usagers u ON c.num_acc = u.num_acc
GROUP BY heure, heure_debut
ORDER BY heure;

-- CONCLUSION (heures) :
-- De 7h à 18h, les accidents sont nombreux (de 2 438 à 4 607), avec un pic
-- à 17h (4 607), probablement lié aux trajets de retour du travail.
-- Mais leur taux de mortalité reste bas (de 1,93 % à 2,75 %).
-- De 1h à 5h, les accidents sont rares (de 602 à 955), mais beaucoup plus graves :
-- de 4,62 % à 6,35 % des usagers impliqués sont tués.
-- À 5h, le taux (6,35 %) est 3 fois plus élevé qu'à 13h (1,93 %).
-- Hypothèses : sorties nocturnes, fatigue, faible visibilité, vitesse plus élevée
-- sur des routes vides. Lien avec le week-end à vérifier (croisement jour x heure).
-- Action : renforcer les contrôles et la prévention la nuit, entre 1h et 6h.


WITH base AS (
  SELECT
    c.num_acc,
    u.est_tue,
    CASE WHEN WEEKDAY(c.date_heure) >= 5 THEN 'Week-end' ELSE 'Semaine' END AS periode_semaine,
   CASE WHEN HOUR(c.date_heure) >= 22 OR HOUR(c.date_heure) < 6
     THEN 'Nuit' ELSE 'Jour' END AS moment
  FROM caract c
  JOIN usagers u ON c.num_acc = u.num_acc
)
SELECT
  periode_semaine,
  moment,
  COUNT(DISTINCT num_acc)   AS nb_accidents,
   SUM(est_tue)  AS nb_tues,
 ROUND(100 * SUM(est_tue) / COUNT(*), 2) AS taux_mortalite_pct
FROM base
GROUP BY  periode_semaine,
  moment
ORDER BY periode_semaine, moment;
-- CONCLUSION (croisement jour x heure) :
-- La nuit est aussi meurtrière en semaine (4,57 %) que le week-end (4,47 %) :
-- le danger vient de la nuit elle-même, pas du week-end.
-- En journée, le week-end est plus meurtrier : 2,87 % contre 2,31 % en semaine.
-- Hypothèse : trajets de loisirs, routes de campagne, vitesse plus élevée.
-- Le week-end compte 2 fois plus d'accidents de nuit en proportion
-- (23,8 % contre 10,8 % en semaine), ce qui explique sa mortalité plus élevée.
-- Action : contrôles de nuit tous les jours, renforcés le week-end
-- car les accidents de nuit y sont plus nombreux.