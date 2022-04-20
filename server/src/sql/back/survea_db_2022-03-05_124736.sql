/*!40101 SET NAMES utf8 */;
/*!40014 SET FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/ survea_db /*!40100 DEFAULT CHARACTER SET utf8mb4 */;
USE survea_db;

DROP TABLE IF EXISTS answer;
CREATE TABLE `answer` (
  `ID_Answer` int NOT NULL AUTO_INCREMENT,
  `Answer` char(100) NOT NULL,
  `ID_Question` int NOT NULL,
  `ID_Survey` int NOT NULL,
  `aOrder` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID_Answer`,`ID_Question`,`ID_Survey`),
  KEY `Esta_formada` (`ID_Question`,`ID_Survey`),
  CONSTRAINT `Esta_formada` FOREIGN KEY (`ID_Question`, `ID_Survey`) REFERENCES `question` (`ID_Question`, `ID_Survey`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS question;
CREATE TABLE `question` (
  `ID_Question` int NOT NULL AUTO_INCREMENT,
  `Question` char(255) NOT NULL,
  `Type` char(255) NOT NULL,
  `ID_Survey` int NOT NULL,
  `qOrder` int NOT NULL DEFAULT '0',
  `Description` text,
  PRIMARY KEY (`ID_Question`,`ID_Survey`),
  KEY `Esta_conformada` (`ID_Survey`),
  KEY `ID_Question` (`ID_Question`),
  CONSTRAINT `Esta_conformada` FOREIGN KEY (`ID_Survey`) REFERENCES `survey` (`ID_Survey`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS survey;
CREATE TABLE `survey` (
  `ID_Survey` int NOT NULL AUTO_INCREMENT,
  `Title` char(50) NOT NULL,
  `Description` char(255) DEFAULT NULL,
  `StartDate` datetime DEFAULT NULL,
  `FinalDate` datetime DEFAULT NULL,
  `LastModification` date DEFAULT NULL,
  `ID_User` int NOT NULL,
  PRIMARY KEY (`ID_Survey`),
  KEY `Realiza` (`ID_User`),
  CONSTRAINT `Realiza` FOREIGN KEY (`ID_User`) REFERENCES `user` (`ID_User`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS surveyed;
CREATE TABLE `surveyed` (
  `ID_Surveyed` int NOT NULL AUTO_INCREMENT,
  `Name` char(35) NOT NULL,
  `Email` char(50) NOT NULL,
  `ID_Survey` int NOT NULL,
  PRIMARY KEY (`ID_Surveyed`,`ID_Survey`),
  KEY `Tiene` (`ID_Survey`),
  CONSTRAINT `Tiene` FOREIGN KEY (`ID_Survey`) REFERENCES `survey` (`ID_Survey`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS surveyed_answer;
CREATE TABLE `surveyed_answer` (
  `Answer` char(255) NOT NULL,
  `ID_Question` int NOT NULL,
  `ID_Survey` int NOT NULL,
  `ID_Surveyed` int NOT NULL,
  PRIMARY KEY (`ID_Question`,`ID_Surveyed`,`ID_Survey`),
  KEY `Responde` (`ID_Surveyed`,`ID_Survey`),
  KEY `Tienen` (`ID_Question`,`ID_Survey`),
  CONSTRAINT `Responde` FOREIGN KEY (`ID_Surveyed`, `ID_Survey`) REFERENCES `surveyed` (`ID_Surveyed`, `ID_Survey`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `Tienen` FOREIGN KEY (`ID_Question`, `ID_Survey`) REFERENCES `question` (`ID_Question`, `ID_Survey`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS user;
CREATE TABLE `user` (
  `ID_User` int NOT NULL AUTO_INCREMENT,
  `Name` char(20) NOT NULL,
  `LastName` char(20) NOT NULL,
  `Email` char(20) NOT NULL,
  `Gender` char(20) DEFAULT NULL,
  `Password` varchar(255) NOT NULL,
  PRIMARY KEY (`ID_User`),
  UNIQUE KEY `idx_email_user` (`Email`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=latin1;

CREATE OR REPLACE VIEW `vw_survey_complete` AS select `s`.`ID_Survey` AS `ID_Survey`,`s`.`Title` AS `Title`,`s`.`Description` AS `Description`,`s`.`StartDate` AS `StartDate`,`s`.`FinalDate` AS `FinalDate`,`s`.`LastModification` AS `LastModification`,`s`.`ID_User` AS `ID_User`,`q`.`ID_Question` AS `ID_Question`,`q`.`Question` AS `Question`,`q`.`Type` AS `Type`,`q`.`Description` AS `Question_Description`,`q`.`qOrder` AS `qOrder`,`a`.`ID_Answer` AS `ID_Answer`,`a`.`Answer` AS `Answer` from ((`survey` `s` left join `question` `q` on((`q`.`ID_Survey` = `s`.`ID_Survey`))) left join `answer` `a` on(((`a`.`ID_Question` = `q`.`ID_Question`) and (`a`.`ID_Survey` = `q`.`ID_Survey`))));

INSERT INTO answer(ID_Answer,Answer,ID_Question,ID_Survey,aOrder) VALUES(1,'Mal',1,1,0),(1,'OPcion 1',1,2,0),(1,'asd',1,19,0),(1,'bueno',1,21,0),(1,'Opcion 1',2,2,0),(1,'Si',2,21,0),(1,'Zoom',3,21,0),(2,'Normal',1,1,0),(2,'Opcion 2',1,2,0),(2,'da',1,19,0),(2,'malo',1,21,0),(2,'Opcion 2',2,2,0),(2,'no',2,21,0),(2,'Modulo 7',3,21,0),(3,'Calidoso',1,1,0),(3,'Opcion 3',1,2,0),(3,'sd',1,19,0),(3,'regular',1,21,0),(3,'OPcion 3',2,2,0),(3,'Google meet',3,21,0),(4,'d',1,19,0),(4,'Discord',3,21,0);

INSERT INTO question(ID_Question,Question,Type,ID_Survey,qOrder,Description) VALUES(1,'Que se siente ser tan malo en voley?','radio',1,0,NULL),(1,'Esta es la pregunta 1','select',2,0,NULL),(1,'¿Como te llamas?','select',19,0,X''),(1,'Que tal la modalidad virtual?','radio',21,0,X''),(1,'Pregunta 1','select',22,0,X''),(2,'Comentanos de tu experiencia con el short','textarea',1,0,NULL),(2,'Esta es la pregunta 2','radio',2,0,NULL),(2,'Te gustaria volver a presencial?','select',21,1,X''),(3,'Pregunta 3: ingrese una fecha','date',2,0,NULL),(3,'Cuales plataformas has utilizado?','checkbox',21,2,X'');

INSERT INTO survey(ID_Survey,Title,Description,StartDate,FinalDate,LastModification,ID_User) VALUES(1,'Encuesta de Nahum','A Nahum se le rompe el short','2022-02-09 02:14:12','2022-02-09 02:14:12','2022-02-16',1),(2,'Encuesta de Guss','Esta es una Descripcion','2022-02-09 04:29:17','2022-02-09 04:29:17','2022-02-16',1),(18,'',NULL,'2022-02-15 02:42:00','2022-02-15 02:42:00','2022-02-16',2),(19,'1','2','2022-02-15 23:42:14','2022-02-15 23:42:14','2022-02-16',15),(20,'',NULL,'2022-02-16 07:16:41','2022-02-16 07:16:41','2022-02-16',2),(21,'Mi en cuesta','Encuesta sobre el semestre virtual','2022-02-16 19:34:12','2022-02-16 19:34:12','2022-02-16',20),(22,'',NULL,'2022-02-18 00:35:44','2022-02-18 00:35:44','2022-02-16',1),(25,'prueba','',NULL,NULL,'2022-02-22',20),(26,'Hola amigos','','2022-02-22 00:13:21','2022-02-22 00:13:21','2022-02-22',20);

INSERT INTO surveyed(ID_Surveyed,Name,Email,ID_Survey) VALUES(6,'','',2),(7,'','',2),(12,'','',2),(17,'','',2),(18,'','',2),(25,'','',19),(26,'','',21),(27,'','',21),(28,'','',21);

INSERT INTO surveyed_answer(Answer,ID_Question,ID_Survey,ID_Surveyed) VALUES('OPcion 1',1,2,12),('Opcion 2',1,2,17),('Opcion 3',1,2,18),('da',1,19,25),('Opcion 2',2,2,12),('OPcion 3',2,2,17),('OPcion 3',2,2,18),('jiojofjerjfij',3,2,12),('2022-02-08',3,2,17),('2022-02-05',3,2,18);
INSERT INTO user(ID_User,Name,LastName,Email,Gender,Password) VALUES(1,'Guss','Gutierrez','gus@gmail.com','M',''),(2,'Jesus','Gutierrez','email@algo.com',NULL,'$2a$10$vDfDFvLjApEM0WLtzA/I2.OZKIHM3eyEKq.nqtGsXYpA3PbLIdPii'),(3,'Jesus','Gutiérrez','jags@gmail.com',NULL,'$2a$10$PvLVeHWch3X2bjn0SVSVbOQBKzem3hPwP.mhSxYVRUwr6pj3hhbXO'),(4,'Nahum','Giral','nahum@gmail.com',NULL,'$2a$10$S/ogDs7JAdreHJ1imts0kOA4Kn.vynJR1Ob4bmkZEL84F1TYyspzm'),(7,'Diego','Gamboa','gamboa@gmail.com',NULL,'$2a$10$pyLVEe6Spo2/7lBxGLwkB.L9b71hMyYjhF1s6PF13aaaKX911qoqu'),(10,'gugug','dedede','email@algo2.com',NULL,'$2a$10$OV4jthuYfPzu5Epfl13.QuEQTqL/NASNwC62r/aHIRhgBJvKO8Fgm'),(11,'Gustavo','Gutierrez','otro@gmail.com',NULL,'$2a$10$tih3tj1ajjeeZ3xe9OAMmOebV156kFEZvUKA6FfHb7oq8eQSukJai'),(12,'Jesus','Gutierrez','otro2@gmail.com',NULL,'$2a$10$d/7WTAqQrETAwlUGHQL4AuzeN6M9lzNq0GiMpTt4doBJnkdKSPyBC'),(14,'Gustavo','Jesus','otro3@gmail.com',NULL,'$2a$10$hwkIAoWfGClFx.dNSdbu1ui0dbEmhhH3.5PZWQ4sMG0/a.AthL69e'),(15,'Yohangel','Lopez','yohangel@gmail.com',NULL,'$2a$10$qXbdiwf8n49cYvkrPt.0eeIGmQqO2zTNpgT/gc6XTv1lPC0mOajEu'),(16,'dedede','deded','otro4@gmail.com',NULL,'$2a$10$FUfTfl5gKya2e23SB34uhOV1Y6GEvTiU8Qhe7DqljGYmTocnhQ4US'),(18,'gggg','hhhhhh','otro5@gmail.com',NULL,'$2a$10$iZm3I8y1v9T5n84CH9IAdeqHto/X8tPxD4o/pdtu1MFz0mHFlS6gi'),(20,'Gustavo','Gutierrez','gustavo@gmail.com',NULL,'$2a$10$mROaz5RYL6vNIkd1CdbRKuDrklNfyBkrF4Ch6Z0.9Wy.ywEeVFwqS');DROP PROCEDURE IF EXISTS sp_save_last_edition;
CREATE PROCEDURE `sp_save_last_edition`(
	_ID_Survey INT
)
BEGIN
	UPDATE survey
	SET survey.LastModification = CURRENT_DATE
	WHERE ID_Survey = _ID_Survey;
END;

DROP TRIGGER IF EXISTS tg_after_question_insert;
CREATE TRIGGER `tg_after_question_insert` AFTER INSERT ON `question` FOR EACH ROW BEGIN
    CALL sp_save_last_edition(NEW.ID_Survey);
END;

DROP TRIGGER IF EXISTS tg_after_question_update;
CREATE TRIGGER `tg_after_question_update` AFTER UPDATE ON `question` FOR EACH ROW BEGIN
    CALL sp_save_last_edition(NEW.ID_Survey);
END;

DROP TRIGGER IF EXISTS tg_after_answer_insert;
CREATE TRIGGER `tg_after_answer_insert` AFTER INSERT ON `answer` FOR EACH ROW BEGIN
    CALL sp_save_last_edition(NEW.ID_Survey);
END;

DROP TRIGGER IF EXISTS tg_after_question_delete;
CREATE TRIGGER `tg_after_question_delete` AFTER DELETE ON `question` FOR EACH ROW BEGIN
    CALL sp_save_last_edition(OLD.ID_Survey);
END;

DROP TRIGGER IF EXISTS tg_after_answer_delete;
CREATE TRIGGER `tg_after_answer_delete` AFTER DELETE ON `answer` FOR EACH ROW BEGIN
    CALL sp_save_last_edition(OLD.ID_Survey);
END;

DROP TRIGGER IF EXISTS tg_after_answer_update;
CREATE TRIGGER `tg_after_answer_update` AFTER UPDATE ON `answer` FOR EACH ROW BEGIN
    CALL sp_save_last_edition(NEW.ID_Survey);
END;

DROP TRIGGER IF EXISTS tg_before_survey_insert;
CREATE TRIGGER `tg_before_survey_insert` BEFORE INSERT ON `survey` FOR EACH ROW BEGIN
    SET NEW.LastModification = CURRENT_DATE;
END;

DROP TRIGGER IF EXISTS tg_before_survey_update;
CREATE TRIGGER `tg_before_survey_update` BEFORE UPDATE ON `survey` FOR EACH ROW BEGIN
   SET NEW.LastModification = CURRENT_DATE;
END;