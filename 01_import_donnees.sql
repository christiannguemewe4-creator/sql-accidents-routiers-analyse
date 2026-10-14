USE accidents_routiers;
SET SQL_SAFE_UPDATES = 0;

-- CARACT : vider, réimporter, supprimer la ligne fantôme
TRUNCATE TABLE caract_brut;
LOAD DATA LOCAL INFILE 'C:/Users/dskri/Downloads/caract-2024.csv'
INTO TABLE caract_brut CHARACTER SET utf8mb4
FIELDS TERMINATED BY ';' ENCLOSED BY '"'
LINES TERMINATED BY '\n' IGNORE 1 LINES;
DELETE FROM caract_brut WHERE jour IS NULL;

-- LIEUX : vider, réimporter, supprimer la ligne fantôme
TRUNCATE TABLE lieux_brut;
LOAD DATA LOCAL INFILE 'C:/Users/dskri/Downloads/lieux-2024.csv'
INTO TABLE lieux_brut CHARACTER SET utf8mb4
FIELDS TERMINATED BY ';' ENCLOSED BY '"'
LINES TERMINATED BY '\n' IGNORE 1 LINES;
DELETE FROM lieux_brut WHERE catr IS NULL;

SET SQL_SAFE_UPDATES = 1;

-- CONTRÔLE FINAL
SELECT 'caract' AS tab, COUNT(*) AS nb FROM caract_brut
UNION ALL SELECT 'lieux', COUNT(*) FROM lieux_brut
UNION ALL SELECT 'vehicules', COUNT(*) FROM vehicules_brut
UNION ALL SELECT 'usagers', COUNT(*) FROM usagers_brut;