/*!40101 SET NAMES utf8 */;
/*!40014 SET FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/ deliverys_api_db /*!40100 DEFAULT CHARACTER SET utf8mb4 */;
USE deliverys_api_db;

DROP TABLE IF EXISTS articulos;
CREATE TABLE `articulos` (
  `paquete_id` int(10) unsigned NOT NULL,
  `descripcion` varchar(50) NOT NULL DEFAULT '',
  `cantidad` int(10) unsigned NOT NULL,
  PRIMARY KEY (`descripcion`,`paquete_id`),
  KEY `paquete_contiene` (`paquete_id`),
  CONSTRAINT `paquete_contiene` FOREIGN KEY (`paquete_id`) REFERENCES `paquetes` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS clientes;
CREATE TABLE `clientes` (
  `id` varchar(9) NOT NULL,
  `email` varchar(40) NOT NULL,
  `password` varchar(255) NOT NULL,
  `saldo` decimal(14,3) unsigned NOT NULL DEFAULT 0.000,
  `nombre` varchar(16) NOT NULL,
  `apellido` varchar(16) NOT NULL,
  `telefono` varchar(11) NOT NULL,
  `alt_telefono` varchar(11) DEFAULT NULL,
  `direccion_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_email_clientes` (`email`),
  KEY `direccion_cliente` (`direccion_id`),
  CONSTRAINT `direccion_cliente` FOREIGN KEY (`direccion_id`) REFERENCES `direcciones` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `CHK_telefono_clientes` CHECK (`telefono` regexp '^[0-9].*'),
  CONSTRAINT `CHK_nombre_apellido_clientes` CHECK (`nombre` <> '' and `apellido` <> ''),
  CONSTRAINT `CHK_email_clientes` CHECK (`email` regexp '^[a-zA-Z0-9.!#$%&\'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:.[a-zA-Z0-9-]+)*$')
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS direcciones;
CREATE TABLE `direcciones` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_pais` int(11) NOT NULL,
  `estado` varchar(20) NOT NULL,
  `ciudad` varchar(20) NOT NULL,
  `parroquia` varchar(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `direccion_unica` (`id_pais`,`estado`,`ciudad`,`parroquia`),
  CONSTRAINT `fk_direcciones_paises` FOREIGN KEY (`id_pais`) REFERENCES `paises` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS encomiendas;
CREATE TABLE `encomiendas` (
  `id` varchar(7) NOT NULL,
  `tipo` varchar(15) NOT NULL DEFAULT '',
  `fh_salida` datetime DEFAULT NULL,
  `fh_llegada` datetime DEFAULT NULL,
  `estado` varchar(15) DEFAULT NULL,
  `nucleo_id` int(10) unsigned NOT NULL,
  `nucleo_rec_id` int(10) unsigned DEFAULT NULL,
  `transportista_id` varchar(9) DEFAULT NULL,
  `vehiculo_id` varchar(8) DEFAULT NULL,
  `cliente_env_id` varchar(9) NOT NULL,
  `cliente_rec_id` varchar(9) NOT NULL,
  `precio` decimal(14,2) NOT NULL DEFAULT 0.00,
  PRIMARY KEY (`id`),
  KEY `cliente_envia` (`cliente_env_id`),
  KEY `cliente_recibe` (`cliente_rec_id`),
  KEY `fk_transportista_vehiculo` (`vehiculo_id`),
  KEY `fk_transportista_id` (`transportista_id`),
  KEY `fk_nucleo_id` (`nucleo_id`),
  KEY `fk_nucleo_rec_id` (`nucleo_rec_id`),
  CONSTRAINT `cliente_envia` FOREIGN KEY (`cliente_env_id`) REFERENCES `clientes` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `cliente_recibe` FOREIGN KEY (`cliente_rec_id`) REFERENCES `clientes` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `fk_nucleo_id` FOREIGN KEY (`nucleo_id`) REFERENCES `nucleos` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `fk_nucleo_rec_id` FOREIGN KEY (`nucleo_rec_id`) REFERENCES `nucleos` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `fk_transportista_id` FOREIGN KEY (`transportista_id`) REFERENCES `transportistas` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `fk_transportista_vehiculo` FOREIGN KEY (`vehiculo_id`) REFERENCES `vehiculos` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `CHK_fechas_encomiendas` CHECK (`fh_llegada` is null or `fh_llegada` >= `fh_salida`),
  CONSTRAINT `CHK_clientes_encomiendas` CHECK (`cliente_env_id` <> `cliente_rec_id`),
  CONSTRAINT `CHK_estado_encomiendas` CHECK (`estado` in ('en espera','en progreso','culminada','en custodia','cancelada')),
  CONSTRAINT `CHK_nucleos_encomiendas` CHECK (!(`nucleo_id` <=> `nucleo_rec_id`)),
  CONSTRAINT `CHK_tipo_encomiendas` CHECK (`tipo` in ('normal','extendida')),
  CONSTRAINT `CHK_jerarquia_encomiendas` CHECK (`tipo` = 'normal' and `nucleo_rec_id` is null or `tipo` = 'extendida' and `nucleo_rec_id` is not null and `transportista_id` is null and `vehiculo_id` is null)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS historico_clientes;
CREATE TABLE `historico_clientes` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `cliente_id` varchar(9) NOT NULL,
  `fecha` datetime NOT NULL,
  `valor` decimal(14,3) NOT NULL,
  `saldo_final` decimal(14,3) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_cliente_historico` (`cliente_id`),
  CONSTRAINT `fk_cliente_historico` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS historico_transportistas;
CREATE TABLE `historico_transportistas` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `transportista_id` varchar(9) NOT NULL,
  `fecha` datetime NOT NULL,
  `valor` decimal(14,3) NOT NULL,
  `saldo_final` decimal(14,3) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_transportistas_historico` (`transportista_id`),
  CONSTRAINT `fk_transportistas_historico` FOREIGN KEY (`transportista_id`) REFERENCES `transportistas` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS invitaciones;
CREATE TABLE `invitaciones` (
  `transportista_id` varchar(9) NOT NULL,
  `encomienda_id` varchar(7) NOT NULL,
  `estado` varchar(15) DEFAULT NULL,
  `fecha_hora` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`transportista_id`,`encomienda_id`),
  KEY `fk_invitaciones_encomienda_id` (`encomienda_id`),
  CONSTRAINT `fk_invitaciones_encomienda_id` FOREIGN KEY (`encomienda_id`) REFERENCES `encomiendas` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `fk_invitaciones_transportistas_id` FOREIGN KEY (`transportista_id`) REFERENCES `transportistas` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS nucleos;
CREATE TABLE `nucleos` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `direccion_id` int(10) unsigned NOT NULL,
  `nombre` varchar(255) NOT NULL,
  `telefono` varchar(11) NOT NULL,
  `com_vuelo` decimal(5,4) unsigned NOT NULL,
  `com_vehiculo_motor` decimal(5,4) unsigned NOT NULL,
  `com_bicicleta` decimal(5,4) unsigned NOT NULL,
  `precio_por_kg` decimal(10,3) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `direccion_nucleo` (`direccion_id`),
  CONSTRAINT `direccion_nucleo` FOREIGN KEY (`direccion_id`) REFERENCES `direcciones` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS paises;
CREATE TABLE `paises` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pais` varchar(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS paquetes;
CREATE TABLE `paquetes` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `peso` decimal(10,3) unsigned NOT NULL COMMENT 'gramos\r\n',
  `alto` decimal(6,2) unsigned NOT NULL COMMENT 'cm',
  `ancho` decimal(6,2) unsigned NOT NULL COMMENT 'cm',
  `largo` decimal(6,2) unsigned NOT NULL COMMENT 'cm',
  `fragil` tinyint(1) NOT NULL,
  `encomienda_id` varchar(7) NOT NULL,
  `precio` decimal(14,2) NOT NULL DEFAULT 0.00,
  PRIMARY KEY (`id`),
  KEY `fk_paquete_encomiendas` (`encomienda_id`),
  CONSTRAINT `fk_paquete_encomiendas` FOREIGN KEY (`encomienda_id`) REFERENCES `encomiendas` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `CHK_fragilidad_paquetes` CHECK (`fragil` in (1,0))
) ENGINE=InnoDB AUTO_INCREMENT=120 DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS recorridos;
CREATE TABLE `recorridos` (
  `id` int(10) unsigned NOT NULL,
  `encomienda_id` varchar(7) NOT NULL,
  `nucleo_org_id` int(10) unsigned NOT NULL,
  `nucleo_des_id` int(10) unsigned NOT NULL,
  `estado` varchar(10) NOT NULL DEFAULT 'abierto',
  `transportista_id` varchar(9) DEFAULT NULL,
  PRIMARY KEY (`id`,`encomienda_id`) USING BTREE,
  KEY `fk_recorridos_transportista_id` (`transportista_id`),
  KEY `fk_recorridos_nucleo_org_id` (`nucleo_org_id`),
  KEY `fk_recorridos_nucleo_des_id` (`nucleo_des_id`),
  KEY `fk_recorridos_encomienda_id` (`encomienda_id`),
  CONSTRAINT `fk_recorridos_encomienda_id` FOREIGN KEY (`encomienda_id`) REFERENCES `encomiendas` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_recorridos_nucleo_des_id` FOREIGN KEY (`nucleo_des_id`) REFERENCES `nucleos` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `fk_recorridos_nucleo_org_id` FOREIGN KEY (`nucleo_org_id`) REFERENCES `nucleos` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `fk_recorridos_transportista_id` FOREIGN KEY (`transportista_id`) REFERENCES `transportistas` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `CHK_estados_recorridos` CHECK (`estado` in ('abierto','cerrado','culminado')),
  CONSTRAINT `CHK_nucleos_recorrido` CHECK (`nucleo_org_id` <> `nucleo_des_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS transportistas;
CREATE TABLE `transportistas` (
  `id` varchar(9) NOT NULL,
  `nombre` varchar(16) NOT NULL,
  `apellido` varchar(16) NOT NULL,
  `telefono` varchar(11) NOT NULL,
  `alt_telefono` varchar(11) DEFAULT NULL,
  `email` varchar(40) NOT NULL,
  `password` varchar(255) NOT NULL,
  `saldo` decimal(14,3) unsigned NOT NULL DEFAULT 0.000,
  `licencia` varchar(12) DEFAULT NULL,
  `fecha_ingreso` date NOT NULL,
  `disponibilidad` tinyint(1) NOT NULL DEFAULT 0,
  `curso_aprobado` tinyint(1) NOT NULL DEFAULT 0,
  `f_curso` date DEFAULT NULL,
  `antecedentes` tinyint(1) NOT NULL,
  `direccion_id` int(10) unsigned NOT NULL,
  `nucleo_id` int(255) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_email_transportistas` (`email`) USING BTREE,
  UNIQUE KEY `idx_licencia_transportistas` (`licencia`) USING BTREE,
  KEY `direccion_transportador` (`direccion_id`),
  KEY `asociado_a` (`nucleo_id`),
  CONSTRAINT `asociado_a` FOREIGN KEY (`nucleo_id`) REFERENCES `nucleos` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `direccion_transportador` FOREIGN KEY (`direccion_id`) REFERENCES `direcciones` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `CHK_disponibilidad_transportistas` CHECK (`disponibilidad` in (1,0)),
  CONSTRAINT `CHK_capacitacion_transportistas` CHECK (`curso_aprobado` = 0 and `disponibilidad` = 0 or `curso_aprobado` = 1 and `disponibilidad` in (1,0)),
  CONSTRAINT `CHK_antecedentes_transportistas` CHECK (`antecedentes` in (1,0)),
  CONSTRAINT `CHK_nombre_apellido_transportistas` CHECK (`nombre` <> '' and `apellido` <> ''),
  CONSTRAINT `CHK_email_transportistas` CHECK (`email` regexp '^[a-zA-Z0-9.!#$%&\'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:.[a-zA-Z0-9-]+)*$')
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS vehiculos;
CREATE TABLE `vehiculos` (
  `id` varchar(8) NOT NULL COMMENT 'placa',
  `transportista_id` varchar(9) NOT NULL,
  `modelo` varchar(20) NOT NULL,
  `marca` varchar(13) NOT NULL,
  `color` varchar(20) NOT NULL,
  `tipo` varchar(15) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `transportista_vehiculo` (`transportista_id`),
  CONSTRAINT `transportista_vehiculo` FOREIGN KEY (`transportista_id`) REFERENCES `transportistas` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `CHK_tipo_vehiculos` CHECK (`tipo` in ('motor','bicicleta'))
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS vuelos;
CREATE TABLE `vuelos` (
  `id` varchar(8) NOT NULL,
  `tiempo_retraso` time DEFAULT NULL,
  `descripcion_retraso` varchar(100) DEFAULT NULL,
  `tiempo_estimado` time NOT NULL,
  `fh_salida` datetime NOT NULL,
  `fh_llegada` datetime DEFAULT NULL,
  `aerolinea` varchar(30) NOT NULL,
  `encomienda_id` varchar(7) NOT NULL,
  `recorrido_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_recorridos_encomienda_id_recorrido_id` (`encomienda_id`,`recorrido_id`),
  CONSTRAINT `fk_recorridos_encomienda_id_recorrido_id` FOREIGN KEY (`encomienda_id`, `recorrido_id`) REFERENCES `recorridos` (`encomienda_id`, `id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `CHK_fechas_vuelos` CHECK (`fh_llegada` is null or `fh_llegada` >= `fh_salida`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE OR REPLACE VIEW `vw_clientes_for_transportistas` AS select `e`.`id` AS `encomienda`,`c`.`id` AS `id`,`c`.`email` AS `email`,`c`.`nombre` AS `nombre`,`c`.`apellido` AS `apellido`,`c`.`telefono` AS `telefono`,`c`.`alt_telefono` AS `alt_telefono`,`c`.`direccion_id` AS `direccion_id`,case `c`.`id` when `e`.`cliente_env_id` then 'origen' else 'destino' end AS `tipo` from (`clientes` `c` join `encomiendas` `e` on(`c`.`id` = `e`.`cliente_env_id` or `c`.`id` = `e`.`cliente_rec_id`));

CREATE OR REPLACE VIEW `vw_transportistas_for_clientes` AS select `e`.`id` AS `encomienda`,`t`.`id` AS `id`,`t`.`email` AS `email`,`t`.`nombre` AS `nombre`,`t`.`apellido` AS `apellido`,`t`.`telefono` AS `telefono`,`t`.`alt_telefono` AS `alt_telefono`,`t`.`direccion_id` AS `direccion_id`,`t`.`nucleo_id` AS `nucleo_id` from (`transportistas` `t` join `encomiendas` `e` on(`e`.`transportista_id` = `t`.`id`)) union select `r`.`encomienda_id` AS `encomienda`,`t`.`id` AS `id`,`t`.`email` AS `email`,`t`.`nombre` AS `nombre`,`t`.`apellido` AS `apellido`,`t`.`telefono` AS `telefono`,`t`.`alt_telefono` AS `alt_telefono`,`t`.`direccion_id` AS `direccion_id`,`t`.`nucleo_id` AS `nucleo_id` from (`transportistas` `t` join `recorridos` `r` on(`r`.`transportista_id` = `t`.`id`));

INSERT INTO articulos(paquete_id,descripcion,cantidad) VALUES(65,'arroz',2),(80,'arroz',2),(101,'arroz',2),(109,'arroz',1),(111,'arroz',2),(114,'arroz',2),(116,'arroz',2),(118,'arroz',2),(83,'coca-cola',4),(85,'coca-cola',4),(104,'coca-cola',4),(90,'computadora',7),(93,'computadora',7),(96,'computadora',7),(66,'harina',5),(81,'harina',5),(102,'harina',5),(110,'harina',2),(115,'harina',5),(117,'harina',5),(119,'harina',5),(91,'impresoras',2),(94,'impresoras',2),(97,'impresoras',2),(83,'kolita',5),(85,'kolita',5),(104,'kolita',5),(82,'malta',1),(84,'malta',1),(103,'malta',1),(106,'malta',1),(107,'malta',1),(108,'malta',1),(66,'margarina',4),(81,'margarina',4),(102,'margarina',4),(110,'margarina',4),(112,'margarina',4),(115,'margarina',4),(117,'margarina',4),(119,'margarina',4),(91,'medicamentos',3),(94,'medicamentos',3),(97,'medicamentos',3),(65,'pasta',1),(80,'pasta',1),(101,'pasta',1),(109,'pasta',1),(111,'pasta',1),(114,'pasta',1),(116,'pasta',1),(118,'pasta',1),(82,'pepsi',2),(84,'pepsi',2),(103,'pepsi',2),(106,'pepsi',2),(107,'pepsi',2),(108,'pepsi',2),(89,'pollo frito',2),(92,'pollo frito',2),(95,'pollo frito',2),(89,'shampoo',10),(92,'shampoo',10),(95,'shampoo',10),(90,'telefono',2),(93,'telefono',2),(96,'telefono',2);

INSERT INTO clientes(id,email,password,saldo,nombre,apellido,telefono,alt_telefono,direccion_id) VALUES('27123447','dsumoza@gmail.com','sadaskjadhka',143.400,'David','Sumoza','04265971258',NULL,2),('27506123','wslayford0@geocities.com','zqOtbIRW2',0.000,'Otcom','Squier','04141234555',NULL,1),('27506980','jags@gmail.com','123',191.900,'Jesus','Gutierrez','04120899879',NULL,1),('27506981','jags2@gmail.com','123',400.000,'Jesus','Gutierrez','04120899879',NULL,1),('27506984','guss@gmail.com','1234',50.000,'Gustavo','Gutierrez','04129531428',NULL,2),('27506989','jags5@gmail.com','123',0.000,'Jesus','Gutierrez','04120899879',NULL,1),('27506999','jags9@gmail.com','123',0.000,'Jesus','Gutierrez','04120899879',NULL,1),('27729212','josemsaad13@gmail.com','dadasd2112323ddasdas',60.200,'Jose','Saad','04249215674',NULL,2),('27765316','vanessxdl@gmail.com','dsdadasdasdasdasdas',0.000,'Vanessa','Lozano','04249338629',NULL,1),('27806888','jags27@gmail.com','123',0.000,'Jesus','Gonzalez','04120899879',NULL,1),('28301458','johanadrex@gmail.com','uhasduhasdjbkasdkjbadsas',5005.000,'Johana','Dominguez','04249331254','04148521426',2),('28471236','charlyghass@gmail.com','32u381naskjdmka',0.000,'Charly','Ghassibe','04249123347',NULL,2),('29045314','viclo@gmail.com','sadsadasasdsad',0.000,'Victoria','Lopez','04126974123',NULL,1),('30015336','diegoooalc@gmail.com','ddsadadaskldasklndas',0.000,'Diego','Alcala','04162632721','04249531526',1),('30453753','miguelanggelo21@gmail.com','fdujhbqiudszsujnajdnawsdas',26.800,'Miguelanggelo','Sumoza','04249125727',NULL,1),('9951411','homero@gmail.com','1234',0.000,'Homero','Gutierrez','04120899879',NULL,1),('C03004786','alexmurra@hotmail.com','kljsdadjsalmd2283dadad',0.000,'Alex','Murray','1zzzzzzz',NULL,5);

INSERT INTO direcciones(id,id_pais,estado,ciudad,parroquia) VALUES(5,1,'Nevada','Las Vegas','Clark'),(4,2,'Bolivar','El Callao','El Callao'),(14,2,'Bolivar','Guayana','Cachamay'),(6,2,'Bolivar','Guayana','Caroni'),(1,2,'Bolivar','Guayana','Unare'),(2,2,'Bolivar','Guayana','Vista al Sol');

INSERT INTO encomiendas(id,tipo,fh_salida,fh_llegada,estado,nucleo_id,nucleo_rec_id,transportista_id,vehiculo_id,cliente_env_id,cliente_rec_id,precio) VALUES('0000000','normal',NULL,NULL,'en progreso',1,NULL,'28123999','AB622FE','27123447','27729212',1.00),('0000001','normal','2021-12-13 14:09:18','2021-12-16 14:09:18','culminada',4,NULL,'J48573221',NULL,'27729212','C03004786',3.00),('0000002','extendida',NULL,NULL,NULL,1,2,NULL,NULL,'27123447','27506984',0.00),('0000003','normal','2021-12-14 14:09:18','2021-12-16 14:09:18','en progreso',2,NULL,'29412369',NULL,'29045314','28471236',4.00),('0000004','normal','2021-12-11 14:09:18','2021-12-11 18:09:18','culminada',2,NULL,'J48573221',NULL,'27765316','30453753',1.00),('0000005','normal','2021-11-01 14:39:40','2021-11-16 17:00:47','en progreso',4,NULL,'29412369',NULL,'30453753','27506984',1.00),('0000006','normal','2022-02-13 07:55:37','2022-02-13 17:34:59','culminada',1,NULL,'28777156','BC123AC','27506980','27123447',0.00),('0000007','extendida',NULL,NULL,'en espera',5,1,NULL,NULL,'27123447','27729212',0.00),('0000008','normal',NULL,NULL,NULL,1,NULL,NULL,NULL,'27123447','27506980',0.00),('0000009','normal','2022-02-14 02:37:33','2022-02-14 02:37:49','culminada',1,NULL,'28123999','A56VDA','27506980','27123447',0.00),('000000A','extendida','2022-02-14 02:50:22','2022-02-14 03:35:08','culminada',2,5,NULL,NULL,'27506980','27123447',0.00),('000000B','extendida',NULL,NULL,'en espera',1,5,NULL,NULL,'27506980','27123447',0.00),('000000C','normal',NULL,NULL,NULL,1,NULL,NULL,'A56VDA','27729212','29045314',0.00),('000000D','normal',NULL,NULL,NULL,1,NULL,NULL,'A56VDA','27729212','29045314',0.00),('000000E','normal',NULL,NULL,NULL,1,NULL,NULL,'A56VDA','27729212','29045314',0.00),('000000F','normal','2022-02-14 21:07:10','2022-02-14 21:10:54','culminada',1,NULL,'28123999','A33315','27729212','27506123',1.80),('0000010','extendida','2022-02-14 21:20:51','2022-02-14 21:27:57','culminada',1,5,NULL,NULL,'30453753','27765316',3.20),('0000011','extendida',NULL,NULL,'en espera',1,2,NULL,NULL,'27506980','9951411',0.00),('0000012','extendida',NULL,NULL,'en espera',1,2,NULL,NULL,'27506980','9951411',0.00),('0000013','extendida',NULL,NULL,'en espera',1,2,NULL,NULL,'27506980','9951411',0.00),('0000014','normal','2022-02-17 15:19:48','2022-02-17 15:20:33','culminada',1,NULL,'27506981','JFEI40','28301458','27806888',3.00),('0000015','extendida','2022-02-17 15:38:27','2022-02-17 15:57:57','culminada',1,5,NULL,NULL,'28301458','27806888',1.80),('0000016','normal','2022-02-17 16:35:17',NULL,'en progreso',1,NULL,'27506981','JFEI40','27506980','27123447',0.00),('0000017','normal',NULL,NULL,'en espera',1,NULL,NULL,NULL,'27506980','27123447',0.00),('0000018','normal','2022-02-17 17:37:34','2022-02-17 17:38:29','culminada',1,NULL,'27506981','JFEI40','27506123','27123447',1.80);

INSERT INTO historico_clientes(id,cliente_id,fecha,valor,saldo_final) VALUES(1,'30453753','2022-02-12 18:45:45',20.000,30.000),(2,'27506984','2022-02-13 05:30:02',10.000,10.000),(3,'27506984','2022-02-13 05:33:50',10.000,20.000),(4,'27506984','2022-02-13 05:34:20',10.000,30.000),(5,'27506984','2022-02-13 05:34:48',10.000,40.000),(6,'27506984','2022-02-13 05:36:44',10.000,50.000),(7,'27506980','2022-02-13 07:55:30',200.000,200.000),(8,'27506980','2022-02-13 07:55:37',-1.800,198.200),(9,'27506981','2022-02-13 22:53:44',100.000,100.000),(10,'27506981','2022-02-13 23:00:19',100.000,200.000),(11,'27506981','2022-02-13 23:01:56',100.000,300.000),(12,'27506981','2022-02-13 23:02:21',100.000,400.000),(13,'27506981','2022-02-13 23:02:52',100.000,500.000),(14,'27506980','2022-02-14 02:29:07',-1.800,196.400),(15,'27506980','2022-02-14 02:37:33',-1.800,194.600),(16,'27506980','2022-02-14 02:50:22',-0.900,193.700),(17,'27729212','2022-02-14 21:07:10',-1.800,60.200),(18,'30453753','2022-02-14 21:20:51',-3.200,26.800),(19,'27806888','2022-02-17 14:03:31',50.000,50.000),(20,'27806888','2022-02-17 14:03:49',-50.000,0.000),(21,'27806888','2022-02-17 14:06:31',50.000,50.000),(22,'27806888','2022-02-17 14:28:35',-50.000,0.000),(23,'27506981','2022-02-17 15:26:30',100.000,600.000),(24,'27506981','2022-02-17 15:27:23',-200.000,400.000),(25,'28301458','2022-02-17 15:54:04',5005.000,5005.000),(26,'27506980','2022-02-17 16:35:17',-1.800,191.900),(27,'27506123','2022-02-17 17:24:32',1.700,1.700),(28,'27506123','2022-02-17 17:24:59',0.100,1.800),(29,'27506123','2022-02-17 17:37:34',-1.800,0.000);

INSERT INTO historico_transportistas(id,transportista_id,fecha,valor,saldo_final) VALUES(1,'27506984','2022-02-12 18:48:42',15.000,20.000),(2,'28123999','2022-02-13 01:13:04',-1.000,7.750),(3,'28123999','2022-02-13 01:13:16',-1.000,6.750),(4,'28777156','2022-02-13 08:08:25',0.180,0.180),(5,'28777156','2022-02-13 17:34:59',0.180,0.360),(6,'28123999','2022-02-14 02:37:49',0.360,7.110),(7,'J48573221','2022-02-14 03:19:02',-17.500,0.000),(8,'27506985','2022-02-14 03:20:02',0.315,0.315),(9,'29412369','2022-02-14 03:20:02',0.360,0.360),(10,'J48573221','2022-02-14 03:20:02',0.315,0.315),(11,'J48573221','2022-02-14 03:20:02',0.315,0.630),(12,'J48573221','2022-02-14 03:27:54',-0.630,0.000),(13,'29412369','2022-02-14 03:28:42',-0.360,0.000),(14,'27506985','2022-02-14 03:28:48',-0.315,0.000),(15,'27506985','2022-02-14 03:30:14',0.315,0.315),(16,'29412369','2022-02-14 03:30:14',0.360,0.360),(17,'J48573221','2022-02-14 03:30:14',0.315,0.315),(18,'J48573221','2022-02-14 03:30:14',0.315,0.630),(19,'27506985','2022-02-14 03:33:31',0.315,0.630),(20,'29412369','2022-02-14 03:33:31',0.360,0.720),(21,'J48573221','2022-02-14 03:33:31',0.315,0.945),(22,'27506985','2022-02-14 03:35:08',0.315,0.945),(23,'29412369','2022-02-14 03:35:08',0.360,1.080),(24,'J48573221','2022-02-14 03:35:08',0.315,1.260),(25,'27506984','2022-02-14 03:55:22',-10.000,10.000),(26,'27506984','2022-02-14 03:55:27',-10.000,0.000),(27,'28123999','2022-02-14 21:10:54',0.360,7.470),(28,'9951411','2022-02-14 21:27:57',1.120,1.120),(29,'29412369','2022-02-14 21:27:57',1.280,2.360),(30,'J48874112','2022-02-14 21:27:57',1.120,1.120),(31,'27506981','2022-02-17 15:20:33',0.600,0.600),(32,'27506929','2022-02-17 15:46:39',0.630,0.630),(33,'27506111','2022-02-17 15:46:39',0.540,0.540),(34,'27506929','2022-02-17 15:57:57',0.630,1.260),(35,'27506111','2022-02-17 15:57:57',0.540,1.080),(36,'27506981','2022-02-17 17:38:29',0.360,0.960);

INSERT INTO invitaciones(transportista_id,encomienda_id,estado,fecha_hora) VALUES('27506981','0000009','rechazada','2022-02-13 21:52:27'),('27506981','000000F','rechazada','2022-02-14 20:57:48'),('27506981','0000014','aceptada','2022-02-17 14:48:32'),('27506981','0000016','aceptada','2022-02-17 16:31:13'),('27506981','0000017',NULL,'2022-02-17 17:21:26'),('27506981','0000018','aceptada','2022-02-17 17:25:08'),('28123999','0000006','rechazada','2022-02-12 21:52:35'),('28123999','0000009','aceptada','2022-02-14 02:07:01'),('28123999','000000F','aceptada','2022-02-14 21:00:24'),('28777156','0000000','rechazada','2022-02-12 21:52:47'),('28777156','0000006','aceptada','2022-02-12 21:52:55'),('28777156','0000009','rechazada','2022-02-13 20:52:59'),('28777156','000000F','rechazada','2022-02-14 20:45:53'),('J48874112','0000005','rechazada','2022-02-12 21:53:05');

INSERT INTO nucleos(id,direccion_id,nombre,telefono,com_vuelo,com_vehiculo_motor,com_bicicleta,precio_por_kg) VALUES(1,1,' S&S Pto. Ordaz Unare','02869231487',0.3500,0.2000,0.1000,1.000),(2,4,' S&S El Callao Av. Guarapiche','02869231288',0.4000,0.1500,0.1000,0.500),(4,5,'DHL EXPRESS Las Vegas Sunset RD Suite','18002255345',0.3500,0.2500,0.1500,0.700),(5,6,'NUCLEO 6','12313213213',0.2000,0.1000,0.5000,1.000),(6,1,'Nuevo nucleo','04120899879',0.3000,0.3000,0.3000,1.000),(7,1,'Nuevo nucleo','04120899879',0.3000,0.3000,0.3000,1.000),(8,1,'Nuevo nucleo','04120899879',0.3000,0.3000,0.3000,1.000),(9,1,'Nuevo nucleo','04120899879',0.3000,0.3000,0.3000,1.000),(10,1,'Nuevo nucleo 3','04120899879',0.3000,0.3000,0.3000,1.000),(11,1,'Nuevo nucleo 10','04120899879',0.3000,0.3000,0.3000,1.000),(12,1,'Nuevo san Juan','04120899879',0.3000,0.3000,0.3000,1.000),(13,1,'Nuevo san GUSSSSS','04120899879',0.3000,0.3000,0.3000,1.000),(14,1,'LCOOOOOO','04120899879',0.3000,0.3000,0.3000,1.000),(15,1,'nucleo de san felixx','04141992921',0.3000,0.3000,0.3000,1.000),(18,4,'NUCLEO JESUS 2','04120899879',0.3000,0.3000,0.3000,2.000);

INSERT INTO paises(id,pais) VALUES(1,'Estados Unidos'),(2,'Venezuela'),(3,'Brasil'),(4,'Argentina'),(6,'Ukrania'),(7,'Bolivia'),(8,'España');

INSERT INTO paquetes(id,peso,alto,ancho,largo,fragil,encomienda_id,precio) VALUES(1,120.000,120.00,120.00,120.00,0,'0000001',0.00),(2,10.000,10.00,10.00,10.00,0,'0000003',0.00),(3,50.000,30.00,30.00,30.00,0,'0000005',0.00),(65,10.000,10.00,10.00,10.00,0,'0000006',0.00),(66,20.000,20.00,20.00,20.00,0,'0000006',0.00),(80,10.000,10.00,10.00,10.00,0,'0000009',0.00),(81,20.000,20.00,20.00,20.00,0,'0000009',0.00),(82,10.000,10.00,10.00,10.00,0,'000000A',0.00),(83,20.000,20.00,20.00,20.00,0,'000000A',0.00),(84,10.000,10.00,10.00,10.00,0,'000000B',0.00),(85,20.000,20.00,20.00,20.00,0,'000000B',0.00),(89,20.000,10.00,10.00,10.00,0,'000000C',0.00),(90,20.000,15.00,16.00,11.00,1,'000000C',0.00),(91,30.000,10.00,15.00,12.00,0,'000000C',0.00),(92,20.000,10.00,10.00,10.00,0,'000000D',0.00),(93,20.000,15.00,16.00,11.00,1,'000000D',0.00),(94,30.000,10.00,15.00,12.00,0,'000000D',0.00),(95,20.000,10.00,10.00,10.00,0,'000000E',0.00),(96,20.000,15.00,16.00,11.00,1,'000000E',0.00),(97,30.000,10.00,15.00,12.00,0,'000000E',0.00),(101,10.000,10.00,10.00,10.00,0,'000000F',0.20),(102,20.000,20.00,20.00,20.00,0,'000000F',1.60),(103,20.000,20.00,20.00,20.00,0,'0000010',1.60),(104,20.000,20.00,20.00,20.00,0,'0000010',1.60),(106,10.000,10.00,10.00,10.00,0,'0000011',0.00),(107,10.000,10.00,10.00,10.00,0,'0000012',0.00),(108,10.000,10.00,10.00,10.00,0,'0000013',0.00),(109,10.000,10.00,10.00,10.00,0,'0000014',0.20),(110,20.000,20.00,20.00,20.00,0,'0000014',1.60),(111,10.000,10.00,10.00,10.00,0,'0000015',0.20),(112,20.000,20.00,20.00,20.00,0,'0000015',1.60),(113,20.000,20.00,20.00,15.00,0,'0000014',1.20),(114,10.000,10.00,10.00,10.00,0,'0000016',0.00),(115,20.000,20.00,20.00,20.00,0,'0000016',0.00),(116,10.000,10.00,10.00,10.00,0,'0000017',0.00),(117,20.000,20.00,20.00,20.00,0,'0000017',0.00),(118,10.000,10.00,10.00,10.00,0,'0000018',0.20),(119,20.000,20.00,20.00,20.00,0,'0000018',1.60);

INSERT INTO recorridos(id,encomienda_id,nucleo_org_id,nucleo_des_id,estado,transportista_id) VALUES(0,'000000A',1,2,'culminado','27506985'),(0,'000000B',2,5,'abierto',NULL),(0,'0000010',1,2,'culminado','9951411'),(0,'0000011',1,2,'abierto',NULL),(0,'0000012',1,2,'abierto',NULL),(0,'0000013',1,2,'abierto',NULL),(0,'0000015',1,8,'culminado','27506929'),(1,'000000A',2,4,'culminado','29412369'),(1,'0000010',2,4,'culminado','29412369'),(1,'0000015',8,5,'culminado','27506111'),(2,'000000A',4,5,'culminado','J48573221'),(2,'0000010',4,5,'culminado','J48874112');

INSERT INTO transportistas(id,nombre,apellido,telefono,alt_telefono,email,password,saldo,licencia,fecha_ingreso,disponibilidad,curso_aprobado,f_curso,antecedentes,direccion_id,nucleo_id) VALUES('27506111','Jesus','Gutierrez','04120899879',NULL,'correo5@gmail.com','123',1.080,'ASFFEZ1','2022-02-17',0,1,'2022-02-17',0,1,8),('27506888','Jesus','Gutierrez','04120899879',NULL,'correo@gmail.com','123',0.000,'ASFFEF9','2022-02-17',0,0,NULL,0,1,1),('27506929','Redhold','Sholem','04120899951',NULL,'bsholem1@archive.org','4W2caIXd',1.260,'ASCCEF8','2022-02-14',0,1,'2022-02-14',0,1,1),('27506981','Jesus','Gutierrez','04120899879',NULL,'jags2@gmail.com','123',0.960,'ASFFEF8','2022-02-13',1,1,NULL,0,1,1),('27506984','Guss','Guti','45464645456',NULL,'guss@gmail.com','1234',0.000,'K454654458','2022-02-10',1,1,'2022-02-10',0,2,5),('27506985','Jesus','Gutierrez','04120899879',NULL,'jags@gmail.com','1234',0.945,NULL,'2022-02-13',0,1,'2022-02-14',0,1,1),('28123999','Freddy','Reyes','04120531528',NULL,'frezk@gmail.com','jihsfadssad8921dsaas2123',7.470,'210885054681','2021-12-15',1,1,'2022-02-08',1,1,1),('28777156','Carlos','Ternera','04241234451',NULL,'telnep@gmail.com','jihsfdhjsadisladoas2123',0.360,NULL,'2021-12-15',1,1,'2022-02-06',0,2,1),('29412369','Julian','Alcachofas','04125341274',NULL,'juanalco_1@gmail.com','jbhdasnsdnasduhasudhas8d212131dasd',2.360,'21020856327','2021-12-16',0,1,'2022-02-06',0,4,2),('9951411','Homero','Gutierrez','04120899879',NULL,'homero@gmail.com','1234',1.120,'AAAAAAA','2022-02-14',0,1,'2022-02-14',0,1,1),('J48573221','Alisson','Blossom','12123244152',NULL,'alibloss23@outlook.com','diojsadjas10129028',1.260,'K12345678','2021-12-16',0,1,'2022-02-06',0,5,4),('J48874112','Jhon','Lennon','12123255179',NULL,'jhonlennon27@gmail.com','badjas7982132d',1.120,'K12345679','2021-12-10',1,1,'2021-11-10',0,5,4);

INSERT INTO vehiculos(id,transportista_id,modelo,marca,color,tipo) VALUES('A33315','28123999','Explorer 2020','Toyota','Blanco','motor'),('A56VDA','28123999','Explorer 2020','Toyota','Blanco','motor'),('AB622FE','28123999','M1','BMW','Rojo','motor'),('AI41AD5','28123999','Explorer 2020','Toyota','Blanco','motor'),('BC123AC','28777156','Urbana','Scott','Gris','bicicleta'),('DE947KD','29412369','166','Ferrari','Azul','motor'),('FEFWEF','27506985','FFEF','FEFE','FEFEF','bicicleta'),('GGGGG','27506984','Explorer','Toyota','Rojo','motor'),('JFEI40','27506981','x','y','n','motor'),('JFEI45','27506984','convertible','toyota','negro','motor'),('JFEI48','27506984','convertible','toyota','negro','motor'),('JFEI49','27506111','convertible','toyota','negro','motor');DROP PROCEDURE IF EXISTS sp_aceptar_invitacion;
CREATE PROCEDURE `sp_aceptar_invitacion`(
	_encomienda_id VARCHAR(7),
	_transportista_id VARCHAR(9),
	_vehiculo_id VARCHAR(8)
)
BEGIN

	IF _vehiculo_id <=> NULL THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = '(sp_aceptar_invitacion) Error: vehiculo no puede ser NULL';
	END IF;
	IF !EXISTS(SELECT *
			FROM invitaciones
			WHERE transportista_id = _transportista_id
			AND encomienda_id = _encomienda_id) THEN
			
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = '(sp_aceptar_invitacion) Error: la invitacion no existe';
	END IF;
	IF !(
		SELECT _vehiculo_id IN (
			SELECT id
			FROM vehiculos
			WHERE transportista_id = _transportista_id
		)
	) THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = '(sp_aceptar_invitacion) Error: el vehiculo no pertenece al transportista';
	END IF;
	UPDATE encomiendas
	SET transportista_id = _transportista_id,
		vehiculo_id = _vehiculo_id
	WHERE id = _encomienda_id;
	UPDATE invitaciones
	SET estado = 'aceptada'
	WHERE transportista_id = _transportista_id
	AND encomienda_id = _encomienda_id;
END;

DROP PROCEDURE IF EXISTS sp_aceptar_recorrido;
CREATE PROCEDURE `sp_aceptar_recorrido`(
    _encomienda_id VARCHAR(7),
    _recorrido_id INT(10),
    _transportista_id VARCHAR(9),
    _nucleo_des_id INT(10)
)
BEGIN

    IF (
        SELECT estado <> 'abierto'
        FROM recorridos
        WHERE encomienda_id = _encomienda_id
        AND id = _recorrido_id
    )
    THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = '(sp_aceptar_recorrido) Error: el recorrido no esta disponible';
    END IF;
    IF !(
        SELECT curso_aprobado
        FROM transportistas
        WHERE id =  _transportista_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = '(sp_aceptar_recorrido) Error: el transportista no ha aprobado el curso';
    END IF;
    UPDATE recorridos
        SET transportista_id = _transportista_id,
            nucleo_des_id = _nucleo_des_id,
            estado = 'cerrado'
        WHERE encomienda_id = _encomienda_id
        AND id = _recorrido_id;
    IF (
        SELECT estado
        FROM encomiendas
        WHERE id = _encomienda_id
    ) = 'en espera'
    THEN
        CALL sp_update_estado(_encomienda_id, _transportista_id, NULL);
    END IF;
END;

DROP PROCEDURE IF EXISTS sp_agregar_vehiculo;
CREATE PROCEDURE `sp_agregar_vehiculo`(
  IN id VARCHAR(8),
  IN transportista_id VARCHAR(9),
  IN modelo VARCHAR(20),
  IN marca VARCHAR(13),
  IN color VARCHAR(20),
  IN tipo VARCHAR(15)
)
BEGIN
	IF tipo = "motor" THEN
		SET @licencia = (SELECT licencia FROM transportistas t WHERE t.id = transportista_id);
		IF ISNULL(@licencia) THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El transportista no posee licencia registrada, por lo que no se podrá registrar un vehiculo a motor';
		END IF;
	END IF;
	INSERT INTO vehiculos VALUES(id, transportista_id, modelo, marca, color, tipo);
	SELECT * FROM vehiculos v WHERE v.id = id;
END;

DROP PROCEDURE IF EXISTS sp_cambiar_disponibilidad;
CREATE PROCEDURE `sp_cambiar_disponibilidad`(
  IN transportista_id VARCHAR(9),
  IN new_disp TINYINT(1)
)
BEGIN
		DECLARE licencia VARCHAR(12);
		SET @disp = (SELECT disponibilidad FROM transportistas WHERE id = transportista_id);
		IF ISNULL(@disp) THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El transportista que ingresó no existe';
		END IF;
		IF @disp = new_disp THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Usted ingresó la misma disponibilidad, por lo que no hubo cambios';
		END IF;
    IF new_disp = FALSE THEN
			UPDATE transportistas SET disponibilidad = FALSE WHERE id = transportista_id;
    ELSE
			IF (SELECT COUNT(*) FROM vehiculos v WHERE v.transportista_id = transportista_id) = 0 THEN
					SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transportista no posee vehiculos asociados';
			END IF;
			IF (SELECT NOT t.curso_aprobado FROM transportistas t WHERE t.id = transportista_id) THEN
					SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transportista debe haber completado el curso';
			END IF;
			UPDATE transportistas SET disponibilidad = true WHERE id = transportista_id;
    END IF;
END;

DROP PROCEDURE IF EXISTS sp_cobrar_encomienda_cliente;
CREATE PROCEDURE `sp_cobrar_encomienda_cliente`(
	encomienda VARCHAR(7)
)
BEGIN

	IF (
		SELECT c.saldo < sf_calcular_costo_encomienda(encomienda)
			FROM encomiendas e
			INNER JOIN clientes c ON c.id = e.cliente_env_id
			WHERE e.id = encomienda
	) THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = '(sp_solicitar_encomienda) Error: el cliente no posee saldo suficiente';
	END IF;

	UPDATE clientes c
	SET c.saldo = c.saldo - sf_calcular_costo_encomienda(encomienda)
	WHERE id = (SELECT cliente_env_id
					FROM encomiendas
					WHERE id = encomienda);
END;

DROP PROCEDURE IF EXISTS sp_enviar_invitacion;
CREATE PROCEDURE `sp_enviar_invitacion`(
	_encomienda_id VARCHAR(7)
)
BEGIN

	DECLARE random INT;
	DECLARE total INT;
	DECLARE finished INTEGER DEFAULT 0;
	DECLARE i INTEGER DEFAULT 0;
	DECLARE _transportista_id VARCHAR(9);
	DEClARE curTransportista CURSOR FOR 
			SELECT t.id
			FROM transportistas t
			LEFT JOIN invitaciones i ON	i.transportista_id = t.id
				AND i.encomienda_id = _encomienda_id
			WHERE i.encomienda_id IS NULL
			AND t.nucleo_id = (SELECT nucleo_id 
								FROM encomiendas
								WHERE id = _encomienda_id)
			AND t.disponibilidad;
	DECLARE CONTINUE HANDLER 
        FOR NOT FOUND SET finished = 1;
	SELECT COUNT(t.id)
		INTO total
		FROM transportistas t
		LEFT JOIN invitaciones i ON	i.transportista_id = t.id
			AND i.encomienda_id = _encomienda_id
		WHERE i.encomienda_id IS NULL
		AND t.nucleo_id = (SELECT nucleo_id 
							FROM encomiendas
							WHERE id = _encomienda_id)
		AND t.disponibilidad;
	IF total = 0 THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = '(sp_enviar_invitacion) Error: no hay transportistas disponibles';
	END IF;
	SET random = FLOOR(RAND() * total);
	OPEN curTransportista;
	WHILE i <= random DO
		FETCH curTransportista INTO _transportista_id;
		SET i = i + 1;
	END WHILE;
	CLOSE curTransportista;
	INSERT INTO invitaciones(transportista_id, encomienda_id, fecha_hora) 
		VALUES(_transportista_id, _encomienda_id, NOW());
END;

DROP PROCEDURE IF EXISTS sp_pagar_encomienda_extendida_transportistas;
CREATE PROCEDURE `sp_pagar_encomienda_extendida_transportistas`(
	_encomienda_id VARCHAR(7)
)
BEGIN
	DECLARE _transportista_id VARCHAR(9);
	DECLARE finished INTEGER DEFAULT 0;
	DECLARE comision FLOAT(255,2);
	DECLARE curTransportista CURSOR FOR 
			SELECT transportista_id
			FROM recorridos
			WHERE encomienda_id = _encomienda_id;
	DECLARE CONTINUE HANDLER 
        FOR NOT FOUND SET finished = 1;
	OPEN curTransportista;
	FETCH curTransportista INTO _transportista_id;
	WHILE !finished DO
		SELECT n.com_vuelo
		INTO comision
		FROM transportistas t
		INNER JOIN nucleos n ON n.id = t.nucleo_id
		WHERE t.id = _transportista_id;
		UPDATE transportistas t
		SET t.saldo = t.saldo + sf_calcular_costo_encomienda(_encomienda_id) 
			* comision
		WHERE id = _transportista_id;
		FETCH curTransportista INTO _transportista_id;
	END WHILE;
	CLOSE curTransportista;
END;

DROP PROCEDURE IF EXISTS sp_pagar_encomienda_transportista;
CREATE PROCEDURE `sp_pagar_encomienda_transportista`(
	encomienda VARCHAR(7)
)
BEGIN
	
	DECLARE tipo_vehiculo VARCHAR(15);
	DECLARE comision FLOAT(255,2);
	
	SELECT v.tipo
	INTO tipo_vehiculo
	FROM encomiendas e
	INNER JOIN vehiculos v ON v.id = e.vehiculo_id
	WHERE e.id = encomienda;
	
	CASE tipo_vehiculo
		WHEN 'motor' THEN
			SELECT n.com_vehiculo_motor
			INTO comision
			FROM encomiendas e
			INNER JOIN nucleos n ON n.id = e.nucleo_id
			WHERE e.id = encomienda;
			
		WHEN 'bicicleta' THEN
			SELECT n.com_bicicleta
			INTO comision
			FROM encomiendas e
			INNER JOIN nucleos n ON n.id = e.nucleo_id
			WHERE e.id = encomienda;
			
	END CASE;


	UPDATE transportistas t
	SET t.saldo = t.saldo + sf_calcular_costo_encomienda(encomienda) 
		* comision
	WHERE id = (SELECT transportista_id
					FROM encomiendas
					WHERE id = encomienda);
END;

DROP PROCEDURE IF EXISTS sp_rechazar_invitacion;
CREATE PROCEDURE `sp_rechazar_invitacion`(_encomienda_id VARCHAR(7),
	_transportista_id VARCHAR(9))
BEGIN
	
	IF !EXISTS(SELECT *
			FROM invitaciones
			WHERE transportista_id = _transportista_id
			AND encomienda_id = _encomienda_id) THEN
			
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = '(sp_rechazar_invitacion) Error: la invitacion no existe';
	END IF;
	UPDATE invitaciones
	SET estado = 'rechazada'
	WHERE transportista_id = _transportista_id
	AND encomienda_id = _encomienda_id;
	CALL sp_enviar_invitacion(_encomienda_id);
END;

DROP PROCEDURE IF EXISTS sp_solicitar_encomienda;
CREATE PROCEDURE `sp_solicitar_encomienda`(
	encomienda VARCHAR(7)
)
BEGIN

	IF (
		SELECT COUNT(*) = 0
		FROM paquetes
		WHERE encomienda_id = encomienda
	) THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = '(sp_solicitar_encomienda) Error: la encomienda no posee ningun paquete';
	END IF;
	
	IF !((SELECT estado
			FROM encomiendas
			WHERE id = encomienda) <=> NULL) THEN
			
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = '(sp_solicitar_encomienda) Error: la encomienda ya ha sido solicitada';

	END IF;
	IF (
		SELECT c.saldo < sf_calcular_costo_encomienda(encomienda)
			FROM encomiendas e
			INNER JOIN clientes c ON c.id = e.cliente_env_id
			WHERE e.id = encomienda
	) THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = '(sp_solicitar_encomienda) Error: el cliente no posee saldo suficiente';
	END IF;
	
	UPDATE encomiendas
	SET estado = 'en espera'
	WHERE id = encomienda;
	
	CALL sp_enviar_invitacion(encomienda);
END;

DROP PROCEDURE IF EXISTS sp_terminar_recorrido;
CREATE PROCEDURE `sp_terminar_recorrido`(
    _encomienda_id VARCHAR(7),
    _recorrido_id INT(10)
)
BEGIN
    DECLARE _transportista_id VARCHAR(9);
    DECLARE is_same_destiny int;
    DECLARE newOrigin int(10);
    DECLARE newDestiny int(10);
    IF (
        SELECT estado = 'abierto' OR estado = 'culminado'
        FROM recorridos
        WHERE encomienda_id = _encomienda_id
        AND id = _recorrido_id
    )
    THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = '(sp_terminar_recorrido) Error: el recorrido no se pude terminar';
    END IF;
    UPDATE recorridos
        SET estado = 'culminado'
        WHERE encomienda_id = _encomienda_id
        AND id = _recorrido_id;
    SELECT e.nucleo_rec_id = r.nucleo_des_id
        INTO is_same_destiny
        FROM encomiendas e
        INNER JOIN recorridos r ON r.encomienda_id = e.id
            AND r.id = _recorrido_id
        WHERE e.id = _encomienda_id;
    IF is_same_destiny THEN

        SELECT transportista_id
            INTO _transportista_id
            FROM recorridos
            WHERE encomienda_id = _encomienda_id
            AND id = (
                SELECT MAX(id) 
                FROM recorridos
                WHERE encomienda_id = _encomienda_id
            );
        CALL sp_update_estado(_encomienda_id, _transportista_id, NULL);
    ELSE
        SELECT nucleo_des_id
        INTO newOrigin
        FROM recorridos
        WHERE encomienda_id = _encomienda_id
        AND id = _recorrido_id;
        SELECT nucleo_rec_id
        INTO newDestiny
        FROM encomiendas
        WHERE id = _encomienda_id;
        INSERT INTO recorridos (id, encomienda_id, nucleo_org_id, nucleo_des_id)
            VALUES (_recorrido_id + 1, _encomienda_id, newOrigin, newDestiny);
    END IF;
END;

DROP PROCEDURE IF EXISTS sp_update_estado;
CREATE PROCEDURE `sp_update_estado`(
	encomienda VARCHAR(7),
	transportista VARCHAR(9),
	newEstado VARCHAR(15)
)
BEGIN

	DECLARE oldEstado VARCHAR(15);

	DECLARE _tipo VARCHAR(15);

	SELECT tipo
	INTO _tipo
	FROM encomiendas
	WHERE id = encomienda;
	
	IF transportista <=> NULL
		OR encomienda <=> NULL
		OR (
			_tipo = 'normal'
			AND transportista <> (
				SELECT transportista_id
				FROM encomiendas
				WHERE id = encomienda
			)
		)
		OR (
			_tipo = 'extendida'
			AND transportista NOT IN (
				SELECT transportista_id
				FROM recorridos
				WHERE encomienda_id = encomienda
				AND id = (
					SELECT MAX(id) 
					FROM recorridos
					WHERE encomienda_id = encomienda
            	)
			)
		)
	THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = '(sp_update_estado) Error: el transportista o encomienda ingresada no es valida';
	
	END IF;

	
	IF (newEstado <=> NULL) THEN
	
		SELECT estado
		INTO oldEstado
		FROM encomiendas
		WHERE id = encomienda;

		IF oldEstado <=> NULL THEN
			SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = '(sp_update_estado) Error: la encomienda no ha sido iniciada, su estado no se puede actualizar';
		END IF;

		CASE oldEstado
		
			WHEN 'en espera' THEN

				SET newEstado = 'en progreso';
				UPDATE encomiendas
					SET fh_salida = NOW()
					WHERE id = encomienda;
				CALL sp_cobrar_encomienda_cliente(encomienda);
				
			WHEN 'en custodia'  THEN
			
				SET newEstado = 'en progreso';
				
			WHEN 'en progreso'  THEN


			
				SET newEstado = 'culminada';
				UPDATE encomiendas
					SET fh_llegada = NOW()
					WHERE id = encomienda;

				IF (
					SELECT tipo
					FROM encomiendas
					WHERE id = encomienda
				) = 'normal'
				THEN
					CALL sp_pagar_encomienda_transportista(encomienda);
				ELSE
					CALL sp_pagar_encomienda_extendida_transportistas(encomienda);
				END IF;

				UPDATE encomiendas
				SET precio = sf_calcular_costo_encomienda(encomienda)
				WHERE id = encomienda;

				UPDATE paquetes
				SET precio = sf_calcular_costo_paquete(id)
				WHERE encomienda_id = encomienda;

				
			ELSE 
				SET newEstado = oldEstado;
				
		END CASE;
	
	ELSEIF !(newEstado <=> 'en custodia')
		AND !(newEstado <=> 'cancelada') THEN
		
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = '(sp_update_estado) Error: el estado ingresado no es valido';
		
	END IF;
	
	UPDATE encomiendas
	SET estado = newEstado
	WHERE id = encomienda;
	
END;

DROP PROCEDURE IF EXISTS sp_validar_curso_transportista;
CREATE PROCEDURE `sp_validar_curso_transportista`( IN id_transportista VARCHAR(9) )
BEGIN
	UPDATE transportistas
     SET curso_aprobado = 1, f_curso = NOW()
     WHERE id_transportista = id;
END;

DROP PROCEDURE IF EXISTS sp_validar_ingreso_transportista;
CREATE PROCEDURE `sp_validar_ingreso_transportista`(
  f_ingreso DATE
)
BEGIN
	IF f_ingreso > CURDATE() THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Fecha de ingreso inválida';
	END IF;
END;

DROP Function IF EXISTS sf_calcular_costo_encomienda;
CREATE FUNCTION `sf_calcular_costo_encomienda`(
    _id VARCHAR(7)
) RETURNS float(255,2)
BEGIN

    DECLARE total FLOAT (255,2);
	SELECT SUM(sf_calcular_costo_paquete(p.id))
	INTO total
	FROM encomiendas e
	LEFT JOIN paquetes p ON p.encomienda_id = e.id
	WHERE e.id = _id;
	RETURN total;
END;

DROP Function IF EXISTS sf_calcular_costo_paquete;
CREATE FUNCTION `sf_calcular_costo_paquete`(
    id_paquete INT(10)
) RETURNS decimal(14,3)
BEGIN

    RETURN (
        SELECT (p.alto*p.ancho*p.largo)/5000 * n.precio_por_kg
        FROM paquetes p, nucleos n, encomiendas e
        WHERE id_paquete = p.id AND p.encomienda_id = e.id AND e.nucleo_id = n.id
    );
END;

DROP Function IF EXISTS sf_consultar_saldo_cliente;
CREATE FUNCTION `sf_consultar_saldo_cliente`(
    id_cliente VARCHAR(9)
) RETURNS decimal(14,3)
BEGIN

    RETURN( 
        SELECT saldo
        FROM clientes
        WHERE id_cliente = id
    );
END;

DROP Function IF EXISTS sf_encomiendas_totales_transportista;
CREATE FUNCTION `sf_encomiendas_totales_transportista`(
  transportista_id VARCHAR(9)
) RETURNS int(11)
BEGIN
    RETURN ( 
        SELECT COUNT(*)
        FROM recorridos r
        WHERE r.transportista_id = transportista_id
    );
END;

DROP Function IF EXISTS sf_recargar_saldo_cliente;
CREATE FUNCTION `sf_recargar_saldo_cliente`(
	id_cliente VARCHAR(9), monto_recarga DECIMAL(14,3)
) RETURNS decimal(14,3)
BEGIN
        DECLARE saldo_final DECIMAL(14,3);
	IF id_cliente <=> NULL || monto_recarga <=> NULL THEN
                SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = '(sf_recargar_saldo_cliente) Error: monto_recarga o id_cliente es NULL';
        END IF;
	UPDATE clientes
        SET saldo = saldo + monto_recarga
        WHERE id_cliente = id;
        SELECT saldo
        INTO saldo_final
        FROM clientes
        WHERE id_cliente = id;
        RETURN saldo_final;
END;

DROP Function IF EXISTS sf_retirar_saldo_transportista;
CREATE FUNCTION `sf_retirar_saldo_transportista`(
	_id_transportista VARCHAR(9), monto_retiro DECIMAL(14,3)
) RETURNS decimal(14,3)
BEGIN

    DECLARE saldo_final DECIMAL(14,3);
	IF _id_transportista <=> NULL ||  monto_retiro <=> NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = '(sf_retirar_saldo_transportista) Error: el monto de retiro o el id_transportista es NULL';
    END IF;
    IF (
        SELECT saldo < monto_retiro
        FROM transportistas
        WHERE id = _id_transportista
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = '(sf_retirar_saldo_transportista) Error: el transportista no posee saldo suficiente';
    END IF;
	UPDATE transportistas
        SET saldo = saldo - monto_retiro
        WHERE _id_transportista = id;
    SELECT saldo
        INTO saldo_final
        FROM transportistas
        WHERE id = _id_transportista;
    RETURN saldo_final;
END;

DROP TRIGGER IF EXISTS tg_historico_cliente;
CREATE TRIGGER tg_historico_cliente
AFTER UPDATE ON clientes
FOR EACH ROW
BEGIN
	IF NEW.saldo <> OLD.saldo THEN
		INSERT INTO historico_clientes (cliente_id, fecha, valor, saldo_final)
		VALUES (NEW.id, NOW(), NEW.saldo - OLD.saldo, NEW.saldo);
	END IF;
END;

DROP TRIGGER IF EXISTS tg_before_encomiendas_insert_estado;
CREATE TRIGGER tg_before_encomiendas_insert_estado
    BEFORE INSERT
    ON encomiendas FOR EACH ROW
BEGIN
    IF NEW.tipo = 'extendida' THEN
        SET NEW.estado = 'en espera';
    END IF;
END;

DROP TRIGGER IF EXISTS tg_before_encomiendas_insert_id;
CREATE TRIGGER tg_before_encomiendas_insert_id
    BEFORE INSERT
    ON encomiendas FOR EACH ROW
BEGIN
    DECLARE _id VARCHAR(7);
    SELECT MAX(id)
    INTO _id
    FROM encomiendas;
    SET _id = HEX(CONV(_id, 16, 10) + 1);
    WHILE LENGTH(_id) < 7 DO
        SET _id = CONCAT('0', _id);
    END WHILE;
    SET NEW.id = _id;
END;

DROP TRIGGER IF EXISTS tg_after_encomiendas_insert_publicar_recorrido;
CREATE TRIGGER tg_after_encomiendas_insert_publicar_recorrido
    AFTER INSERT
    ON encomiendas FOR EACH ROW
BEGIN
    IF NEW.tipo = 'extendida' THEN
        INSERT INTO recorridos (id, encomienda_id, nucleo_org_id, nucleo_des_id)
            VALUES (0, NEW.id, NEW.nucleo_id, NEW.nucleo_rec_id);
    END IF;
END;

DROP TRIGGER IF EXISTS tg_chk_recorrido_transportista;
CREATE TRIGGER tg_chk_recorrido_transportista
	BEFORE UPDATE
	ON recorridos FOR EACH ROW
BEGIN
	IF !(OLD.transportista_id <=> NEW.transportista_id)
		AND (
			SELECT nucleo_id
			FROM transportistas
			WHERE id = NEW.transportista_id
		) <> NEW.nucleo_org_id
    THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = '(tg_chk_recorrido_transportista) Error: el transportista 
			no pertenece al nucleo de origen del recorrido';
    END IF;
END;

DROP TRIGGER IF EXISTS validar_fecha_transportista_insert;
CREATE TRIGGER validar_fecha_transportista_insert
BEFORE INSERT ON transportistas
FOR EACH ROW
BEGIN
  CALL sp_validar_ingreso_transportista(NEW.fecha_ingreso);
END;

DROP TRIGGER IF EXISTS validar_fecha_transportista_update;
CREATE TRIGGER validar_fecha_transportista_update
BEFORE UPDATE ON transportistas
FOR EACH ROW
BEGIN
  CALL sp_validar_ingreso_transportista(NEW.fecha_ingreso);
END;

DROP TRIGGER IF EXISTS tg_historico_transportista;
CREATE TRIGGER tg_historico_transportista
AFTER UPDATE ON transportistas
FOR EACH ROW
BEGIN
	IF NEW.saldo <> OLD.saldo THEN
		INSERT INTO historico_transportistas (transportista_id, fecha, valor, saldo_final)
		VALUES (NEW.id, NOW(), NEW.saldo - OLD.saldo, NEW.saldo);
	END IF;
END;