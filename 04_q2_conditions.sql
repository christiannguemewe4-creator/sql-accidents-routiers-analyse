use accidents_routiers;
SELECT
  lumiere ,
  COUNT(DISTINCT num_acc)                  AS nb_accidents,
  SUM(est_tue)                             AS nb_tues,
  ROUND(100 * SUM(est_tue) / COUNT(*), 2)  AS taux_mortalite_pct
FROM caract 
JOIN usagers using(num_acc)
GROUP BY lumiere
ORDER BY taux_mortalite_pct DESC;
-- CONCLUSION (lumière) :
-- La nuit sans éclairage public est la condition la plus meurtrière :
-- 6,15 % des usagers impliqués sont tués, soit 2,6 fois plus qu'en plein jour (2,37 %).
-- Le plein jour concentre la majorité des accidents (35 580), car les routes
-- sont plus fréquentées, mais ils sont moins graves.
-- Surprise : la nuit avec éclairage allumé est la moins meurtrière (1,58 %)
-- malgré 8 499 accidents. Hypothèse : ces routes sont surtout en ville,
-- où la vitesse est plus basse (à vérifier en Q3).
-- Cela confirme l'hypothèse de la Q1 : les jours courts de l'automne et de
-- l'hiver augmentent les trajets dans l'obscurité, donc la mortalité.
-- Action : prioriser l'éclairage et les contrôles de vitesse sur les routes
-- non éclairées hors agglomération.
