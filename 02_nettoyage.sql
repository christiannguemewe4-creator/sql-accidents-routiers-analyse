USE accidents_routiers;

SELECT Num_Acc, jour, mois, an, hrmn, lum, atm, agg, dep, lat, `long`
FROM caract_brut
LIMIT 20;

SELECT
  lat,
  REPLACE(TRIM(lat), ',', '.')                          AS lat_texte_propre,
  CAST(REPLACE(TRIM(lat), ',', '.') AS DECIMAL(10,6))   AS lat_nombre
FROM caract_brut
LIMIT 10;


SELECT
  agg,
  CASE TRIM(agg)
    WHEN '1' THEN 'Hors agglomération'
    WHEN '2' THEN 'En agglomération'
    ELSE NULL
  END AS agglomeration
FROM caract_brut
LIMIT 10;

SELECT
  dep,
  TRIM(dep) AS departement
FROM caract_brut
LIMIT 10;
SELECT dep, COUNT(*) AS nb
FROM caract_brut
GROUP BY dep
ORDER BY dep;

SELECT COUNT(DISTINCT dep) AS nb_departements
FROM caract_brut;

SELECT dep, COUNT(*) AS nb
FROM caract_brut
GROUP BY dep
ORDER BY dep DESC
LIMIT 10;

SELECT
  jour, mois, an, hrmn,
  CONCAT(an, '-', mois, '-', jour, ' ', hrmn)            AS date_texte,
  STR_TO_DATE(CONCAT(an, '-', mois, '-', jour, ' ', hrmn),
              '%Y-%m-%d %H:%i')                          AS date_heure
FROM caract_brut
LIMIT 10;

SELECT CAST(REPLACE(TRIM(`long`), ',', '.') AS DECIMAL(10,6)) AS longitude
FROM caract_brut
LIMIT 10;

SELECT COUNT(*) AS dates_invalides
FROM caract_brut
WHERE STR_TO_DATE(CONCAT(an,'-',mois,'-',jour,' ',hrmn), '%Y-%m-%d %H:%i') IS NULL;

SELECT
  lum,
  CASE TRIM(lum)
    WHEN '1' THEN 'Plein jour'
    WHEN '2' THEN 'Crépuscule ou aube'
    WHEN '3' THEN 'Nuit sans éclairage public'
    WHEN '4' THEN 'Nuit avec éclairage public non allumé'
    WHEN '5' THEN 'Nuit avec éclairage public allumé'
    ELSE NULL
  END AS lumiere
FROM caract_brut
LIMIT 10;

select
atm,
CASE TRIM(atm)
        WHEN '-1' THEN NULL
        WHEN '1' THEN 'Normale'
        WHEN '2' THEN 'Pluie légère'
        WHEN '3' THEN 'Pluie forte'
        WHEN '4' THEN 'Neige, grêle'
        WHEN '5' THEN 'Brouillard, fumée'
        WHEN '6' THEN 'Vent fort, tempête'
        WHEN '7' THEN 'Temps éblouissant'
        WHEN '8' THEN 'Temps couvert'
        WHEN '9' THEN 'Autre'
        ELSE NULL
    END AS meteo
    FROM caract_brut
LIMIT 10;



DROP TABLE IF EXISTS caract;

CREATE TABLE caract AS
SELECT
  TRIM(Num_Acc) AS num_acc,

  STR_TO_DATE(CONCAT(an,'-',mois,'-',jour,' ',hrmn), '%Y-%m-%d %H:%i') AS date_heure,

  CASE TRIM(lum)
    WHEN '1' THEN 'Plein jour'
    WHEN '2' THEN 'Crépuscule ou aube'
    WHEN '3' THEN 'Nuit sans éclairage public'
    WHEN '4' THEN 'Nuit avec éclairage public non allumé'
    WHEN '5' THEN 'Nuit avec éclairage public allumé'
    ELSE NULL
  END AS lumiere,
  CASE TRIM(atm)
    WHEN '-1' THEN NULL
    WHEN '1' THEN 'Normale'
    WHEN '2' THEN 'Pluie légère'
    WHEN '3' THEN 'Pluie forte'
    WHEN '4' THEN 'Neige, grêle'
    WHEN '5' THEN 'Brouillard, fumée'
    WHEN '6' THEN 'Vent fort, tempête'
    WHEN '7' THEN 'Temps éblouissant'
    WHEN '8' THEN 'Temps couvert'
    WHEN '9' THEN 'Autre'
    ELSE NULL
  END AS meteo,

  CASE TRIM(agg)
    WHEN '1' THEN 'Hors agglomération'
    WHEN '2' THEN 'En agglomération'
    ELSE NULL
  END AS agglomeration,

  TRIM(dep) AS departement,

  CASE WHEN LENGTH(TRIM(dep)) = 3 THEN 'Outre-mer'
       ELSE 'Métropole'
  END AS zone,

  CAST(REPLACE(TRIM(lat), ',', '.')    AS DECIMAL(10,6)) AS latitude,
  CAST(REPLACE(TRIM(`long`), ',', '.') AS DECIMAL(10,6)) AS longitude

FROM caract_brut;

SELECT * FROM caract LIMIT 10;

SELECT COUNT(*) FROM caract;

-- =============================================
-- TABLE LIEUX
-- =============================================

SELECT vma, COUNT(*) AS nb
FROM lieux_brut
GROUP BY vma
ORDER BY CAST(TRIM(vma) AS SIGNED);

SELECT
  vma,
  CASE
    WHEN CAST(TRIM(vma) AS SIGNED) IN (10, 20, 30, 40, 50, 60, 70, 80, 90, 110, 130)
      THEN CAST(TRIM(vma) AS SIGNED)
    ELSE NULL
  END AS vitesse_max,
  COUNT(*) AS nb
FROM lieux_brut
GROUP BY vma
ORDER BY CAST(TRIM(vma) AS SIGNED);


SELECT
    catr,
    CASE TRIM(catr)
        WHEN '1' THEN 'Autoroute'
        WHEN '2' THEN 'Route nationale'
        WHEN '3' THEN 'Route départementale'
        WHEN '4' THEN 'Voie communale'
        WHEN '5' THEN 'Hors réseau public'
        WHEN '6' THEN 'Parc de stationnement'
        WHEN '7' THEN 'Route de métropole urbaine'
        WHEN '9' THEN 'Autre'
        ELSE NULL
    END AS categorie_route,
    COUNT(*) AS nb
FROM lieux_brut
GROUP BY catr, categorie_route
ORDER BY catr;



DROP TABLE IF EXISTS lieux;

CREATE TABLE lieux AS
SELECT
  TRIM(Num_Acc) AS num_acc,

  CASE TRIM(catr)
    WHEN '1' THEN 'Autoroute'
    WHEN '2' THEN 'Route nationale'
    WHEN '3' THEN 'Route départementale'
    WHEN '4' THEN 'Voie communale'
    WHEN '5' THEN 'Hors réseau public'
    WHEN '6' THEN 'Parc de stationnement'
    WHEN '7' THEN 'Route de métropole urbaine'
    WHEN '9' THEN 'Autre'
    ELSE NULL
  END AS categorie_route,

  CASE
    WHEN CAST(TRIM(vma) AS SIGNED) IN (10, 20, 30, 40, 50, 60, 70, 80, 90, 110, 130)
      THEN CAST(TRIM(vma) AS SIGNED)
    ELSE NULL
  END AS vitesse_max
FROM lieux_brut;



