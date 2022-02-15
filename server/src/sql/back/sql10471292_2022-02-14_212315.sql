/*!40101 SET NAMES utf8 */;
/*!40014 SET FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET SQL_NOTES=0 */;

DROP TABLE IF EXISTS Answer;
CREATE TABLE `Answer` (
  `ID_Answer` int(11) NOT NULL AUTO_INCREMENT,
  `Answer` char(100) NOT NULL,
  `ID_Question` int(11) NOT NULL,
  `ID_Survey` int(11) NOT NULL,
  `aOrder` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID_Answer`,`ID_Question`,`ID_Survey`),
  KEY `Esta_formada` (`ID_Question`,`ID_Survey`),
  CONSTRAINT `Esta_formada` FOREIGN KEY (`ID_Question`, `ID_Survey`) REFERENCES `Question` (`ID_Question`, `ID_Survey`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS Question;
CREATE TABLE `Question` (
  `ID_Question` int(11) NOT NULL AUTO_INCREMENT,
  `Question` char(255) NOT NULL,
  `Type` char(255) NOT NULL,
  `ID_Survey` int(11) NOT NULL,
  `qOrder` int(11) NOT NULL DEFAULT '0',
  `Description` text,
  PRIMARY KEY (`ID_Question`,`ID_Survey`),
  KEY `Esta_conformada` (`ID_Survey`),
  CONSTRAINT `Esta_conformada` FOREIGN KEY (`ID_Survey`) REFERENCES `Survey` (`ID_Survey`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS Survey;
CREATE TABLE `Survey` (
  `ID_Survey` int(11) NOT NULL AUTO_INCREMENT,
  `Title` char(50) NOT NULL,
  `Description` char(255) DEFAULT NULL,
  `StartDate` datetime NOT NULL,
  `FinalDate` datetime NOT NULL,
  `ID_User` int(11) NOT NULL,
  PRIMARY KEY (`ID_Survey`),
  KEY `Realiza` (`ID_User`),
  CONSTRAINT `Realiza` FOREIGN KEY (`ID_User`) REFERENCES `User` (`ID_User`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS Surveyed;
CREATE TABLE `Surveyed` (
  `ID_Surveyed` int(11) NOT NULL AUTO_INCREMENT,
  `Name` char(35) NOT NULL,
  `Email` char(50) NOT NULL,
  `ID_Survey` int(11) NOT NULL,
  PRIMARY KEY (`ID_Surveyed`,`ID_Survey`),
  KEY `Tiene` (`ID_Survey`),
  CONSTRAINT `Tiene` FOREIGN KEY (`ID_Survey`) REFERENCES `Survey` (`ID_Survey`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS Surveyed_Answer;
CREATE TABLE `Surveyed_Answer` (
  `Answer` char(255) NOT NULL,
  `ID_Question` int(11) NOT NULL,
  `ID_Survey` int(11) NOT NULL,
  `ID_Surveyed` int(11) NOT NULL,
  PRIMARY KEY (`ID_Question`,`ID_Surveyed`,`ID_Survey`),
  KEY `Responde` (`ID_Surveyed`,`ID_Survey`),
  CONSTRAINT `Responde` FOREIGN KEY (`ID_Surveyed`, `ID_Survey`) REFERENCES `Surveyed` (`ID_Surveyed`, `ID_Survey`),
  CONSTRAINT `Tienen` FOREIGN KEY (`ID_Question`) REFERENCES `Question` (`ID_Question`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS User;
CREATE TABLE `User` (
  `ID_User` int(11) NOT NULL AUTO_INCREMENT,
  `Name` char(20) NOT NULL,
  `LastName` char(20) NOT NULL,
  `Email` char(20) NOT NULL,
  `Gender` char(20) DEFAULT NULL,
  `Password` varchar(255) NOT NULL,
  PRIMARY KEY (`ID_User`),
  UNIQUE KEY `idx_email_user` (`Email`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;

INSERT INTO Answer(ID_Answer,Answer,ID_Question,ID_Survey,aOrder) VALUES(1,'Mal',1,1,0),(1,'OPcion 1',1,2,0),(1,'Opcion1',1,15,0),(1,'Opcion 1',2,2,0),(1,'Opcion1',2,15,0),(1,'frfr',2,16,0),(1,'1',3,7,0),(1,'frfr',3,16,0),(2,'Normal',1,1,0),(2,'Opcion 2',1,2,0),(2,'gustavo?',1,3,0),(2,'Opcion2',1,15,0),(2,'Opcion 2',2,2,0),(2,'Opcion2',2,15,0),(2,'frf',2,16,0),(2,'2',3,7,0),(2,'frf',3,16,0),(3,'Calidoso',1,1,0),(3,'Opcion 3',1,2,0),(3,'¿gustavo?',1,3,0),(3,'OPcion 3',2,2,0);

INSERT INTO Question(ID_Question,Question,Type,ID_Survey,qOrder,Description) VALUES(1,'Que se siente ser tan malo en voley?','radio',1,0,NULL),(1,'Esta es la pregunta 1','select',2,0,NULL),(1,'Gustavo?','checkbox',3,0,NULL),(1,'','select',4,0,NULL),(1,'1','select',7,0,NULL),(1,'Pregunta 1','radio',15,0,NULL),(1,'1','textarea',16,0,NULL),(1,'Pregunta 1 GUSS','select',17,0,X'646564656465'),(2,'Comentanos de tu experiencia con el short','textarea',1,0,NULL),(2,'Esta es la pregunta 2','radio',2,0,NULL),(2,'2','select',7,0,NULL),(2,'Pregunta 2','checkbox',15,0,NULL),(2,'2','select',16,0,NULL),(2,'Pregunta 2 GUSS','select',17,2,X'626262'),(3,'Pregunta 3: ingrese una fecha','date',2,0,NULL),(3,'','select',7,0,NULL),(3,'Pregunta 3','textarea',15,0,NULL),(3,'3','select',16,0,NULL),(3,'Pregunta 3 GUSS','select',17,1,X'61616161');

INSERT INTO Survey(ID_Survey,Title,Description,StartDate,FinalDate,ID_User) VALUES(1,'Encuesta de Nahum','A Nahum se le rompe el short','2022-02-09 02:14:12','2022-02-09 02:14:12',1),(2,'Encuesta de Guss','Esta es una Descripcion','2022-02-09 04:29:17','2022-02-09 04:29:17',1),(3,'Gustavo','gustavito','2022-02-09 02:45:58','2022-02-09 02:45:58',1),(4,'',NULL,'2022-02-10 02:40:13','2022-02-10 02:40:13',1),(5,'',NULL,'2022-02-10 02:42:45','2022-02-10 02:42:45',1),(6,'',NULL,'2022-02-10 03:00:37','2022-02-10 03:00:37',1),(7,'',NULL,'2022-02-10 03:01:32','2022-02-10 03:01:32',1),(9,'',NULL,'2022-02-10 03:05:42','2022-02-10 03:05:42',1),(10,'',NULL,'2022-02-11 13:39:41','2022-02-11 13:39:41',1),(11,'',NULL,'2022-02-11 13:40:43','2022-02-11 13:40:43',1),(12,'',NULL,'2022-02-11 13:40:54','2022-02-11 13:40:54',1),(13,'',NULL,'2022-02-11 13:41:11','2022-02-11 13:41:11',1),(14,'',NULL,'2022-02-11 13:41:25','2022-02-11 13:41:25',1),(15,'Encuesta de Jesús','Descripción','2022-02-12 06:28:11','2022-02-12 06:28:11',1),(16,'Untitlefrf','dedefrfr','2022-02-12 09:14:49','2022-02-12 09:14:49',1),(17,'Esta es una encuesta','Descripcion de la encusta','2022-02-14 09:01:54','2022-02-14 09:01:54',1);

INSERT INTO Surveyed(ID_Surveyed,Name,Email,ID_Survey) VALUES(1,'','',3),(2,'','',3),(3,'','',3),(4,'','',3),(5,'','',3),(6,'','',2),(7,'','',2),(8,'','',3),(9,'','',3),(10,'','',3),(11,'','',3),(12,'','',2),(13,'','',3),(14,'','',3),(15,'','',3),(16,'','',3),(17,'','',2),(18,'','',2),(19,'','',9),(20,'','',15),(21,'','',15),(22,'','',16),(23,'','',16),(24,'','',16);

INSERT INTO Surveyed_Answer(Answer,ID_Question,ID_Survey,ID_Surveyed) VALUES('gustavo',1,3,8),('gustavo',1,3,9),('gustavo',1,3,10),('gustavo',1,3,11),('OPcion 1',1,2,12),('gustavo?,',1,3,13),('gustavo?,',1,3,14),('¿gustavo?,',1,3,15),('uhuh,',1,3,16),('Opcion 2',1,2,17),('Opcion 3',1,2,18),('Opcion1',1,15,20),('Opcion1',1,15,21),('feferf',1,16,22),('dedede',1,16,23),('cdc',1,16,24),('Opcion 2',2,2,12),('OPcion 3',2,2,17),('OPcion 3',2,2,18),('Opcion2,',2,15,20),('Opcion1,Opcion2,',2,15,21),('frfr',2,16,22),('frfr',2,16,23),('frfr',2,16,24),('jiojofjerjfij',3,2,12),('2022-02-08',3,2,17),('2022-02-05',3,2,18),('Respuesta',3,15,20),('Otra respuesta',3,15,21),('frfr',3,16,22),('frfr',3,16,23),('frfr',3,16,24);
INSERT INTO User(ID_User,Name,LastName,Email,Gender,Password) VALUES(1,'Guss','Gutierrez','gus@gmail.com','M',''),(2,'Jesus','Gutierrez','email@algo.com',NULL,'$2a$10$vDfDFvLjApEM0WLtzA/I2.OZKIHM3eyEKq.nqtGsXYpA3PbLIdPii'),(3,'Jesus','Gutiérrez','jags@gmail.com',NULL,'$2a$10$PvLVeHWch3X2bjn0SVSVbOQBKzem3hPwP.mhSxYVRUwr6pj3hhbXO'),(4,'Nahum','Giral','nahum@gmail.com',NULL,'$2a$10$S/ogDs7JAdreHJ1imts0kOA4Kn.vynJR1Ob4bmkZEL84F1TYyspzm'),(7,'Diego','Gamboa','gamboa@gmail.com',NULL,'$2a$10$pyLVEe6Spo2/7lBxGLwkB.L9b71hMyYjhF1s6PF13aaaKX911qoqu'),(10,'gugug','dedede','email@algo2.com',NULL,'$2a$10$OV4jthuYfPzu5Epfl13.QuEQTqL/NASNwC62r/aHIRhgBJvKO8Fgm');