-- --------------------------------------------------------
-- Hôte :                        127.0.0.1
-- Version du serveur:           5.6.15-log - MySQL Community Server (GPL)
-- SE du serveur:                Win32
-- HeidiSQL Version:             9.3.0.4984
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Export de la structure de la base pour aérovols
CREATE DATABASE IF NOT EXISTS `aérovols` /*!40100 DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci */;
USE `aérovols`;


-- Export de la structure de table aérovols. avion
CREATE TABLE IF NOT EXISTS `avion` (
  `no_immatriculation` varchar(5) COLLATE utf8_unicode_ci NOT NULL,
  `en_service` bit(1) DEFAULT NULL,
  `heures` int(11) DEFAULT NULL,
  `roues_rétractables` bit(1) DEFAULT NULL,
  `gps` bit(1) DEFAULT NULL,
  `pressurisé` bit(1) DEFAULT NULL,
  `ifr` bit(1) DEFAULT NULL,
  `flotteurs` bit(1) DEFAULT NULL,
  `année` smallint(6) DEFAULT NULL,
  `no_modèle` int(11) DEFAULT NULL,
  `no_aérogare` int(11) DEFAULT NULL,
  PRIMARY KEY (`no_immatriculation`),
  KEY `no_modèle` (`no_modèle`),
  KEY `no_aérogare` (`no_aérogare`),
  CONSTRAINT `no_modèle` FOREIGN KEY (`no_modèle`) REFERENCES `modèle` (`no_modèle`),
  CONSTRAINT `no_aérogare` FOREIGN KEY (`no_aérogare`) REFERENCES `aérogare` (`no_aérogare`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Export de données de la table aérovols.avion : ~19 rows (environ)
DELETE FROM `avion`;
/*!40000 ALTER TABLE `avion` DISABLE KEYS */;
INSERT INTO `avion` (`no_immatriculation`, `en_service`, `heures`, `roues_rétractables`, `gps`, `pressurisé`, `ifr`, `flotteurs`, `année`, `no_modèle`, `no_aérogare`) VALUES
	('ALPHA', b'1', 1562, b'1', b'1', b'1', b'1', b'1', 1970, 79, 7),
	('APDSQ', b'1', 324, b'1', b'1', b'1', b'1', b'1', 1985, 38, 5),
	('ATYTE', b'1', 643, b'0', b'1', b'0', b'1', b'0', 1993, 71, 9),
	('BOSIL', b'0', 853, b'0', b'0', b'1', b'1', b'0', 1969, 56, 5),
	('DAOEA', b'1', 1394, b'0', b'0', b'0', b'1', b'0', 1966, 47, 4),
	('FRGEO', b'1', 514, b'1', b'1', b'0', b'1', b'0', 1972, 58, 2),
	('GOLIE', b'0', 1258, b'0', b'1', b'0', b'1', b'0', 1962, 50, 1),
	('HUIYT', b'0', 2573, b'0', b'0', b'0', b'0', b'0', 1943, 32, 5),
	('JFOEW', b'1', 2356, b'1', b'0', b'0', b'0', b'1', 1958, 76, 10),
	('JILOF', b'1', 150, b'1', b'1', b'0', b'1', b'0', 1975, 34, 7),
	('JOTLY', b'1', 1598, b'0', b'0', b'0', b'1', b'0', 1956, 60, 9),
	('KJDPI', b'1', 3874, b'1', b'0', b'0', b'0', b'0', 1956, 90, 6),
	('KOTLP', b'1', 560, b'1', b'0', b'1', b'1', b'0', 1967, 1, 1),
	('LOHER', b'1', 1257, b'1', b'1', b'0', b'0', b'0', 1972, 1, 1),
	('OPSWV', b'0', 843, b'0', b'1', b'1', b'0', b'1', 1964, 1, 8),
	('OPYDA', b'1', 942, b'0', b'0', b'0', b'0', b'0', 1954, 48, 8),
	('POKJI', b'1', 1512, b'1', b'1', b'0', b'0', b'1', 1958, 56, 3),
	('POPIR', b'1', 1257, b'1', b'1', b'1', b'1', b'0', 2001, 66, 9),
	('PORWE', b'0', 4597, b'0', b'0', b'0', b'0', b'0', 1956, 54, 6);
/*!40000 ALTER TABLE `avion` ENABLE KEYS */;


-- Export de la structure de table aérovols. aérogare
CREATE TABLE IF NOT EXISTS `aérogare` (
  `no_aérogare` int(11) NOT NULL,
  `nom_aérogare` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ville_aérogare` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `téléphone` varchar(15) COLLATE utf8_unicode_ci DEFAULT NULL,
  `type_service` int(11) DEFAULT NULL,
  `responsable` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`no_aérogare`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Export de données de la table aérovols.aérogare : ~10 rows (environ)
DELETE FROM `aérogare`;
/*!40000 ALTER TABLE `aérogare` DISABLE KEYS */;
INSERT INTO `aérogare` (`no_aérogare`, `nom_aérogare`, `ville_aérogare`, `téléphone`, `type_service`, `responsable`) VALUES
	(1, 'Air Richelieu', 'St-Hubert', '(450) 134-1234', 1, 'Richard Blackburn'),
	(2, 'AéroPro', 'Sherbrooke', '(819) 175-6983', 1, 'Yvon Melançon'),
	(3, 'Cargair', 'Mascouche', '(514) 702-6611', 2, 'Lucie Isabelle'),
	(4, 'Sky Service', 'Montréal', '(514) 633-3223', 2, 'Simon Lamontagne'),
	(5, 'PasseportAvion', 'Beloeil', '(450) 589-9445', 1, 'Pierre-Luc Champagne'),
	(6, 'CPAC', 'St-Jean', '(450) 346-4592', 2, 'Julien Cousineau'),
	(7, 'La Macasa', 'La Macasa', '(819) 425-9494', 1, 'Sylvie Poulin'),
	(8, 'Exact Air', 'St-Honoré', '(418) 673-3522', 1, 'François Couture'),
	(9, 'Trans-Sol', 'Québec', '(418) 640-2663', 2, 'Carl Tremblay'),
	(10, 'Air Saguenay', 'Bagotville', '(418) 677-7342', 2, 'Éric Trudel');
/*!40000 ALTER TABLE `aérogare` ENABLE KEYS */;


-- Export de la structure de table aérovols. client_pilote
CREATE TABLE IF NOT EXISTS `client_pilote` (
  `no_client_pilote` int(11) NOT NULL,
  `prénom` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `nom` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `adresse` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ville` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `province` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `code_postal` varchar(7) COLLATE utf8_unicode_ci DEFAULT NULL,
  `téléphone` varchar(12) COLLATE utf8_unicode_ci DEFAULT NULL,
  `date_exp_médical` datetime DEFAULT NULL,
  `type_licence` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `heures_vol_jour` float DEFAULT NULL,
  `heures_vol_nuit` float DEFAULT NULL,
  PRIMARY KEY (`no_client_pilote`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Export de données de la table aérovols.client_pilote : ~18 rows (environ)
DELETE FROM `client_pilote`;
/*!40000 ALTER TABLE `client_pilote` DISABLE KEYS */;
INSERT INTO `client_pilote` (`no_client_pilote`, `prénom`, `nom`, `adresse`, `ville`, `province`, `code_postal`, `téléphone`, `date_exp_médical`, `type_licence`, `heures_vol_jour`, `heures_vol_nuit`) VALUES
	(7, 'Rachel', 'Bacon', '9 St-Urbain', 'Montréal', 'QC', 'H2X 2N6', '5144567897', '2019-02-04 00:00:00', 'pilote commercial', NULL, 3.12),
	(9, 'David', 'Dion', '10 Chemin Chambly', 'Longueuil', 'QC', 'J2R 1B2', '4502559458', '2018-12-05 00:00:00', 'pilote loisir', NULL, 3.6),
	(10, 'Jennifer', 'Lena', '400 Bélanger', 'St-Léonard', 'QC', 'H1W 9T5', '4508743483', '2018-10-23 00:00:00', 'pilote privé', 4.3, NULL),
	(11, 'Émilie', 'Dupuis', '500 Joliette', 'Longueuil', 'QC', 'J2R 1B2', '5147895445', '2018-09-18 00:00:00', 'élève pilote', 18.9, NULL),
	(12, 'Michel', 'Lebrun', '600 St-Laurent', 'Montréal', 'QC', 'H2X 2N6', '5147946874', '2017-05-24 00:00:00', 'élève solo', 15, 4.6),
	(13, 'Douglas', 'Scott', '12545 Dupuis', 'Montréal', 'QC', 'H2X 2N6', '5145567811', '2018-11-29 00:00:00', 'élève solo', 1.95, NULL),
	(14, 'Lisa', 'Andrews', '12546 Dupuis', 'Montréal', 'QC', 'H2X 2N6', '5148756452', '2019-01-02 00:00:00', 'pilote vol nuit', NULL, 3.04),
	(15, 'Antoine', 'Vaudrin', '606 St-Zotique', 'St-Léonard', 'QC', 'H1W 9T5', '5147823341', '2018-04-25 00:00:00', 'pilote commercial', NULL, 0.7),
	(16, 'Aaron', 'Douglas', '987 Provenche', 'St-Léonard', 'QC', 'H1W 9T5', '5147122455', '2018-07-25 00:00:00', 'pilote loisir', 1.3, 2.5),
	(17, 'Kristen', 'Reis', '2345 Ashley', 'Laval', 'QC', 'L5G 4F5', '4502327789', '2017-10-10 00:00:00', 'élève pilote', 15.4, 4.6),
	(18, 'Thomas', 'Leblanc', '9876 Desbois', 'Sherbrooke', 'QC', 'L5G 4F5', '8195681451', '2019-01-23 00:00:00', 'élève pilote', 0.45, 2.6),
	(19, 'Dave', 'Thomas', '444 Alouette', 'Laval', 'QC', 'L5G 4F5', '4503698694', '2018-10-24 00:00:00', 'pilote vol nuit', 2, 0.6),
	(20, 'Mark', 'Arno', '555 Quinn', 'Longueuil', 'QC', 'J2R 1B2', '4504687846', '2018-10-30 00:00:00', 'pilote flotte', NULL, 15),
	(21, 'Christine', 'Lajoie', '222 Lemince', 'Longueuil', 'QC', 'J2R 1B2', '4502577781', '2018-12-30 00:00:00', 'pilote vol nuit', NULL, 0.48),
	(22, 'Brad', 'Michaels', '98 St-Jean', 'Bagotville', 'QC', 'J2R 1B2', '8191146843', '2019-02-14 00:00:00', 'élève solo', 2.4, 4.6),
	(23, 'Nancy', 'Gray', '87 Malouine', 'Longueuil', 'QC', 'J2R 1B2', '4503548982', '2018-06-06 00:00:00', 'élève solo', 8.2, NULL),
	(24, 'Kathryn', 'Johnson', '1255 Ontario', 'Montréal', 'QC', 'H2X 2N6', '5143125412', '2018-07-20 00:00:00', 'élève pilote', 7.8, 20.4),
	(25, 'Anne', 'Lee', '1256 Lalonde', 'Montréal', 'QC', 'H2X 2N6', '5146513248', '2018-12-25 00:00:00', 'pilote privé', 14.5, NULL);
/*!40000 ALTER TABLE `client_pilote` ENABLE KEYS */;


-- Export de la structure de table aérovols. constructeur
CREATE TABLE IF NOT EXISTS `constructeur` (
  `no_constructeur` int(11) NOT NULL,
  `nom_constructeur` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `lieu_fabrication` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`no_constructeur`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Export de données de la table aérovols.constructeur : ~9 rows (environ)
DELETE FROM `constructeur`;
/*!40000 ALTER TABLE `constructeur` DISABLE KEYS */;
INSERT INTO `constructeur` (`no_constructeur`, `nom_constructeur`, `lieu_fabrication`) VALUES
	(1, 'PIPER', 'États-Unis'),
	(2, 'CESSNA', 'Wichita Kansas'),
	(3, 'CIRRUS', 'États-Unis'),
	(4, 'DIAMOND', 'London Ontario'),
	(5, 'DE HAVILLAND', 'Toronto Canada'),
	(6, 'BEECHCRAFT', 'LongBeach Californie'),
	(7, 'MAULE', 'Goergie'),
	(8, 'MOONEY', 'États-Unis'),
	(9, 'ALSIM', 'France');
/*!40000 ALTER TABLE `constructeur` ENABLE KEYS */;


-- Export de la structure de table aérovols. location_vol
CREATE TABLE IF NOT EXISTS `location_vol` (
  `no_location_vol` int(11) NOT NULL,
  `date_début_location` datetime DEFAULT NULL,
  `date_fin_location` datetime DEFAULT NULL,
  `heures_vol` float DEFAULT NULL,
  `type_vol` varchar(15) COLLATE utf8_unicode_ci DEFAULT NULL,
  `période_jour` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  `coût_location` double DEFAULT NULL,
  `no_client pilote` int(11) DEFAULT NULL,
  `no_immatriculation` varchar(5) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`no_location_vol`),
  KEY `no_client_pilote` (`no_client pilote`),
  KEY `no_immatriculation` (`no_immatriculation`),
  CONSTRAINT `no_client_pilote` FOREIGN KEY (`no_client pilote`) REFERENCES `client_pilote` (`no_client_pilote`),
  CONSTRAINT `no_immatriculation` FOREIGN KEY (`no_immatriculation`) REFERENCES `avion` (`no_immatriculation`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Export de données de la table aérovols.location_vol : ~8 rows (environ)
DELETE FROM `location_vol`;
/*!40000 ALTER TABLE `location_vol` DISABLE KEYS */;
INSERT INTO `location_vol` (`no_location_vol`, `date_début_location`, `date_fin_location`, `heures_vol`, `type_vol`, `période_jour`, `coût_location`, `no_client pilote`, `no_immatriculation`) VALUES
	(1, '2017-02-23 00:00:00', '2017-02-23 00:00:00', 1.2, 'voyage', 'Jour', 125, 13, 'KJDPI'),
	(2, '2016-02-24 00:00:00', '2016-02-25 00:00:00', 15, 'voyage', 'Jour', 534, 12, 'GOLIE'),
	(3, '2017-03-10 00:00:00', '2017-03-10 00:00:00', 3.12, 'local', 'Nuit', 324, 7, 'BOSIL'),
	(4, '2016-03-01 00:00:00', '2016-03-01 00:00:00', 1.4, 'posé décollé', 'Jour', 132, 24, 'KJDPI'),
	(5, '2017-01-25 00:00:00', '2017-01-25 00:00:00', 2.2, 'local', 'Jour', 254, 11, 'FRGEO'),
	(6, '2017-01-12 00:00:00', '2017-01-13 00:00:00', 15.4, 'voyage', 'Jour', 625, 17, 'OPYDA'),
	(7, '2016-04-17 00:00:00', '2016-04-17 00:00:00', 2.6, 'local', 'Nuit', 245, 18, 'APDSQ'),
	(8, '2017-02-02 00:00:00', '2017-02-03 00:00:00', 8.2, 'voyage', 'Jour', 751, 23, 'LOHER'),
	(9, '2017-01-15 00:00:00', '2017-01-15 00:00:00', 2, 'local', 'Nuit', 248, 9, 'DAOEA'),
	(10, '2016-05-06 00:00:00', '2016-05-06 00:00:00', 2, 'local', 'Jour', 248, 19, 'JILOF'),
	(11, '2016-12-15 00:00:00', '2016-12-15 00:00:00', 0.45, 'posé décollé', 'Jour', 78, 18, 'ATYTE'),
	(12, '2016-07-03 00:00:00', '2016-07-03 00:00:00', 1.24, 'local', 'Nuit', 154, 14, 'OPSWV'),
	(13, '2016-11-18 00:00:00', '2016-11-20 00:00:00', 20.4, 'voyage', 'Nuit', 1251, 24, 'POPIR'),
	(14, '2015-09-02 00:00:00', '2015-09-02 00:00:00', 4.3, 'voyage', 'Jour', 657, 10, 'JFOEW'),
	(15, '2016-08-24 00:00:00', '2016-08-24 00:00:00', 0.7, 'posé décollé', 'Nuit', 102, 15, 'JILOF'),
	(16, '2016-07-03 00:00:00', '2016-07-03 00:00:00', 1.3, 'local', 'Jour', 157, 16, 'KJDPI'),
	(17, '2017-03-04 00:00:00', '2017-03-04 00:00:00', 4.6, 'voyage', 'Nuit', 642, 17, 'ATYTE'),
	(18, '2017-03-01 00:00:00', '2017-03-01 00:00:00', 1.8, 'local', 'Nuit', 220, 14, 'APDSQ'),
	(19, '2017-01-15 00:00:00', '2017-01-15 00:00:00', 0.48, 'posé décollé', 'Nuit', 75, 21, 'JILOF'),
	(20, '2016-09-09 00:00:00', '2016-09-12 00:00:00', 16.7, 'voyage', 'Jour', 812, 11, 'HUIYT'),
	(21, '2017-02-23 00:00:00', '2017-02-23 00:00:00', 1.5, 'local', 'Nuit', 164, 20, 'DAOEA'),
	(22, '2017-03-01 00:00:00', '2017-03-01 00:00:00', 2.5, 'local', 'Nuit', 345, 16, 'KJDPI'),
	(23, '2016-12-01 00:00:00', '2016-12-01 00:00:00', 1.6, 'posé décollé', 'Nuit', 245, 9, 'DAOEA'),
	(24, '2015-05-13 00:00:00', '2015-05-14 00:00:00', 6.4, 'voyage', 'Jour', 542, 24, 'KJDPI'),
	(25, '2016-10-13 00:00:00', '2016-10-13 00:00:00', 0.6, 'posé décollé', 'Nuit', 75, 19, 'OPYDA'),
	(26, '2017-02-17 00:00:00', '2017-01-17 00:00:00', 2.4, 'local', 'Jour', 324, 22, 'PORWE'),
	(27, '2016-04-16 00:00:00', '2016-04-16 00:00:00', 0.75, 'posé décollé', 'Jour', 90, 13, 'POPIR'),
	(28, '2015-05-24 00:00:00', '2015-05-25 00:00:00', 4.6, 'voyage', 'Nuit', 625, 22, 'OPYDA'),
	(29, '2016-06-24 00:00:00', '2016-06-26 00:00:00', 14.5, 'voyage', 'Jour', 826, 25, 'JOTLY'),
	(30, '2017-02-16 00:00:00', '2017-02-17 00:00:00', 4.6, 'voyage', 'Nuit', 510, 12, 'LOHER'),
	(31, '2017-01-01 00:00:00', '2017-01-01 00:00:00', 2.2, 'local', 'Jour', 240, 10, 'POKJI'),
	(32, '2016-10-15 00:00:00', '2016-10-15 00:00:00', 4, 'voyage', 'Jour', 510, 25, 'POKJI'),
	(33, '2017-05-14 00:00:00', '2017-05-14 00:00:00', 0.48, 'posé décollé', 'Nuit', 49, 18, 'POKJI');
/*!40000 ALTER TABLE `location_vol` ENABLE KEYS */;


-- Export de la structure de table aérovols. modèle
CREATE TABLE IF NOT EXISTS `modèle` (
  `no_modèle` int(11) NOT NULL,
  `modèle_avion` varchar(15) COLLATE utf8_unicode_ci DEFAULT NULL,
  `type_moteur` varchar(15) COLLATE utf8_unicode_ci DEFAULT NULL,
  `année_conception` smallint(6) DEFAULT NULL,
  `no_constructeur` int(11) DEFAULT NULL,
  PRIMARY KEY (`no_modèle`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Export de données de la table aérovols.modèle : ~40 rows (environ)
DELETE FROM `modèle`;
/*!40000 ALTER TABLE `modèle` DISABLE KEYS */;
INSERT INTO `modèle` (`no_modèle`, `modèle_avion`, `type_moteur`, `année_conception`, `no_constructeur`) VALUES
	(1, 'CHERROKEE', 'mono moteur', 1961, 1),
	(32, 'CUB J3', 'mono moteur', 1937, 1),
	(34, 'WARRIOR', 'mono moteur', 1970, 1),
	(36, 'MALIBU', 'mono moteur', 1982, 1),
	(38, 'MEREDIEN', 'mono moteur', 1991, 1),
	(41, 'NAVAJO', 'multi moteur', 1968, 1),
	(43, 'SENECA', 'multi moteur', 1972, 1),
	(45, 'SEMINOLE', 'multi moteur', 1976, 1),
	(47, 'AZTEC', 'multi moteur', 1956, 1),
	(48, '140', 'mono moteur', 1946, 2),
	(50, '150', 'mono moteur', 1956, 2),
	(52, '152', 'mono moteur', 1968, 2),
	(54, '170', 'mono moteur', 1946, 2),
	(56, '172', 'mono moteur', 1956, 2),
	(58, '175', 'mono moteur', 1957, 2),
	(60, '180', 'mono moteur', 1953, 2),
	(62, '182', 'mono moteur', 1968, 2),
	(64, 'SR20', 'mono moteur', 1992, 3),
	(66, 'SR22', 'mono moteur', 1992, 3),
	(68, 'DA20', 'mono moteur', 1989, 4),
	(71, 'DA40', 'mono moteur', 1990, 4),
	(73, 'DA50', 'mono moteur', 2005, 4),
	(74, 'BEAVER', 'mono moteur', 1942, 5),
	(76, 'HOTTER', 'mono moteur', 1942, 5),
	(79, 'TWIN HOTTER', 'multi moteur', 1965, 5),
	(80, 'SUN DOWNER', 'mono moteur', 1972, 6),
	(83, 'BARON', 'multi moteur', 1972, 6),
	(84, 'M6', 'mono moteur', 1952, 7),
	(86, 'M7', 'mono moteur', 1970, 7),
	(88, 'M5', 'mono moteur', 1951, 7),
	(90, 'M20A', 'mono moteur', 1963, 8),
	(93, 'M20B', 'mono moteur', 1959, 8),
	(95, 'M20C', 'mono moteur', 1966, 8),
	(96, 'M20D', 'mono moteur', 1962, 8),
	(99, 'M20E', 'mono moteur', 1964, 8),
	(100, 'AL200 MCC', 'mono et multi', 1999, 9),
	(101, 'AL300 MCC', 'mono et multi', 2001, 9),
	(102, 'DA42', 'multi moteur', 2001, 4),
	(103, 'STARSHIP', 'mono et multi', 1980, 6),
	(104, 'AL200 DA42', 'mono et multi', 2005, 9);
/*!40000 ALTER TABLE `modèle` ENABLE KEYS */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
