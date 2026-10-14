SELECT categorie_usager,
  COUNT(*) AS nb_usagers ,
SUM(est_tue) AS nb_tues,
 ROUND(100 * SUM(est_tue) / COUNT(*), 2)  AS taux_mortalite_pct                
FROM usagers 
GROUP BY categorie_usager
ORDER BY taux_mortalite_pct DESC;

-- CONCLUSION (catégorie d'usager) :
-- Les piétons sont les plus vulnérables : 5,30 % des piétons impliqués
-- sont tués, soit 2 fois plus que les conducteurs (2,67 %)
-- et 2,7 fois plus que les passagers (2,00 %).
-- Ils ne représentent que 7,5 % des usagers impliqués (9 401),
-- mais 14,5 % des tués (498 sur 3 432).
-- En nombre, les conducteurs restent la majorité des tués :
-- 71,9 % (2 469), car ils sont les plus nombreux.
-- Hypothèse : le piéton n'a aucune protection (ni carrosserie,
-- ni ceinture, ni airbag) face à un véhicule.
-- Action : sécuriser les passages piétons (éclairage, ralentisseurs)
-- et sensibiliser les conducteurs, surtout la nuit.
SELECT sexe,
  COUNT(*) AS nb_usagers ,
SUM(est_tue) AS nb_tues,
 ROUND(100 * SUM(est_tue) / COUNT(*), 2)  AS taux_mortalite_pct                
FROM usagers 
GROUP BY sexe
ORDER BY taux_mortalite_pct DESC;
-- CONCLUSION (sexe) :
-- Les hommes représentent 67 % des usagers impliqués (83 864),
-- mais 77,6 % des tués (2 663 sur 3 432).
-- Leur taux de mortalité (3,18 %) est 1,6 fois plus élevé
-- que celui des femmes (1,98 %).
-- Hypothèses : comportements plus risqués (vitesse, alcool), usage plus
-- fréquent des deux-roues motorisés, davantage de kilomètres parcourus.
-- À vérifier en Q5 avec le type de véhicule.
-- Note : 2 395 usagers sans sexe renseigné (NULL), aucun tué parmi eux :
-- sans impact sur la conclusion.
-- Action : cibler les campagnes de prévention (vitesse, alcool, moto)
-- vers les conducteurs masculins.

SELECT
    CASE
        WHEN age IS NULL THEN 'Inconnu'
        WHEN age < 18 THEN '0-17 ans'
        WHEN age < 25 THEN '18-24 ans'
        WHEN age < 45 THEN '25-44 ans'
        WHEN age < 65 THEN '45-64 ans'
        ELSE '65 ans et +'
    END AS tranche_age,
    COUNT(*) AS nb_usagers,
    SUM(est_tue) AS nb_tues,
    ROUND(100 * SUM(est_tue) / COUNT(*), 2) AS taux_mortalite_pct
FROM usagers
GROUP BY tranche_age
ORDER BY taux_mortalite_pct DESC;
-- CONCLUSION (âge) :
-- Les 65 ans et + sont les plus vulnérables : 6,61 % des seniors impliqués
-- sont tués, soit 3 fois plus que les 25-44 ans (2,17 %).
-- Ils représentent 11,4 % des usagers impliqués (14 321),
-- mais 27,6 % des tués (947 sur 3 432).
-- Les 25-44 ans sont les plus nombreux parmi les usagers impliqués (43 745),
-- mais avec un taux plus faible.
-- Contrairement aux idées reçues, les 18-24 ans (2,43 %) ne sont pas
-- la tranche la plus à risque de mourir.
-- Hypothèse : fragilité physique des seniors, qui survivent moins bien aux chocs ;
-- part importante de piétons âgés (à vérifier en croisant âge et catégorie).
-- Note : 2 579 usagers sans âge connu (aucun tué), classés à part.
-- Action : sécuriser les traversées piétonnes près des lieux fréquentés
-- par les seniors, et sensibiliser les conducteurs âgés.

