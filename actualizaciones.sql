
ALTER TABLE `survea`.`question` 
ADD COLUMN `Order` int NOT NULL AFTER `ID_User`;

ALTER TABLE `survea`.`answer` 
ADD COLUMN `Order` int NOT NULL DEFAULT 0 AFTER `ID_User`;

ALTER TABLE `survea`.`question` 
ADD COLUMN `Description` varchar(255) NULL AFTER `Order`;