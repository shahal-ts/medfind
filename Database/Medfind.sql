/*
SQLyog Community v12.4.0 (64 bit)
MySQL - 8.0.33 : Database - mediassmabi
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`mediassmabi` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `mediassmabi`;

/*Table structure for table `auth_group` */

DROP TABLE IF EXISTS `auth_group`;

CREATE TABLE `auth_group` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `auth_group` */

insert  into `auth_group`(`id`,`name`) values 
(1,'admin'),
(2,'pharmacy'),
(3,'user');

/*Table structure for table `auth_group_permissions` */

DROP TABLE IF EXISTS `auth_group_permissions`;

CREATE TABLE `auth_group_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=69 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `auth_group_permissions` */

insert  into `auth_group_permissions`(`id`,`group_id`,`permission_id`) values 
(1,1,1),
(2,1,2),
(3,1,3),
(4,1,4),
(5,1,5),
(6,1,6),
(7,1,7),
(8,1,8),
(9,1,9),
(10,1,10),
(11,1,11),
(12,1,12),
(13,1,13),
(14,1,14),
(15,1,15),
(16,1,16),
(17,1,17),
(18,1,18),
(19,1,19),
(20,1,20),
(21,1,21),
(22,1,22),
(23,1,23),
(24,1,24),
(25,1,25),
(26,1,26),
(27,1,27),
(28,1,28),
(29,1,29),
(30,1,30),
(31,1,31),
(32,1,32),
(33,1,33),
(34,1,34),
(35,1,35),
(36,1,36),
(37,1,37),
(38,1,38),
(39,1,39),
(40,1,40),
(41,1,41),
(42,1,42),
(43,1,43),
(44,1,44),
(45,1,45),
(46,1,46),
(47,1,47),
(48,1,48),
(49,1,49),
(50,1,50),
(51,1,51),
(52,1,52),
(53,1,53),
(54,1,54),
(55,1,55),
(56,1,56),
(57,1,57),
(58,1,58),
(59,1,59),
(60,1,60),
(61,1,61),
(62,1,62),
(63,1,63),
(64,1,64),
(65,1,65),
(66,1,66),
(67,1,67),
(68,1,68);

/*Table structure for table `auth_permission` */

DROP TABLE IF EXISTS `auth_permission`;

CREATE TABLE `auth_permission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=69 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `auth_permission` */

insert  into `auth_permission`(`id`,`name`,`content_type_id`,`codename`) values 
(1,'Can add log entry',1,'add_logentry'),
(2,'Can change log entry',1,'change_logentry'),
(3,'Can delete log entry',1,'delete_logentry'),
(4,'Can view log entry',1,'view_logentry'),
(5,'Can add permission',2,'add_permission'),
(6,'Can change permission',2,'change_permission'),
(7,'Can delete permission',2,'delete_permission'),
(8,'Can view permission',2,'view_permission'),
(9,'Can add group',3,'add_group'),
(10,'Can change group',3,'change_group'),
(11,'Can delete group',3,'delete_group'),
(12,'Can view group',3,'view_group'),
(13,'Can add user',4,'add_user'),
(14,'Can change user',4,'change_user'),
(15,'Can delete user',4,'delete_user'),
(16,'Can view user',4,'view_user'),
(17,'Can add content type',5,'add_contenttype'),
(18,'Can change content type',5,'change_contenttype'),
(19,'Can delete content type',5,'delete_contenttype'),
(20,'Can view content type',5,'view_contenttype'),
(21,'Can add session',6,'add_session'),
(22,'Can change session',6,'change_session'),
(23,'Can delete session',6,'delete_session'),
(24,'Can view session',6,'view_session'),
(25,'Can add complaint',7,'add_complaint'),
(26,'Can change complaint',7,'change_complaint'),
(27,'Can delete complaint',7,'delete_complaint'),
(28,'Can view complaint',7,'view_complaint'),
(29,'Can add patient',8,'add_patient'),
(30,'Can change patient',8,'change_patient'),
(31,'Can delete patient',8,'delete_patient'),
(32,'Can view patient',8,'view_patient'),
(33,'Can add order master',9,'add_ordermaster'),
(34,'Can change order master',9,'change_ordermaster'),
(35,'Can delete order master',9,'delete_ordermaster'),
(36,'Can view order master',9,'view_ordermaster'),
(37,'Can add medicine details',10,'add_medicinedetails'),
(38,'Can change medicine details',10,'change_medicinedetails'),
(39,'Can delete medicine details',10,'delete_medicinedetails'),
(40,'Can view medicine details',10,'view_medicinedetails'),
(41,'Can add emergency number',11,'add_emergencynumber'),
(42,'Can change emergency number',11,'change_emergencynumber'),
(43,'Can delete emergency number',11,'delete_emergencynumber'),
(44,'Can view emergency number',11,'view_emergencynumber'),
(45,'Can add pharmacy',12,'add_pharmacy'),
(46,'Can change pharmacy',12,'change_pharmacy'),
(47,'Can delete pharmacy',12,'delete_pharmacy'),
(48,'Can view pharmacy',12,'view_pharmacy'),
(49,'Can add pharmacy medicine',13,'add_pharmacymedicine'),
(50,'Can change pharmacy medicine',13,'change_pharmacymedicine'),
(51,'Can delete pharmacy medicine',13,'delete_pharmacymedicine'),
(52,'Can view pharmacy medicine',13,'view_pharmacymedicine'),
(53,'Can add prescription',14,'add_prescription'),
(54,'Can change prescription',14,'change_prescription'),
(55,'Can delete prescription',14,'delete_prescription'),
(56,'Can view prescription',14,'view_prescription'),
(57,'Can add order details',15,'add_orderdetails'),
(58,'Can change order details',15,'change_orderdetails'),
(59,'Can delete order details',15,'delete_orderdetails'),
(60,'Can view order details',15,'view_orderdetails'),
(61,'Can add reminder',16,'add_reminder'),
(62,'Can change reminder',16,'change_reminder'),
(63,'Can delete reminder',16,'delete_reminder'),
(64,'Can view reminder',16,'view_reminder'),
(65,'Can add cart',17,'add_cart'),
(66,'Can change cart',17,'change_cart'),
(67,'Can delete cart',17,'delete_cart'),
(68,'Can view cart',17,'view_cart');

/*Table structure for table `auth_user` */

DROP TABLE IF EXISTS `auth_user`;

CREATE TABLE `auth_user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `auth_user` */

insert  into `auth_user`(`id`,`password`,`last_login`,`is_superuser`,`username`,`first_name`,`last_name`,`email`,`is_staff`,`is_active`,`date_joined`) values 
(1,'pbkdf2_sha256$1000000$uwoGLZJr43KtSfqbnWLf2i$+WkVp8Y7WoCkNhfGAcB/yXcFAF3BLi7KZ7XdKBRYai4=','2026-03-05 08:15:19.440021',1,'admin','','','admin@gmail.com',1,1,'2026-02-03 10:24:25.000000'),
(2,'pbkdf2_sha256$1000000$pLAjh2EArEvOqqZUIWMIXE$XUYh0V22rjTcdetCH7YRz25PePfP41IUlbd3pd/16j8=',NULL,0,'kk','','','kk@gmail.com',0,1,'2026-02-03 10:32:08.618432'),
(3,'pbkdf2_sha256$1000000$NducvSAzqM1xedNtt347ik$HGE3YLfiYVNsWdueVVvAzTywV9Fv1xOnuKV8XMwo2Os=',NULL,0,'shahal','','','shahal@gmail.com',0,1,'2026-02-22 16:33:27.526326'),
(4,'pbkdf2_sha256$1000000$ALEEh5IMfSQEqK39gpp6tU$lXgUcwcIsPOAe1yY695zdE7TIvweGcPgixZ2nkuqEgA=','2026-03-05 08:15:56.461210',0,'abc','','','abc@gmail.com',0,1,'2026-02-23 06:52:56.752546'),
(5,'pbkdf2_sha256$1000000$rRsV8kjE6X162YaPUTDRaw$Wirs4C/OMUge91wSrI9bDh12nm4+pL/qRMUFav7FK5g=',NULL,0,'abcd','','','abc@gmail.com',0,1,'2026-02-23 07:01:12.471283'),
(6,'pbkdf2_sha256$1000000$jHH0snIV7hBLQzGYdFamZX$LTroRLSnCsBL7MmBspu3uD+V/kCHWfYfLNWmHstSbH4=',NULL,0,'rahul','','','rahul@gmail',0,1,'2026-03-05 08:14:21.686721');

/*Table structure for table `auth_user_groups` */

DROP TABLE IF EXISTS `auth_user_groups`;

CREATE TABLE `auth_user_groups` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `group_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`),
  CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `auth_user_groups` */

insert  into `auth_user_groups`(`id`,`user_id`,`group_id`) values 
(1,1,1);

/*Table structure for table `auth_user_user_permissions` */

DROP TABLE IF EXISTS `auth_user_user_permissions`;

CREATE TABLE `auth_user_user_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  KEY `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=69 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `auth_user_user_permissions` */

insert  into `auth_user_user_permissions`(`id`,`user_id`,`permission_id`) values 
(1,1,1),
(2,1,2),
(3,1,3),
(4,1,4),
(5,1,5),
(6,1,6),
(7,1,7),
(8,1,8),
(9,1,9),
(10,1,10),
(11,1,11),
(12,1,12),
(13,1,13),
(14,1,14),
(15,1,15),
(16,1,16),
(17,1,17),
(18,1,18),
(19,1,19),
(20,1,20),
(21,1,21),
(22,1,22),
(23,1,23),
(24,1,24),
(25,1,25),
(26,1,26),
(27,1,27),
(28,1,28),
(29,1,29),
(30,1,30),
(31,1,31),
(32,1,32),
(33,1,33),
(34,1,34),
(35,1,35),
(36,1,36),
(37,1,37),
(38,1,38),
(39,1,39),
(40,1,40),
(41,1,41),
(42,1,42),
(43,1,43),
(44,1,44),
(45,1,45),
(46,1,46),
(47,1,47),
(48,1,48),
(49,1,49),
(50,1,50),
(51,1,51),
(52,1,52),
(53,1,53),
(54,1,54),
(55,1,55),
(56,1,56),
(57,1,57),
(58,1,58),
(59,1,59),
(60,1,60),
(61,1,61),
(62,1,62),
(63,1,63),
(64,1,64),
(65,1,65),
(66,1,66),
(67,1,67),
(68,1,68);

/*Table structure for table `django_admin_log` */

DROP TABLE IF EXISTS `django_admin_log`;

CREATE TABLE `django_admin_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  `content_type_id` int DEFAULT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_auth_user_id` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `django_admin_log_chk_1` CHECK ((`action_flag` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `django_admin_log` */

insert  into `django_admin_log`(`id`,`action_time`,`object_id`,`object_repr`,`action_flag`,`change_message`,`content_type_id`,`user_id`) values 
(1,'2026-02-03 10:25:32.589185','1','admin',1,'[{\"added\": {}}]',3,1),
(2,'2026-02-03 10:25:39.932789','2','pharmacy',1,'[{\"added\": {}}]',3,1),
(3,'2026-02-03 10:25:46.949075','3','user',1,'[{\"added\": {}}]',3,1),
(4,'2026-02-03 10:26:05.103306','1','admin',2,'[{\"changed\": {\"fields\": [\"Groups\", \"User permissions\"]}}]',4,1);

/*Table structure for table `django_content_type` */

DROP TABLE IF EXISTS `django_content_type`;

CREATE TABLE `django_content_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `django_content_type` */

insert  into `django_content_type`(`id`,`app_label`,`model`) values 
(1,'admin','logentry'),
(3,'auth','group'),
(2,'auth','permission'),
(4,'auth','user'),
(5,'contenttypes','contenttype'),
(17,'myapp','cart'),
(7,'myapp','complaint'),
(11,'myapp','emergencynumber'),
(10,'myapp','medicinedetails'),
(15,'myapp','orderdetails'),
(9,'myapp','ordermaster'),
(8,'myapp','patient'),
(12,'myapp','pharmacy'),
(13,'myapp','pharmacymedicine'),
(14,'myapp','prescription'),
(16,'myapp','reminder'),
(6,'sessions','session');

/*Table structure for table `django_migrations` */

DROP TABLE IF EXISTS `django_migrations`;

CREATE TABLE `django_migrations` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `django_migrations` */

insert  into `django_migrations`(`id`,`app`,`name`,`applied`) values 
(1,'contenttypes','0001_initial','2026-02-03 10:22:49.192588'),
(2,'auth','0001_initial','2026-02-03 10:22:50.304637'),
(3,'admin','0001_initial','2026-02-03 10:22:50.490636'),
(4,'admin','0002_logentry_remove_auto_add','2026-02-03 10:22:50.504598'),
(5,'admin','0003_logentry_add_action_flag_choices','2026-02-03 10:22:50.527537'),
(6,'contenttypes','0002_remove_content_type_name','2026-02-03 10:22:50.630262'),
(7,'auth','0002_alter_permission_name_max_length','2026-02-03 10:22:50.702073'),
(8,'auth','0003_alter_user_email_max_length','2026-02-03 10:22:50.761946'),
(9,'auth','0004_alter_user_username_opts','2026-02-03 10:22:50.787840'),
(10,'auth','0005_alter_user_last_login_null','2026-02-03 10:22:50.859647'),
(11,'auth','0006_require_contenttypes_0002','2026-02-03 10:22:50.872615'),
(12,'auth','0007_alter_validators_add_error_messages','2026-02-03 10:22:50.896550'),
(13,'auth','0008_alter_user_username_max_length','2026-02-03 10:22:50.994288'),
(14,'auth','0009_alter_user_last_name_max_length','2026-02-03 10:22:51.071085'),
(15,'auth','0010_alter_group_name_max_length','2026-02-03 10:22:51.112971'),
(16,'auth','0011_update_proxy_permissions','2026-02-03 10:22:51.133917'),
(17,'auth','0012_alter_user_first_name_max_length','2026-02-03 10:22:51.214699'),
(18,'myapp','0001_initial','2026-02-03 10:22:52.894426'),
(19,'myapp','0002_cart','2026-02-03 10:22:53.149702'),
(20,'myapp','0003_patient_latitude_patient_longitude','2026-02-03 10:22:53.279358'),
(21,'myapp','0004_rename_time_to_take_reminder_time_and_more','2026-02-03 10:22:53.717185'),
(22,'sessions','0001_initial','2026-02-03 10:22:53.779847');

/*Table structure for table `django_session` */

DROP TABLE IF EXISTS `django_session`;

CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `django_session` */

insert  into `django_session`(`session_key`,`session_data`,`expire_date`) values 
('0qldhv0vnn7pn19ymvfo3jlkzj2zy2p7','.eJxVzEsOwiAUheG9MDYEKLTg0LlrIBe4CD7AlHZgjHu3JB3o9Jw_35tYWJdk14azzYEcCSeH382Bv2HpR7hCuVTqa1nm7GhP6P42eq4B76e9_QMStNRZ7UauIzPSM-8ZMun0YJSchNERpRJhFIOKXI0GYBKAW861MNHxyQc1bGjnltcTNw3CIxfy-QIWSD2P:1vwIvO:fIqbXgog_vOJ2SE99S-3MCQiGpH-8Zf4tcJexiCl_Xc','2026-03-14 11:55:58.650073'),
('3ok5d6vlqvdfojve6e7ks77vuox6llu4','.eJxVjssOgjAURP-la9O0wC3FpXu_gUzbW4sPIDwWxPjv0uhCd5N5nMxTtFiX1K4zT20XxFFU4vDrOfgb9zkIV_SXQfqhX6bOyVyR33SW5yHw_fTt_gES5rSvVc01TFQULXThuLTRGGp0tFUoQqVLa4wHgRpLgA1KOYp1ozgqAypph2Zcvqg_ctlG3sFjwvSA38TrDbXeQqw:1vy3sC:Thgq2HGm7Z0IR0q8c2yGHbQZxt8BvW8eYcnJ8Tkg1a8','2026-03-19 08:15:56.486139'),
('jl0xtq56a5ezo1614s54csim4enpqfoy','.eJxVzEsOwiAUheG9MDYEKLTg0LlrIBe4CD7AlHZgjHu3JB3o9Jw_35tYWJdk14azzYEcCSeH382Bv2HpR7hCuVTqa1nm7GhP6P42eq4B76e9_QMStNRZ7UauIzPSM-8ZMun0YJSchNERpRJhFIOKXI0GYBKAW861MNHxyQc1bGjnltcTNw3CIxfy-QIWSD2P:1vwKhx:6O9oVEslewdSIDnlD4U7SxlhjmrVrFgWjqdTmfhAHpk','2026-03-14 13:50:13.688694'),
('ptwoxl5g2asaveo3wx7cjkbntmrte1jq','.eJxVjDsOAiEUAO9CbQj_j6W9ZyCPB8iqgWTZrYx3V5IttJ2ZzIsE2Lca9pHXsCRyJpycflkEfOQ2RbpDu3WKvW3rEulM6GEHvfaUn5ej_RtUGHVuXTTcFeYVMkSWmYpOeq2s8K5kpUUyQurCtfEAVkD-5twJXyK3mLQk7w_A6jcX:1vnDas:6VVk4x6mogPQRHoMMLb1BQvQVC81IFYRx7YQuZaC6wA','2026-02-17 10:25:14.351385'),
('q7ulxc6y9qppwm5od2gu42s96o7a2e1h','.eJxVjssOgjAURP-la9O0wC3FpXu_gUzbW4sPIDwWxPjv0uhCd5N5nMxTtFiX1K4zT20XxFFU4vDrOfgb9zkIV_SXQfqhX6bOyVyR33SW5yHw_fTt_gES5rSvVc01TFQULXThuLTRGGp0tFUoQqVLa4wHgRpLgA1KOYp1ozgqAypph2Zcvqg_ctlG3sFjwvSA38TrDbXeQqw:1vwJ4d:i28GxHRtRtIitFO2pRs0moBJPD7m4YS1cF0xmqEkGkk','2026-03-14 12:05:31.567641'),
('rwikqhvasofxhs1t3tp9khbwmnj85mn8','.eJxVjssOgjAURP-la9O0wC3FpXu_gUzbW4sPIDwWxPjv0uhCd5N5nMxTtFiX1K4zT20XxFFU4vDrOfgb9zkIV_SXQfqhX6bOyVyR33SW5yHw_fTt_gES5rSvVc01TFQULXThuLTRGGp0tFUoQqVLa4wHgRpLgA1KOYp1ozgqAypph2Zcvqg_ctlG3sFjwvSA38TrDbXeQqw:1vuRRf:VY4G_F3SArdxjp_4Tm2jxRL2odhgaB_CMIhj2Q1OlIk','2026-03-09 08:37:35.950083'),
('vf297wc6xyae9ked27dtyr1p2rfa06or','.eJxVjssOgjAURP-la9O0wC3FpXu_gUzbW4sPIDwWxPjv0uhCd5N5nMxTtFiX1K4zT20XxFFU4vDrOfgb9zkIV_SXQfqhX6bOyVyR33SW5yHw_fTt_gES5rSvVc01TFQULXThuLTRGGp0tFUoQqVLa4wHgRpLgA1KOYp1ozgqAypph2Zcvqg_ctlG3sFjwvSA38TrDbXeQqw:1vwKja:T7-8GPJHGgY4lpovYLWJCwTM2Ex9q0sfr9ZOZTRmuMM','2026-03-14 13:51:54.902427'),
('yw49zs532oxk0vy6ykhu1jin19ksmi6n','.eJxVjssOgjAURP-la9O0wC3FpXu_gUzbW4sPIDwWxPjv0uhCd5N5nMxTtFiX1K4zT20XxFFU4vDrOfgb9zkIV_SXQfqhX6bOyVyR33SW5yHw_fTt_gES5rSvVc01TFQULXThuLTRGGp0tFUoQqVLa4wHgRpLgA1KOYp1ozgqAypph2Zcvqg_ctlG3sFjwvSA38TrDbXeQqw:1vy3sA:X8s4HI51foV9iypceMC7nWQJX-sIjB0BJ9J7or9spKM','2026-03-19 08:15:54.569806');

/*Table structure for table `myapp_cart` */

DROP TABLE IF EXISTS `myapp_cart`;

CREATE TABLE `myapp_cart` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `quantity` int unsigned NOT NULL,
  `added_on` datetime(6) NOT NULL,
  `medicine_id` bigint NOT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `myapp_cart_medicine_id_187b162d_fk_myapp_pharmacymedicine_id` (`medicine_id`),
  KEY `myapp_cart_user_id_d6c51e4b_fk_auth_user_id` (`user_id`),
  CONSTRAINT `myapp_cart_medicine_id_187b162d_fk_myapp_pharmacymedicine_id` FOREIGN KEY (`medicine_id`) REFERENCES `myapp_pharmacymedicine` (`id`),
  CONSTRAINT `myapp_cart_user_id_d6c51e4b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `myapp_cart_chk_1` CHECK ((`quantity` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `myapp_cart` */

/*Table structure for table `myapp_complaint` */

DROP TABLE IF EXISTS `myapp_complaint`;

CREATE TABLE `myapp_complaint` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `complaint` longtext NOT NULL,
  `reply` longtext,
  `date` datetime(6) NOT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `myapp_complaint_user_id_5c342b76_fk_auth_user_id` (`user_id`),
  CONSTRAINT `myapp_complaint_user_id_5c342b76_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `myapp_complaint` */

/*Table structure for table `myapp_emergencynumber` */

DROP TABLE IF EXISTS `myapp_emergencynumber`;

CREATE TABLE `myapp_emergencynumber` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `number` varchar(15) NOT NULL,
  `patient_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `myapp_emergencynumber_patient_id_6e1b47ac_fk_myapp_patient_id` (`patient_id`),
  CONSTRAINT `myapp_emergencynumber_patient_id_6e1b47ac_fk_myapp_patient_id` FOREIGN KEY (`patient_id`) REFERENCES `myapp_patient` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `myapp_emergencynumber` */

insert  into `myapp_emergencynumber`(`id`,`number`,`patient_id`) values 
(1,'8891445901',3);

/*Table structure for table `myapp_medicinedetails` */

DROP TABLE IF EXISTS `myapp_medicinedetails`;

CREATE TABLE `myapp_medicinedetails` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `medicine_name` varchar(100) NOT NULL,
  `dosage` varchar(100) NOT NULL,
  `quantity` int NOT NULL,
  `description` longtext,
  `patient_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `myapp_medicinedetails_patient_id_a1c66601_fk_myapp_patient_id` (`patient_id`),
  CONSTRAINT `myapp_medicinedetails_patient_id_a1c66601_fk_myapp_patient_id` FOREIGN KEY (`patient_id`) REFERENCES `myapp_patient` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `myapp_medicinedetails` */

/*Table structure for table `myapp_orderdetails` */

DROP TABLE IF EXISTS `myapp_orderdetails`;

CREATE TABLE `myapp_orderdetails` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `quantity` int NOT NULL,
  `amount` double NOT NULL,
  `order_status` varchar(50) NOT NULL,
  `pharmacy_medicine_id` bigint NOT NULL,
  `prescription_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `myapp_orderdetails_pharmacy_medicine_id_dfd9c249_fk_myapp_pha` (`pharmacy_medicine_id`),
  KEY `myapp_orderdetails_prescription_id_aa1ba248_fk_myapp_pre` (`prescription_id`),
  CONSTRAINT `myapp_orderdetails_pharmacy_medicine_id_dfd9c249_fk_myapp_pha` FOREIGN KEY (`pharmacy_medicine_id`) REFERENCES `myapp_pharmacymedicine` (`id`),
  CONSTRAINT `myapp_orderdetails_prescription_id_aa1ba248_fk_myapp_pre` FOREIGN KEY (`prescription_id`) REFERENCES `myapp_prescription` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `myapp_orderdetails` */

insert  into `myapp_orderdetails`(`id`,`quantity`,`amount`,`order_status`,`pharmacy_medicine_id`,`prescription_id`) values 
(1,5,1150,'Pending',1,NULL);

/*Table structure for table `myapp_ordermaster` */

DROP TABLE IF EXISTS `myapp_ordermaster`;

CREATE TABLE `myapp_ordermaster` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `total_amount` double NOT NULL,
  `date` datetime(6) NOT NULL,
  `payment_status` varchar(50) NOT NULL,
  `patient_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `myapp_ordermaster_patient_id_352636d8_fk_myapp_patient_id` (`patient_id`),
  CONSTRAINT `myapp_ordermaster_patient_id_352636d8_fk_myapp_patient_id` FOREIGN KEY (`patient_id`) REFERENCES `myapp_patient` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `myapp_ordermaster` */

insert  into `myapp_ordermaster`(`id`,`total_amount`,`date`,`payment_status`,`patient_id`) values 
(1,1150,'2026-03-05 07:42:07.665777','Paid',3);

/*Table structure for table `myapp_patient` */

DROP TABLE IF EXISTS `myapp_patient`;

CREATE TABLE `myapp_patient` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `phone` varchar(15) NOT NULL,
  `email` varchar(254) NOT NULL,
  `place` varchar(100) NOT NULL,
  `age` int NOT NULL,
  `gender` varchar(10) NOT NULL,
  `user_id` int NOT NULL,
  `latitude` varchar(50) DEFAULT NULL,
  `longitude` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`),
  CONSTRAINT `myapp_patient_user_id_f45970d6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `myapp_patient` */

insert  into `myapp_patient`(`id`,`name`,`phone`,`email`,`place`,`age`,`gender`,`user_id`,`latitude`,`longitude`) values 
(1,'kk','1234567890','kk@gmail.com','thrissur',22,'Male',2,NULL,NULL),
(2,'shahal','9746650333','shahal@gmail.com','kochi',36,'Male',3,NULL,NULL),
(3,'abcd','1234567890','abc@gmail.com','kochi',25,'Male',5,NULL,NULL);

/*Table structure for table `myapp_pharmacy` */

DROP TABLE IF EXISTS `myapp_pharmacy`;

CREATE TABLE `myapp_pharmacy` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `pharmacy_name` varchar(100) NOT NULL,
  `email` varchar(254) NOT NULL,
  `phone` varchar(15) NOT NULL,
  `place` varchar(100) NOT NULL,
  `latitude` double NOT NULL,
  `longitude` double NOT NULL,
  `license_proof` varchar(100) NOT NULL,
  `approval_status` tinyint(1) NOT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`),
  CONSTRAINT `myapp_pharmacy_user_id_bfb3dfd4_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `myapp_pharmacy` */

insert  into `myapp_pharmacy`(`id`,`pharmacy_name`,`email`,`phone`,`place`,`latitude`,`longitude`,`license_proof`,`approval_status`,`user_id`) values 
(1,'medd','abc@gmail.com','1234567890','kodugaloor',10.266585168585625,76.14216129700847,'licenses/Resume1.jpg',1,4),
(2,'asmabi','rahul@gmail','123456789','trissur',10.28693893535775,76.16723362840766,'licenses/WhatsApp_Image_2026-02-25_at_4.52.24_PM.jpeg',0,6);

/*Table structure for table `myapp_pharmacymedicine` */

DROP TABLE IF EXISTS `myapp_pharmacymedicine`;

CREATE TABLE `myapp_pharmacymedicine` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `medicine_name` varchar(100) NOT NULL,
  `company_name` varchar(100) NOT NULL,
  `medicine_type` varchar(50) NOT NULL,
  `manufacture_date` date NOT NULL,
  `expiry_date` date NOT NULL,
  `quantity` int NOT NULL,
  `price` double NOT NULL,
  `details` longtext,
  `prescription_require` tinyint(1) NOT NULL,
  `pharmacy_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `myapp_pharmacymedicine_pharmacy_id_7aacef54_fk_myapp_pharmacy_id` (`pharmacy_id`),
  CONSTRAINT `myapp_pharmacymedicine_pharmacy_id_7aacef54_fk_myapp_pharmacy_id` FOREIGN KEY (`pharmacy_id`) REFERENCES `myapp_pharmacy` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `myapp_pharmacymedicine` */

insert  into `myapp_pharmacymedicine`(`id`,`medicine_name`,`company_name`,`medicine_type`,`manufacture_date`,`expiry_date`,`quantity`,`price`,`details`,`prescription_require`,`pharmacy_id`) values 
(1,'dolo','abc','tablet','2005-01-01','2005-03-02',10,230,'',0,1);

/*Table structure for table `myapp_prescription` */

DROP TABLE IF EXISTS `myapp_prescription`;

CREATE TABLE `myapp_prescription` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `file` varchar(100) NOT NULL,
  `text` longtext,
  `date` datetime(6) NOT NULL,
  `patient_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `myapp_prescription_patient_id_b8cabcbe_fk_myapp_patient_id` (`patient_id`),
  CONSTRAINT `myapp_prescription_patient_id_b8cabcbe_fk_myapp_patient_id` FOREIGN KEY (`patient_id`) REFERENCES `myapp_patient` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `myapp_prescription` */

/*Table structure for table `myapp_reminder` */

DROP TABLE IF EXISTS `myapp_reminder`;

CREATE TABLE `myapp_reminder` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `time` time(6) NOT NULL,
  `message` longtext NOT NULL DEFAULT (_utf8mb4'2'),
  `patient_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `myapp_reminder_patient_id_577d0e8a_fk_myapp_patient_id` (`patient_id`),
  CONSTRAINT `myapp_reminder_patient_id_577d0e8a_fk_myapp_patient_id` FOREIGN KEY (`patient_id`) REFERENCES `myapp_patient` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `myapp_reminder` */

insert  into `myapp_reminder`(`id`,`time`,`message`,`patient_id`) values 
(1,'22:09:00.000000','kk',2),
(2,'22:11:00.000000','asd',2),
(3,'20:00:00.000000','dimbazol',3);

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
