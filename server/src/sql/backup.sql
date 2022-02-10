/*
 Navicat Premium Data Transfer

 Source Server         : survea
 Source Server Type    : MySQL
 Source Server Version : 50562
 Source Host           : sql10.freemysqlhosting.net:3306
 Source Schema         : sql10471292

 Target Server Type    : MySQL
 Target Server Version : 50562
 File Encoding         : 65001

 Date: 09/02/2022 13:19:48
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for Answer
-- ----------------------------
DROP TABLE IF EXISTS `Answer`;
CREATE TABLE `Answer`  (
  `ID_Answer` int(11) NOT NULL AUTO_INCREMENT,
  `Answer` char(100) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `ID_Question` int(11) NOT NULL,
  `ID_Survey` int(11) NOT NULL,
  PRIMARY KEY (`ID_Answer`, `ID_Question`, `ID_Survey`) USING BTREE,
  INDEX `Esta_formada`(`ID_Question`, `ID_Survey`) USING BTREE,
  CONSTRAINT `Esta_formada` FOREIGN KEY (`ID_Question`, `ID_Survey`) REFERENCES `Question` (`ID_Question`, `ID_Survey`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of Answer
-- ----------------------------
INSERT INTO `Answer` VALUES (1, 'Mal', 1, 1);
INSERT INTO `Answer` VALUES (1, 'OPcion 1', 1, 2);
INSERT INTO `Answer` VALUES (1, 'Opcion 1', 2, 2);
INSERT INTO `Answer` VALUES (2, 'Normal', 1, 1);
INSERT INTO `Answer` VALUES (2, 'Opcion 2', 1, 2);
INSERT INTO `Answer` VALUES (2, 'gustavo?', 1, 3);
INSERT INTO `Answer` VALUES (2, 'Opcion 2', 2, 2);
INSERT INTO `Answer` VALUES (3, 'Calidoso', 1, 1);
INSERT INTO `Answer` VALUES (3, 'Opcion 3', 1, 2);
INSERT INTO `Answer` VALUES (3, '¿gustavo?', 1, 3);
INSERT INTO `Answer` VALUES (3, 'OPcion 3', 2, 2);

-- ----------------------------
-- Table structure for Question
-- ----------------------------
DROP TABLE IF EXISTS `Question`;
CREATE TABLE `Question`  (
  `ID_Question` int(11) NOT NULL AUTO_INCREMENT,
  `Question` char(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `Type` char(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `ID_Survey` int(11) NOT NULL,
  PRIMARY KEY (`ID_Question`, `ID_Survey`) USING BTREE,
  INDEX `Esta_conformada`(`ID_Survey`) USING BTREE,
  CONSTRAINT `Esta_conformada` FOREIGN KEY (`ID_Survey`) REFERENCES `Survey` (`ID_Survey`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of Question
-- ----------------------------
INSERT INTO `Question` VALUES (1, 'Que se siente ser tan malo en voley?', 'radio', 1);
INSERT INTO `Question` VALUES (1, 'Esta es la pregunta 1', 'select', 2);
INSERT INTO `Question` VALUES (1, 'Gustavo?', 'checkbox', 3);
INSERT INTO `Question` VALUES (2, 'Comentanos de tu experiencia con el short', 'textarea', 1);
INSERT INTO `Question` VALUES (2, 'Esta es la pregunta 2', 'radio', 2);
INSERT INTO `Question` VALUES (3, 'Pregunta 3: ingrese una fecha', 'date', 2);

-- ----------------------------
-- Table structure for Survey
-- ----------------------------
DROP TABLE IF EXISTS `Survey`;
CREATE TABLE `Survey`  (
  `ID_Survey` int(11) NOT NULL AUTO_INCREMENT,
  `Title` char(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `Description` char(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `StartDate` datetime NOT NULL,
  `FinalDate` datetime NOT NULL,
  `ID_User` int(11) NOT NULL,
  PRIMARY KEY (`ID_Survey`) USING BTREE,
  INDEX `Realiza`(`ID_User`) USING BTREE,
  CONSTRAINT `Realiza` FOREIGN KEY (`ID_User`) REFERENCES `User` (`ID_User`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of Survey
-- ----------------------------
INSERT INTO `Survey` VALUES (1, 'Encuesta de Nahum', 'A Nahum se le rompe el short', '2022-02-09 02:14:12', '2022-02-09 02:14:12', 1);
INSERT INTO `Survey` VALUES (2, 'Encuesta de Guss', 'Esta es una Descripcion', '2022-02-09 04:29:17', '2022-02-09 04:29:17', 1);
INSERT INTO `Survey` VALUES (3, 'Gustavo', 'gustavito', '2022-02-09 02:45:58', '2022-02-09 02:45:58', 1);

-- ----------------------------
-- Table structure for Surveyed
-- ----------------------------
DROP TABLE IF EXISTS `Surveyed`;
CREATE TABLE `Surveyed`  (
  `ID_Surveyed` int(11) NOT NULL AUTO_INCREMENT,
  `Name` char(35) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `Email` char(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `ID_Survey` int(11) NOT NULL,
  PRIMARY KEY (`ID_Surveyed`, `ID_Survey`) USING BTREE,
  INDEX `Tiene`(`ID_Survey`) USING BTREE,
  CONSTRAINT `Tiene` FOREIGN KEY (`ID_Survey`) REFERENCES `Survey` (`ID_Survey`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 19 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of Surveyed
-- ----------------------------
INSERT INTO `Surveyed` VALUES (1, '', '', 3);
INSERT INTO `Surveyed` VALUES (2, '', '', 3);
INSERT INTO `Surveyed` VALUES (3, '', '', 3);
INSERT INTO `Surveyed` VALUES (4, '', '', 3);
INSERT INTO `Surveyed` VALUES (5, '', '', 3);
INSERT INTO `Surveyed` VALUES (6, '', '', 2);
INSERT INTO `Surveyed` VALUES (7, '', '', 2);
INSERT INTO `Surveyed` VALUES (8, '', '', 3);
INSERT INTO `Surveyed` VALUES (9, '', '', 3);
INSERT INTO `Surveyed` VALUES (10, '', '', 3);
INSERT INTO `Surveyed` VALUES (11, '', '', 3);
INSERT INTO `Surveyed` VALUES (12, '', '', 2);
INSERT INTO `Surveyed` VALUES (13, '', '', 3);
INSERT INTO `Surveyed` VALUES (14, '', '', 3);
INSERT INTO `Surveyed` VALUES (15, '', '', 3);
INSERT INTO `Surveyed` VALUES (16, '', '', 3);
INSERT INTO `Surveyed` VALUES (17, '', '', 2);
INSERT INTO `Surveyed` VALUES (18, '', '', 2);

-- ----------------------------
-- Table structure for Surveyed_Answer
-- ----------------------------
DROP TABLE IF EXISTS `Surveyed_Answer`;
CREATE TABLE `Surveyed_Answer`  (
  `Answer` char(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `ID_Question` int(11) NOT NULL,
  `ID_Survey` int(11) NOT NULL,
  `ID_Surveyed` int(11) NOT NULL,
  PRIMARY KEY (`ID_Question`, `ID_Surveyed`, `ID_Survey`) USING BTREE,
  INDEX `Responde`(`ID_Surveyed`, `ID_Survey`) USING BTREE,
  CONSTRAINT `Responde` FOREIGN KEY (`ID_Surveyed`, `ID_Survey`) REFERENCES `Surveyed` (`ID_Surveyed`, `ID_Survey`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `Tienen` FOREIGN KEY (`ID_Question`) REFERENCES `Question` (`ID_Question`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of Surveyed_Answer
-- ----------------------------
INSERT INTO `Surveyed_Answer` VALUES ('gustavo', 1, 3, 8);
INSERT INTO `Surveyed_Answer` VALUES ('gustavo', 1, 3, 9);
INSERT INTO `Surveyed_Answer` VALUES ('gustavo', 1, 3, 10);
INSERT INTO `Surveyed_Answer` VALUES ('gustavo', 1, 3, 11);
INSERT INTO `Surveyed_Answer` VALUES ('OPcion 1', 1, 2, 12);
INSERT INTO `Surveyed_Answer` VALUES ('gustavo?,', 1, 3, 13);
INSERT INTO `Surveyed_Answer` VALUES ('gustavo?,', 1, 3, 14);
INSERT INTO `Surveyed_Answer` VALUES ('¿gustavo?,', 1, 3, 15);
INSERT INTO `Surveyed_Answer` VALUES ('uhuh,', 1, 3, 16);
INSERT INTO `Surveyed_Answer` VALUES ('Opcion 2', 1, 2, 17);
INSERT INTO `Surveyed_Answer` VALUES ('Opcion 3', 1, 2, 18);
INSERT INTO `Surveyed_Answer` VALUES ('Opcion 2', 2, 2, 12);
INSERT INTO `Surveyed_Answer` VALUES ('OPcion 3', 2, 2, 17);
INSERT INTO `Surveyed_Answer` VALUES ('OPcion 3', 2, 2, 18);
INSERT INTO `Surveyed_Answer` VALUES ('jiojofjerjfij', 3, 2, 12);
INSERT INTO `Surveyed_Answer` VALUES ('2022-02-08', 3, 2, 17);
INSERT INTO `Surveyed_Answer` VALUES ('2022-02-05', 3, 2, 18);

-- ----------------------------
-- Table structure for User
-- ----------------------------
DROP TABLE IF EXISTS `User`;
CREATE TABLE `User`  (
  `ID_User` int(11) NOT NULL AUTO_INCREMENT,
  `Name` char(20) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `LastName` char(20) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `Email` char(20) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `Gender` char(20) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  PRIMARY KEY (`ID_User`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of User
-- ----------------------------
INSERT INTO `User` VALUES (1, 'Guss', 'Gutierrez', 'gus@gmail.com', 'M');

SET FOREIGN_KEY_CHECKS = 1;
