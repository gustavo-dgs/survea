CREATE TABLE `User`
(
  `ID_User` Int NOT NULL AUTO_INCREMENT,
  `Name` Char(20) NOT NULL,
  `LastName` Char(20) NOT NULL,
  `Email` Char(20) NOT NULL,
  `Gender` Char(20) NOT NULL,
  PRIMARY KEY (`ID_User`)
)
;

-- Table Survey

CREATE TABLE `Survey`
(
  `ID_Survey` Int NOT NULL AUTO_INCREMENT,
  `Title` Char(50) NOT NULL,
  `Description` Char(255),
  `StartDate` Datetime NOT NULL,
  `FinalDate` Datetime NOT NULL,
  `ID_User` Int NOT NULL,
  PRIMARY KEY (`ID_Survey`,`ID_User`)
)
;

-- Table Question

CREATE TABLE `Question`
(
  `ID_Question` Int NOT NULL AUTO_INCREMENT,
  `Question` Char(255) NOT NULL,
  `Type` Char(255) NOT NULL,
  `ID_Survey` Int NOT NULL,
  `ID_User` Int NOT NULL,
  PRIMARY KEY (`ID_Question`,`ID_Survey`,`ID_User`)
)
;

-- Table Answer

CREATE TABLE `Answer`
(
  `ID_Answer` Int NOT NULL AUTO_INCREMENT,
  `Answer` Char(100) NOT NULL,
  `ID_Question` Int NOT NULL,
  `ID_Survey` Int NOT NULL,
  `ID_User` Int NOT NULL,
  PRIMARY KEY (`ID_Answer`,`ID_Question`,`ID_Survey`,`ID_User`)
)
;

-- Table Surveyed

CREATE TABLE `Surveyed`
(
  `ID_Surveyed` Int NOT NULL AUTO_INCREMENT,
  `Name` Char(35) NOT NULL,
  `Email` Char(50) NOT NULL,
  `ID_Survey` Int NOT NULL,
  `ID_User` Int NOT NULL,
  PRIMARY KEY (`ID_Surveyed`,`ID_Survey`,`ID_User`)
)
;

-- Table Surveyed_Answer

CREATE TABLE `Surveyed_Answer`
(
  `Answer` Char(255) NOT NULL,
  `ID_Question` Int NOT NULL,
  `ID_Survey` Int NOT NULL,
  `ID_User` Int NOT NULL,
  `ID_Surveyed` Int NOT NULL
)
;

ALTER TABLE `Surveyed_Answer` ADD PRIMARY KEY (`ID_Question`,`ID_Surveyed`,`ID_Survey`,`ID_User`)
;

-- Create foreign keys (relationships) section -------------------------------------------------

ALTER TABLE `Survey` ADD CONSTRAINT `Realiza` FOREIGN KEY (`ID_User`) REFERENCES `User` (`ID_User`) ON DELETE RESTRICT ON UPDATE RESTRICT
;

ALTER TABLE `Question` ADD CONSTRAINT `Esta_conformada` FOREIGN KEY (`ID_Survey`, `ID_User`) REFERENCES `Survey` (`ID_Survey`, `ID_User`) ON DELETE RESTRICT ON UPDATE RESTRICT
;

ALTER TABLE `Answer` ADD CONSTRAINT `Esta_formada` FOREIGN KEY (`ID_Question`, `ID_Survey`, `ID_User`) REFERENCES `Question` (`ID_Question`, `ID_Survey`, `ID_User`) ON DELETE RESTRICT ON UPDATE RESTRICT
;

ALTER TABLE `Surveyed` ADD CONSTRAINT `Tiene` FOREIGN KEY (`ID_Survey`, `ID_User`) REFERENCES `Survey` (`ID_Survey`, `ID_User`) ON DELETE RESTRICT ON UPDATE RESTRICT
;

ALTER TABLE `Surveyed_Answer` ADD CONSTRAINT `Tienen` FOREIGN KEY (`ID_Question`) REFERENCES `Question` (`ID_Question`) ON DELETE RESTRICT ON UPDATE RESTRICT
;

ALTER TABLE `Surveyed_Answer` ADD CONSTRAINT `Responde` FOREIGN KEY (`ID_Surveyed`, `ID_Survey`, `ID_User`) REFERENCES `Surveyed` (`ID_Surveyed`, `ID_Survey`, `ID_User`) ON DELETE RESTRICT ON UPDATE RESTRICT
;