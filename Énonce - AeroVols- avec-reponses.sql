--
-- Nom 1 :Cuellar Alberto
-- Nom 2 :Gonzalez Yuriel
--




-- B.	INSERTION DE DONNÉES


-- 1.	Ajouter 2 nouveaux clients à l’aide de requêtes INSERT (avec vos coordonnées personnelles).
		
		INSERT INTO client_pilote (no_client_pilote, prénom, nom, adresse, ville, province, code_postal, téléphone, date_exp_médical, type_licence, heures_vol_jour, heures_vol_nuit)
		VALUES ('26','Alberto','Cuellar','102 Bruto','Longueuil','QC','J2R1B2','5145161829','2021-01-03','pilote commercial','2','1'); 

		INSERT INTO client_pilote (no_client_pilote, prénom, nom, adresse, ville, province, code_postal, téléphone, date_exp_médical, type_licence, heures_vol_jour, heures_vol_nuit)
		VALUES ('27','Yuriel','Gonzalez','1 Davidson','Saint-Hubert','QC','J2R1B2','5145613213','2021-02-01','pilote privé','4',NULL); 
		


-- 2.	Ajouter 3 nouvelles locations (vos locations) en fonctions des données existantes des 
--      autres tables (à l’aide de requêtes INSERT).
     	
	INSERT INTO location_vol (	no_location_vol, date_début_location, date_fin_location, heures_vol, type_vol, période_jour, coût_location, no_client pilote
	, no_immatriculation)

	VALUES (34, '2020-04-05','2020-04-05',2,'local','Jour',350.55,26,'ALPHA')	
			,(35, '2020-04-24','2020-04-24',1,'local','Nuit',150,26,'HUIYT')
			,(36, '2020-05-10','2020-05-10',4,'voyage','Jour',874,27,'POKJI');
			
			
-- C.	REQUÈTES


--		Pour chaque question ci-dessous, vous devez :
--		-	trouver et écrire l'énoncé SQL dans votre script (sous la question en commentaire);
--		-	tester votre énoncé avec MySQL;

--		Pour chaque requéte qui affiche une colonne calculée, renommer cette colonne par un nom significatif.


-- 1.	Faire afficher en ordre croissant d'heures, la liste des avions (immatriculation, heures) en 
--      service avec plus de 880 heures de vol.

	SELECT no_immatriculation, heures
	FROM avion
	WHERE heures >=880
	AND en_service = 1
	ORDER BY heures ASC;
	
-- 2.	Faire afficher la durée moyenne (en nombre d'heures) d'une location.

	SELECT ROUND(AVG(heures_vol),2) AS durée_moyenne_heures_location
	FROM location_vol;
	

-- 3.	Faire afficher le nombre d’avions qui étaient en location le 1er mars 2017.

	SELECT *
	FROM location_vol
	WHERE `date_début_location`<='2017-03-01' AND `date_fin_location`>='2017-03-01';
		

-- 4.	Faire afficher le nombre de locations de chaque client (afficher le numéro de client, son nom 
--      et le nombre de locations).
	
	SELECT L.`no_client pilote`, MAX(`nom`) AS nom ,COUNT(*) AS nombre_locations
	FROM location_vol L
	INNER JOIN client_pilote P ON L.`no_client pilote` = P.`no_client_pilote`
	GROUP BY `no_client pilote`
	ORDER BY nombre_locations DESC, nom;


-- 5.	Faire afficher la liste des avions (constructeur, modèle, heures au compteur et immatriculation) 
--      ordonnée par constructeur, modèle, heures au compteur en ordre croissant.
	
	SELECT c.no_constructeur, m.no_modèle ,a.heures, a.no_immatriculation
	FROM avion a 
	INNER JOIN `modèle` m ON a.`no_modèle` = m.`no_modèle`
	INNER JOIN constructeur c ON m.`no_constructeur`= c.no_constructeur
	ORDER BY c.no_constructeur, m.no_modèle, a.heures;

-- 6.	Faire afficher la liste des clients (nom et prénom) qui ont au moins une location en date du 9  
--      septembre 2016.

	SELECT L.no_location_vol, L.`no_client pilote`, CONCAT(MAX(nom),' ', MAX(prénom)) AS nom_prénom, `date_début_location`
	FROM location_vol L
	INNER JOIN client_pilote P ON L.`no_client pilote` = P.`no_client_pilote`
	WHERE `date_début_location`='2016-09-09' 
	GROUP BY L.no_location_vol;

	
-- 7.	Faire afficher le nombre de clients ayant fait plus d’une location.

	SELECT COUNT(*) AS nombre_clients_avec_plus_une_location
	FROM
			(	SELECT `no_client pilote`
				FROM location_vol
				GROUP BY `no_client pilote`
				HAVING COUNT(*) > 1 
	       ) a;	
	

-- 8.	Faire afficher la liste des clients qui ont une licence de pilotage valide. La licence est invalide
--      lorsque la date d’expiration de l’examen médical est atteinte.

	SELECT *
	FROM client_pilote
	WHERE `date_exp_médical` > CURRENT_DATE; 
	
	
-- 9.	Faire afficher le modèle d'avion le plus loué (afficher le constructeur, le modèle et le nombre de 
--      locations).

   -- option 1.
   
	SELECT A.no_modèle, A.no_constructeur, A.nombre_de_locations
	FROM
		(
			SELECT m.no_modèle
			,c.no_constructeur	  
			,COUNT(l.no_location_vol) AS nombre_de_locations
			,RANK() OVER (ORDER BY COUNT(l.no_location_vol) DESC) AS RANKING
			FROM `modèle`m
			INNER JOIN  avion a  ON a.`no_modèle` = m.`no_modèle`
			INNER JOIN location_vol l ON a.`no_immatriculation` = l.`no_immatriculation`
			INNER JOIN constructeur c ON m.`no_constructeur`= c.no_constructeur
			GROUP BY m.no_modèle, c.no_constructeur
			ORDER BY RANKING
		) A
	WHERE RANKING = 1;
	
	
	-- option 2.
	
		SELECT m.no_modèle, c.no_constructeur, COUNT(l.no_location_vol) AS nombre_de_locations
		FROM `modèle`m
			INNER JOIN  avion a  ON a.`no_modèle` = m.`no_modèle`
			INNER JOIN location_vol l ON a.`no_immatriculation` = l.`no_immatriculation`
			INNER JOIN constructeur c ON m.`no_constructeur`= c.no_constructeur
		GROUP BY m.no_modèle, c.no_constructeur
		HAVING nombre_de_locations = (
												SELECT COUNT(l.no_location_vol) AS nombre_de_locations
												FROM avion a 
												INNER JOIN location_vol l ON a.`no_immatriculation` = l.`no_immatriculation`
												GROUP BY a.no_modèle
												ORDER BY nombre_de_locations  DESC
												LIMIT 1
												);
	
-- 10.	Faire afficher la liste des avions loués (no_immatriculation, modèle, constructeur) avec leur nombre
--      d'heures de vol.

		SELECT a.no_immatriculation, m.`modèle_avion`, c.nom_constructeur, ROUND(sum(l.heures_vol),2) nombre_total_heures_de_vol_loués
		FROM avion a
			INNER JOIN location_vol l ON l.no_immatriculation = a.no_immatriculation
			INNER JOIN modèle m ON m.`no_modèle`= a.`no_modèle`
			INNER JOIN constructeur c ON m.`no_constructeur`= c.no_constructeur
		GROUP BY l.no_immatriculation;
		  
-- 11.	Faire afficher la liste des aérogares qui contiennent les avions les plus loués.
		
		SELECT  a.`no_aérogare`, AE.`nom_aérogare`, AE.`ville_aérogare`
		FROM location_vol l
		INNER JOIN  avion a  USING(no_immatriculation)
		INNER JOIN  `aérogare` AE  USING(`no_aérogare`)		
		GROUP BY l.no_immatriculation
		HAVING COUNT(l.no_location_vol) >= (	SELECT  COUNT(l.no_location_vol) AS Qty 
															FROM location_vol l
															GROUP BY no_immatriculation
															ORDER BY Qty DESC
															LIMIT 1
													);
	

-- 12.	Faire afficher la liste détaillée des locations, avec la date de début de location 
--      (par ordre chronologique), les nom et prénom du client, le numéro d'aérogare, les caractéristiques de 
--      l'appareil (roues rétractables, GPS, pressurisé, ifr, flotteur, année), le modèle, le type de moteur et 
--      le constructeur.
			
		SELECT  l.no_location_vol,l.`date_début_location`
		, CONCAT(CP.nom,' ',CP.`prénom`)
		,a.`no_aérogare`
		,CASE WHEN a.`roues_rétractables`=1 THEN 'Yes' ELSE 'No' END AS Caract_roues_rétractables
		,CASE WHEN a.`gps`=1 THEN 'Yes' ELSE 'No' END AS Caract_gps
		,CASE WHEN a.`pressurisé`=1 THEN 'Yes' ELSE 'No' END AS `Caract_pressurisé`
		,CASE WHEN a.ifr=1 THEN 'Yes' ELSE 'No' END AS Caract_ifr
		,CASE WHEN a.`flotteurs`=1 THEN 'Yes' ELSE 'No' END AS `Caract_flotteurs`
		,`année` AS `Caract_année`
		, m.`modèle_avion`
		,m.type_moteur
		,C.nom_constructeur
		FROM location_vol l
		INNER JOIN  avion a  USING(no_immatriculation)
		INNER JOIN  `aérogare` AE   USING(`no_aérogare`)			
		INNER JOIN  client_pilote CP ON l.`no_client pilote`= CP.no_client_pilote
		INNER JOIN `modèle` m USING(`no_modèle`)
		INNER JOIN constructeur C ON m.no_constructeur = C.no_constructeur
		ORDER BY l.`date_début_location`
		;
		
		
		
-- 13.	Faire afficher le total des frais de locations pour les CESSNA 172.
			
	
		SELECT m.`no_modèle`, c.no_constructeur, c.nom_constructeur, ROUND(SUM(`coût_location`),2) AS Total_Frais
		FROM `modèle` m
							INNER JOIN constructeur c ON m.no_constructeur = c.no_constructeur
							INNER JOIN  avion a ON m.`no_modèle` = a.`no_modèle`
							INNER JOIN  location_vol l ON a.no_immatriculation =l.no_immatriculation
		WHERE modèle_avion = '172' 
		AND nom_constructeur = 'CESSNA'
		GROUP BY m.`no_modèle`
		;
		

-- 14.	Faire afficher toutes les informations des pilotes demeurant sur la rue Dupuis.
			
			SELECT *
			FROM client_pilote
			WHERE adresse LIKE '%Dupuis%';

-- 15.	Faire afficher l'immatriculation, le modèle, l’année, les caractéristiques, 
--      le type de moteur et le constructeur des avions dont les frais de location dépassent 1 000 $.


		SELECT  a.no_immatriculation
		, m.`modèle_avion`
		,`année` AS `Caract_année`
		,CASE WHEN a.`roues_rétractables`=1 THEN 'Yes' ELSE 'No' END AS Caract_roues_rétractables
		,CASE WHEN a.`gps`=1 THEN 'Yes' ELSE 'No' END AS Caract_gps
		,CASE WHEN a.`pressurisé`=1 THEN 'Yes' ELSE 'No' END AS `Caract_pressurisé`
		,CASE WHEN a.ifr=1 THEN 'Yes' ELSE 'No' END AS Caract_ifr
		,CASE WHEN a.`flotteurs`=1 THEN 'Yes' ELSE 'No' END AS `Caract_flotteurs`
		,m.type_moteur
		,C.nom_constructeur
		FROM avion a
		INNER JOIN `modèle` m ON a.`no_modèle` = m.`no_modèle`
		INNER JOIN constructeur C ON m.no_constructeur = C.no_constructeur
		
		WHERE a.no_immatriculation IN (	SELECT no_immatriculation
													FROM location_vol l
													GROUP BY  no_immatriculation
													HAVING 	ROUND(SUM(`coût_location`),2)> 1000
													);
		

-- D.	MISES À JOUR

-- 		Trouver et écrire les énoncés SQL permettant d'effectuer les opérations suivantes :


-- 16.	On veut supprimer les avions qui n'ont jamais été louées.
      
--      DELETE a
      DELETE a
		FROM avion a
		LEFT JOIN  location_vol l ON a.no_immatriculation = l.no_immatriculation
		WHERE l.no_immatriculation IS NULL;
		
--      DELETE a		
		SELECT *
		FROM avion a
		WHERE a.no_immatriculation NOT IN ( SELECT no_immatriculation FROM location_vol)
 
--      DELETE a 
 		SELECT *
		FROM avion a
		WHERE NOT EXISTS ( SELECT * FROM location_vol l WHERE a.no_immatriculation =l.no_immatriculation)
     

-- 17.  Les avions avec plus de 2 000 heures de vol dont les roues sont rétractables doivent passer une inspection. 
-- 	  Par conséquent, ils doivent être mis hors service de façon temporaire. Modifier le contenu de la colonne en_service.

	UPDATE  avion a
	SET en_service = 0
 	WHERE `roues_rétractables` = 1 AND `heures` > 2000;
 	
 

-- E.	NORMALISATION

--  	Nous ne sommes pas satisfaits de la structure de la table modèle. Il faut réorganiser cela.

--  	Avec Workbench ou HeidiSQL, créez la table type_moteur, formée des colonnes no_type_moteur et type_moteur.

		CREATE TABLE type_moteur
		(
			`no_type_moteur` INT(11) NOT NULL,
			`type_moteur` VARCHAR(255) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
			PRIMARY KEY (`no_type_moteur`) USING BTREE
		)
		COLLATE='utf8_unicode_ci'
		ENGINE=InnoDB
		;


-- 18.	Quel est l'ordre SQL permettant de copier les différents types moteurs de la table modèle vers la 
--      nouvelle table ? Exécutez cette requête.

		INSERT INTO type_moteur
		SELECT ROW_NUMBER() OVER (ORDER BY `type_moteur`), `type_moteur`  
		FROM `modèle`
		GROUP BY `type_moteur`;


-- 19.	Quels changements devons-nous maintenant faire dans la table modèle?

	-- 1. Créer une clé étrangère dans la table "modèle" pour la relier à la table "constructeur"
	
		ALTER TABLE `modèle`
		ADD CONSTRAINT `no_constructeur` FOREIGN KEY (`no_constructeur`) REFERENCES `constructeur` (`no_constructeur`);

	-- 2. Créer une nouvelle colonne: "no_type_moteur" dans la table "modèle".

		ALTER TABLE `modèle` ADD COLUMN `no_type_moteur` INT(11) NOT NULL;
		
		-- 2.1 Valeur "no_type_moteur" de la colonne à Null 
		
		ALTER TABLE `modèle`
		CHANGE COLUMN `no_type_moteur` `no_type_moteur` INT(11) NULL DEFAULT NULL AFTER `no_constructeur`;

	-- 3 Remplir la colonne: "modèle.no_type_moteur" avec leurs valeurs correspondants
		
		UPDATE `modèle` mt
		INNER JOIN type_moteur tm ON  mt.type_moteur = tm.type_moteur
		SET mt.`no_type_moteur` = tm.no_type_moteur;

   -- 4 Supprimer la colonne: "modèle.type_moteur"
    	
    	ALTER TABLE `modèle` DROP COLUMN type_moteur;
    	
	-- 5 Créer une autre clé étrangère dans la table "modèle" pour la relier à la nouvelle table "type_moteur"

		ALTER TABLE `modèle`
		ADD CONSTRAINT `no_type_moteur` FOREIGN KEY (`no_type_moteur`) REFERENCES `type_moteur` (`no_type_moteur`);


-- 20. 	Quel est l'avantage d'avoir décomposé la table modèle?
   	
	-- L'avantage d'avoir décomposé la table "modèle" est qu'il y aura moins de données redondantes et moins d'endroits 
	-- à mettre à jour au cas où nous aurions besoin de changer de type de moteur.
   
   
-- 21.  Reprendre la question 15 et adaptez-la à la nouvelle structure de la BD. Quelle serait la réponse?

	-- Faire afficher l'immatriculation, le modèle, l’année, les caractéristiques, 
--      le type de moteur et le constructeur des avions dont les frais de location dépassent 1 000 $.

		SELECT  a.no_immatriculation
				, m.`modèle_avion`
				,`année` AS `Caract_année`
				,CASE WHEN a.`roues_rétractables`=1 THEN 'Yes' ELSE 'No' END AS Caract_roues_rétractables
				,CASE WHEN a.`gps`=1 THEN 'Yes' ELSE 'No' END AS Caract_gps
				,CASE WHEN a.`pressurisé`=1 THEN 'Yes' ELSE 'No' END AS `Caract_pressurisé`
				,CASE WHEN a.ifr=1 THEN 'Yes' ELSE 'No' END AS Caract_ifr
				,CASE WHEN a.`flotteurs`=1 THEN 'Yes' ELSE 'No' END AS `Caract_flotteurs`
				,tm.type_moteur
				,c.nom_constructeur
		FROM avion a INNER JOIN `modèle` m USING(`no_modèle`)
						 INNER JOIN type_moteur tm USING(`no_type_moteur`)
						 INNER JOIN constructeur c USING(no_constructeur) 
		
		WHERE a.no_immatriculation IN (	SELECT no_immatriculation
													FROM location_vol l
													GROUP BY  no_immatriculation
													HAVING SUM(coût_location) > 1000
													);
		
-- 22.	Le monde de l'aviation subit des changements importants. Maintenant, il arrive qu'un modèle soit 
--      fabriqué par plusieurs constructeurs et nous voulons que notre schéma supporte cette possibilité. 
--      Quelle dépendance fonctionnelle cause maintenant un problème de normalisation et à quel niveau de 
--      normalisation (1,2 ou 3)?

--    Reponse:
--    Avec ce changement, le tableau "modèle" passerait au niveau de normalisation 1 (1FN). Car un problème de dépendance 
--    fonctionnelle est créé entre les colonnes: "modèle_avion" et "no_constructeur" de cette table.


-- 23. 	Créer une table "construction" possédant une clé primaire double. Quelles sont les étapes et 
--      requêtes SQL nécessaires pour modifier votre schéma et les données pour supporter cette nouvelle 
--      dépendance fonctionnelle.

-- 1. 

		CREATE TABLE `construction` (
			`no_modèle` INT(11) NOT NULL,
			`no_constructeur` INT(11) NOT NULL,
			PRIMARY KEY (`no_modèle`, `no_constructeur`) USING BTREE,
			INDEX `fk_construction1_idx` (`no_modèle`) USING BTREE,
			INDEX `fk_construction2_idx` (`no_constructeur`) USING BTREE,
			CONSTRAINT `fk_no_modèle` FOREIGN KEY (`no_modèle`) REFERENCES `aérovols`.`modèle` (`no_modèle`) ON UPDATE NO ACTION ON DELETE NO ACTION,
			CONSTRAINT `fk_no_constructeur` FOREIGN KEY (`no_constructeur`) REFERENCES `aérovols`.`constructeur` (`no_constructeur`) ON UPDATE NO ACTION ON DELETE NO ACTION
		)
		COLLATE='utf8_general_ci'
		ENGINE=InnoDB
		;

-- 2. 

		INSERT INTO construction
			SELECT m.`no_modèle`, m.no_constructeur
			FROM MODèle m;

-- 3.

		ALTER TABLE `modèle`
			DROP FOREIGN KEY `no_constructeur`; 
		
		ALTER TABLE `modèle`
			DROP COLUMN `no_constructeur`;
	
	
-- F.	SCHÉMA


--  	Créer le schéma de la BD à l’aide de Workbench et remettre le fichier.

-- MySQL Script generated by MySQL Workbench
-- Sat Jun 27 16:25:18 2020
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema TP2_Nouveau_schéma_Aérovols
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema TP2_Nouveau_schéma_Aérovols
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `TP2_Nouveau_schéma_Aérovols` DEFAULT CHARACTER SET utf8 ;
USE `TP2_Nouveau_schéma_Aérovols` ;

-- -----------------------------------------------------
-- Table `TP2_Nouveau_schéma_Aérovols`.`client_pilote`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `TP2_Nouveau_schéma_Aérovols`.`client_pilote` (
  `no_client_pilote` INT NOT NULL,
  `prenom` VARCHAR(45) NULL,
  `nom` VARCHAR(45) NULL,
  `client_pilote` VARCHAR(45) NULL,
  `adresse` VARCHAR(45) NULL,
  `ville` VARCHAR(45) NULL,
  `province` VARCHAR(45) NULL,
  `code_postal` VARCHAR(45) NULL,
  `téléphone` INT NULL,
  `date_exp_médical` DATETIME NULL,
  `type_licence` VARCHAR(45) NULL,
  `heures_vol_jour` FLOAT NULL,
  `heures_vol_nuit` VARCHAR(45) NULL,
  PRIMARY KEY (`no_client_pilote`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `TP2_Nouveau_schéma_Aérovols`.`type_moteur`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `TP2_Nouveau_schéma_Aérovols`.`type_moteur` (
  `no_type_moteur` SMALLINT(6) NOT NULL,
  `type_moteur` VARCHAR(45) NULL,
  PRIMARY KEY (`no_type_moteur`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `TP2_Nouveau_schéma_Aérovols`.`modèle`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `TP2_Nouveau_schéma_Aérovols`.`modèle` (
  `no_modèle` INT(11) NOT NULL,
  `modèle_avion` VARCHAR(15) NULL,
  `année_conception` SMALLINT(6) NULL,
  `no_type_moteur` SMALLINT(6) NOT NULL,
  PRIMARY KEY (`no_modèle`),
  INDEX `fk_modèle_type_moteur1_idx` (`no_type_moteur` ASC) VISIBLE,
  CONSTRAINT `fk_modèle_type_moteur1`
    FOREIGN KEY (`no_type_moteur`)
    REFERENCES `TP2_Nouveau_schéma_Aérovols`.`type_moteur` (`no_type_moteur`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `TP2_Nouveau_schéma_Aérovols`.`aérogare`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `TP2_Nouveau_schéma_Aérovols`.`aérogare` (
  `no_aérogare` INT NOT NULL,
  `nom_aérogare` VARCHAR(30) NULL,
  `ville_aérogare` VARCHAR(30) NULL,
  `téléphone` VARCHAR(15) NULL,
  `type_service` INT(11) NULL,
  `responsable` VARCHAR(30) NULL,
  PRIMARY KEY (`no_aérogare`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `TP2_Nouveau_schéma_Aérovols`.`avion`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `TP2_Nouveau_schéma_Aérovols`.`avion` (
  `no_immatriculation` VARCHAR(5) NOT NULL,
  `en_service` BIT NULL,
  `heures` INT NULL,
  `roues_rétractables` BIT NULL,
  `gps` BIT NULL,
  `pressurisé` BIT NULL,
  `ifr` BIT NULL,
  `flotteurs` BIT NULL,
  `année` SMALLINT(6) NULL,
  `modèle_no_modèle` INT(11) NOT NULL,
  `no_aérogare` INT(11) NOT NULL,
  PRIMARY KEY (`no_immatriculation`),
  INDEX `fk_avion_modèle1_idx` (`modèle_no_modèle` ASC) VISIBLE,
  INDEX `fk_avion_aérogare1_idx` (`no_aérogare` ASC) VISIBLE,
  CONSTRAINT `fk_avion_modèle1`
    FOREIGN KEY (`modèle_no_modèle`)
    REFERENCES `TP2_Nouveau_schéma_Aérovols`.`modèle` (`no_modèle`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_avion_aérogare1`
    FOREIGN KEY (`no_aérogare`)
    REFERENCES `TP2_Nouveau_schéma_Aérovols`.`aérogare` (`no_aérogare`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `TP2_Nouveau_schéma_Aérovols`.`location_vol`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `TP2_Nouveau_schéma_Aérovols`.`location_vol` (
  `no_location_vol` INT NOT NULL,
  `date_début_location` DATETIME NULL,
  `date_fin_location` DATETIME NULL,
  `heures_vol` FLOAT NULL,
  `type_vol` VARCHAR(15) NULL,
  `période_jour` VARCHAR(10) NULL,
  `coût_location` DOUBLE NULL,
  `no_client_pilote` INT NOT NULL,
  `no_immatriculation` VARCHAR(5) NOT NULL,
  PRIMARY KEY (`no_location_vol`),
  INDEX `fk_location_vol_client_pilote_idx` (`no_client_pilote` ASC) VISIBLE,
  INDEX `fk_location_vol_avion1_idx` (`no_immatriculation` ASC) VISIBLE,
  CONSTRAINT `fk_location_vol_client_pilote`
    FOREIGN KEY (`no_client_pilote`)
    REFERENCES `TP2_Nouveau_schéma_Aérovols`.`client_pilote` (`no_client_pilote`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_location_vol_avion1`
    FOREIGN KEY (`no_immatriculation`)
    REFERENCES `TP2_Nouveau_schéma_Aérovols`.`avion` (`no_immatriculation`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `TP2_Nouveau_schéma_Aérovols`.`constructeur`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `TP2_Nouveau_schéma_Aérovols`.`constructeur` (
  `no_constructeur` INT NOT NULL,
  `nom_constructeur` VARCHAR(45) NULL,
  `lieu_fabrication` VARCHAR(45) NULL,
  PRIMARY KEY (`no_constructeur`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `TP2_Nouveau_schéma_Aérovols`.`construction`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `TP2_Nouveau_schéma_Aérovols`.`construction` (
  `no_modèle` INT(11) NOT NULL,
  `no_constructeur` INT(11) NOT NULL,
  PRIMARY KEY (`no_modèle`, `no_constructeur`),
  INDEX `fk_modèle_has_constructeur_constructeur1_idx` (`no_constructeur` ASC) VISIBLE,
  INDEX `fk_modèle_has_constructeur_modèle1_idx` (`no_modèle` ASC) VISIBLE,
  CONSTRAINT `fk_modèle_has_constructeur_modèle1`
    FOREIGN KEY (`no_modèle`)
    REFERENCES `TP2_Nouveau_schéma_Aérovols`.`modèle` (`no_modèle`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_modèle_has_constructeur_constructeur1`
    FOREIGN KEY (`no_constructeur`)
    REFERENCES `TP2_Nouveau_schéma_Aérovols`.`constructeur` (`no_constructeur`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

