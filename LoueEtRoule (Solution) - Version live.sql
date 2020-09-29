-- TP1 Solution - BD LoueEtRoule

-- Partie B - Requêtes

-- 1.	Faire afficher en ordre décroissant de kilométrage, la liste des autos (numéro et km au compteur) en bon état général (sans entretien à faire) ayant plus de 100 000 km au compteur.
		SELECT km_au_compteur, no_auto
		FROM auto
		WHERE km_au_compteur > 100000 AND entretien_à_faire IS NULL
		ORDER BY km_au_compteur DESC;


-- 2.	Faire afficher la durée moyenne (en nombre de jours) d'une location. 
		SELECT AVG((TO_DAYS(date_fin_location) - TO_DAYS(date_début_location))) 
						AS moyenne_nbJoursLocation
		FROM location;
		
		-- Autre solution
		SELECT AVG(DATEDIFF(date_fin_location, date_début_location)) AS moyenne_durée_location
		FROM location;
		
		
-- 3.	Faire afficher le nombre de voitures qui ont été louées le 1 juillet 2018 (fête du Canada). 
		SELECT COUNT(no_auto) AS  NblocationsPremierjuillet
		FROM location
		WHERE date_début_location = '2018-07-01';

		
		
-- 4.	Faire afficher le nombre de locations par chaque client (numéro de client, nom, prénom et nombre de locations).
		SELECT location.no_client, nom_client, COUNT(no_location) AS nbLocations
		FROM location INNER JOIN client 
						ON location.no_client = client.no_client
		GROUP BY location.no_client, nom_client;

-- 5.	Faire afficher la liste des véhicules (constructeur, modèle, km au compteur, numéro d’auto) ordonnés par constructeur et modèle.
		SELECT constructeur, modèle, km_au_compteur, no_auto 
		FROM modèle INNER JOIN auto 
						  ON modèle.code_modèle = auto.code_modèle
		ORDER BY constructeur, modèle, km_au_compteur;

		
-- 6.	Faire afficher la liste des clients (nom et prénom) ayant fait au moins une location.
		SELECT nom_client, prénom_client
		FROM client 
		WHERE no_client IN (SELECT DISTINCT no_client 
							 FROM location);

--  	Autre solutions : 
		SELECT CONCAT(client.nom_client, ', ', client.prénom_client) AS nom_complet, 
			COUNT(location.no_client) AS nb_locations
		FROM client INNER JOIN location 
					ON client.no_client = location.no_client
		GROUP BY client.no_client;
							 
-- 7.	Faire afficher la liste des clients dont la ville commence par L.
		SELECT nom_client, prénom_client
		FROM client
		WHERE ville_client LIKE 'L%';


-- 8.	Faire afficher les clients qui ont loué un véhicule un mardi.
		SELECT nom_client, prénom_client, DAYNAME(date_début_location) AS 'Début location'
		FROM client JOIN location
						on client.no_client = location.no_client
		WHERE DAYNAME(date_début_location) = "tuesday";


-- 9.	Faire afficher les prénom, nom et initiales de chaque client qui ont loué un véhicule au mois de juillet.
		SELECT prénom_client, nom_client, CONCAT(SUBSTR(prénom_client, 1, 1), SUBSTR(nom_client, 1, 1)) AS Initiales
		FROM client JOIN location
						on client.no_client = location.no_client
		WHERE MONTHNAME(date_début_location) = "July";


-- 10.	Faire afficher les dates de location sous le format « Monday, 2nd September 2018». de chaque client
		SELECT nom_client, prénom_client, DATE_FORMAT(date_début_location, "%W, %D %M %Y") AS 'Début location',
													 DATE_FORMAT(date_fin_location, "%W, %D %M %Y")	AS 'Fin location'
		FROM client JOIN location
					on client.no_client = location.no_client;
		

-- 11.	Faire afficher les clients qui ont loué un véhicule pendant 1 mois.
		SELECT nom_client, prénom_client, date_début_location, date_fin_location
		FROM client JOIN location
				on client.no_client = location.no_client
		WHERE ADDDATE(date_début_location, INTERVAL 1 MONTH) <= date_fin_location;



-- 12.	Faire afficher la liste des clients ayant fait plus de deux locations.
		SELECT client.no_client, prénom_client, nom_client
		FROM client
		WHERE no_client IN (SELECT no_client
							FROM location 
							GROUP BY no_client
							HAVING COUNT(no_location) > 2);

-- 13.	Faire afficher le véhicule le plus populaire (constructeur, modèle, catégorie et le nombre de locations).
		SELECT auto.no_auto, COUNT(location.no_auto) AS nbLocations, auto.code_modèle, modèle.modèle,
							modèle.constructeur, modèle.catégorie
		FROM location INNER JOIN 
								(auto INNER JOIN modèle
											ON auto.code_modèle = modèle.`code_modèle`)
							ON location.no_auto = auto.no_auto
		GROUP BY auto.no_auto
		HAVING COUNT(*) >= ALL (SELECT COUNT(no_location)
								FROM location
								GROUP BY no_auto);

		-- Autre solution
		 SELECT constructeur, modèle, catégorie, COUNT(no_location) AS nombre_locations 
		 FROM modèle NATURAL JOIN (auto NATURAL JOIN location) 
		 GROUP BY no_auto ORDER BY nombre_locations DESC LIMIT 1
										
								
-- 14.	Faire afficher la liste de tous les véhicules loués (no_auto, modèle, constructeur) avec le total de kilomètres parcourus.
		SELECT auto.no_auto, modèle, constructeur, SUM(km_parcourus) AS kmParcourus
		FROM location INNER JOIN (auto INNER JOIN modèle 
									ON auto.code_modèle = modèle.code_modèle)
						ON location.no_auto = auto.no_auto
		GROUP BY auto.no_auto, modèle, constructeur;

-- 15.	Faire afficher la succursale qui possède les véhicules qui ont le plus roulé (nom succursale, véhicules et kilométrage). 
		
		-- Autre solution
		SELECT succursale.no_succursale, nom_succursale, SUM(km_parcourus) 
														AS totalKmParcourus
		FROM succursale INNER JOIN location ON succursale.no_succursale = location.no_succursale
		GROUP BY succursale.no_succursale
		ORDER BY SUM(km_parcourus) DESC
		LIMIT 1;

		-- Autre solution
		SELECT nom_succursale,no_auto,km_parcourus
        FROM succursale INNER JOIN location USING(no_succursale)
        WHERE no_succursale = (SELECT no_succursale
								FROM location
								GROUP BY no_succursale
								HAVING SUM(km_parcourus) >= ALL (SELECT SUM(km_parcourus)
																 FROM location
																 GROUP BY no_succursale))
		GROUP BY succursale.no_succursale;

		-- 15.	Faire afficher la succursale qui possède les véhicules qui ont le plus roulé (nom succursale, véhicules et kilométrage). 
		SELECT nom_succursale, GROUP_CONCAT(no_auto) AS NumérosDeVoitures, SUM(km_parcourus) AS NbMaxKilomètreParcourus
		FROM succursale INNER JOIN(location INNER JOIN auto USING(no_auto))
						USING(no_succursale)
		GROUP BY no_succursale
		HAVING NbMaxKilomètreParcourus = (SELECT MAX(MaxKilomètre)
										FROM (SELECT SUM(km_parcourus) AS MaxKilomètre
												FROM succursale INNER JOIN(location INNER JOIN auto USING(no_auto))
																USING(no_succursale)
												GROUP BY no_succursale) AS RechercheMaxKilomètre)
		
		
-- 16.	Faire afficher la liste détaillée de toutes les locations (les nom et prénom du client, le numéro de succursale, la catégorie et le modèle du véhicule) ordonnée par date de début de location.
		SELECT date_début_location, nom_client, prénom_client, no_succursale, catégorie, 	modèle
		FROM client  INNER JOIN location ON client.no_client = location.no_client
					 INNER JOIN auto ON location.no_auto = auto.no_auto
					 INNER JOIN modèle ON auto.code_modèle = modèle.code_modèle						
		ORDER BY date_début_location ;
		
		
-- 17.	Faire afficher le total des frais de location pour les véhicules hybrides et économiques.
		SELECT SUM(coût_location) AS totalFrais
		FROM location INNER JOIN (auto INNER JOIN modèle 
									ON auto.code_modèle = modèle.code_modèle)
						ON location.no_auto = auto.no_auto
		WHERE catégorie = 'Hybride' OR catégorie = 'Économique';
		
		
-- 18.	En utilisant une jointure, faire afficher les numéros de véhicules qui n’ont pas été loués. 

		SELECT auto.no_auto 
		FROM auto LEFT JOIN location ON auto.no_auto = location.no_auto
		WHERE location.no_auto IS NULL;
		
		
-- 19.	Faire afficher en ordre de numéro de client, le nom, le prénom et l’adresse complète des clients dont le total des frais de location dépasse 500 $. Fournir le résultat en format XML.
		SELECT no_client, nom_client, prénom_client, adresse_client, ville_client, province, code_postal
		FROM client 
		WHERE no_client IN (SELECT no_client 
							FROM location 
							GROUP BY no_client 
							HAVING SUM(coût_location) > 500);

		-- Autre solution : 
		SELECT no_client, nom_client, prénom_client, adresse_client, ville_client, province, code_postal
		FROM client INNER JOIN location ON client.no_client = location.no_client
		GROUP BY no_client
		HAVING SUM(location.coût_location) > 500;

							
							
-- 20.	Faire afficher en ordre de numéro d'auto, le kilométrage, l'état du véhicule, la catégorie, le modèle, le constructeur et l'année de construction des véhicules dont les frais de location dépassent 1 500$.
		SELECT location.no_auto, location.`coût_location`,km_au_compteur, état_général, 
			entretien_à_faire, catégorie, modèle.`modèle`, constructeur, année_construction
		FROM location INNER JOIN auto ON location.no_auto = auto.no_auto
                      INNER JOIN modèle ON auto.code_modèle = modèle.code_modèle
		GROUP BY location.no_auto
		HAVING SUM(coût_location) > 1500;

-- 21.	Faire afficher pour chaque client uniquement son nom de rue.
		SELECT CONCAT(nom_client, ", ", prénom_client) AS nom_complet, 
			MID(adresse_client, LOCATE(' ', adresse_client)) AS nom_rue
		FROM client;

		-- Pas parfait... manque Chemin à "chemin chamby"
		SELECT no_client, SUBSTRING_INDEX(adresse_client, " ", -1) as nom_rue_client FROM client;

							
-- 22.	Faire afficher les locations des clients qui ont loués un véhicule à Montréal.
		SELECT location.no_location, CONCAT(nom_client, ", ", prénom_client) AS nom_complet, succursale.ville_succursale
		FROM client INNER JOIN location ON client.no_client = location.no_client
					INNER JOIN succursale ON location.no_succursale = succursale.no_succursale
		WHERE succursale.ville_succursale = 'Montréal';	


-- 23.	Faire afficher la succursale la plus achalandée		

        -- ATTENTION AU HAVING MAX(...) sans comparateur

		SELECT no_succursale, nom_succursale, COUNT(no_location) AS nombre_locations
		FROM location INNER JOIN succursale USING(no_succursale)
		GROUP BY no_succursale
		HAVING nombre_locations >= ALL (SELECT COUNT(no_location) FROM location GROUP BY no_succursale);

		-- Autre solution
		SELECT nom_succursale, COUNT(no_location) AS nombre_locations 
		FROM succursale NATURAL JOIN location GROUP BY nom_succursale ORDER BY nombre_locations DESC LIMIT 1


-- 24.	Faire afficher les clients dont le code postal se termine par 2N6.

		SELECT nom_client, prénom_client, code_postal
		FROM client
		WHERE code_postal LIKE '%2N6';
		
		SELECT nom_client, prénom_client, code_postal
		FROM client
		WHERE RIGHT(code_postal, 3) = '2N6';

		

-- 25.	Faire afficher les clients qui ont loués le véhicule qui a le moins roulé.
		SELECT client.no_client, nom_client, prénom_client
		FROM client INNER JOIN location ON client.no_client = location.no_client
		WHERE no_auto IN (SELECT location.no_auto 
						  FROM location INNER JOIN auto ON location.no_auto = auto.no_auto 
						  GROUP BY location.no_auto
						  HAVING SUM(km_parcourus) <= ALL (SELECT SUM(km_parcourus) 
						  								   FROM location 
														   GROUP BY no_auto));


		-- Basé sur le kilométrage
		SELECT client.no_client, nom_client, prénom_client
		FROM client INNER JOIN location ON client.no_client = location.no_client
				    INNER JOIN auto ON location.no_auto = auto.no_auto
		WHERE auto.km_au_compteur = (SELECT MIN(auto.km_au_compteur) FROM auto);

		-- AVEC LIMIT
		SELECT CONCAT(prénom_client, " ", nom_client) AS client 
		FROM client NATURAL JOIN location WHERE no_auto = (SELECT no_auto FROM location 
		GROUP BY no_auto ORDER BY SUM(km_parcourus) ASC LIMIT 1)
