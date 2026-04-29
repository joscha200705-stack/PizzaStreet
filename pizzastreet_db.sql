/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19-11.8.3-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: PizzaStreet
-- ------------------------------------------------------
-- Server version	11.8.3-MariaDB-0+deb13u1 from Debian

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*M!100616 SET @OLD_NOTE_VERBOSITY=@@NOTE_VERBOSITY, NOTE_VERBOSITY=0 */;

--
-- Table structure for table `Categorias`
--

DROP TABLE IF EXISTS `Categorias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Categorias` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Categorias`
--

LOCK TABLES `Categorias` WRITE;
/*!40000 ALTER TABLE `Categorias` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `Categorias` VALUES
(1,'Pizzas','Masa artesana elaborada a mano cada día'),
(2,'Burger','Pan tomate  carne de buey 200g'),
(3,'Paninos','Pan artesano con distintos rellenos'),
(4,'Hot Dogs','Salchicha frankfurter con distintos acompañamientos'),
(5,'Kebab','Carne kebab con verduras frescas'),
(6,'Baguettes','Pan baguette con distintos rellenos'),
(7,'Sandwiches','Pan de molde con distintos rellenos'),
(8,'Ensaladas','Ensaladas frescas variadas'),
(9,'Complementos','Guarniciones y entrantes'),
(10,'Bebidas','Refrescos, agua y cerveza'),
(11,'Salsas','Salsas variadas — 1,10€ cada una');
/*!40000 ALTER TABLE `Categorias` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `Ingredientes`
--

DROP TABLE IF EXISTS `Ingredientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Ingredientes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `alergeno` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Ingredientes`
--

LOCK TABLES `Ingredientes` WRITE;
/*!40000 ALTER TABLE `Ingredientes` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `Ingredientes` VALUES
(1,'Tomate',NULL),
(2,'Mozzarella','Lácteos'),
(3,'Albahaca',NULL),
(4,'Anchoas','Pescado'),
(5,'Aceitunas',NULL),
(6,'Alcaparras',NULL),
(7,'Pepperoni',NULL),
(8,'Bacon',NULL),
(9,'Jamón cocido',NULL),
(10,'Champiñones',NULL),
(11,'Pimiento',NULL),
(12,'Cebolla',NULL),
(13,'Pollo',NULL),
(14,'Ternera',NULL),
(15,'Queso cheddar','Lácteos'),
(16,'Lechuga',NULL),
(17,'Pepino',NULL),
(18,'Maíz',NULL),
(19,'Atún','Pescado'),
(20,'Huevo','Huevo'),
(21,'Patatas',NULL),
(22,'Salchicha frankfurter',NULL),
(23,'Pan','Gluten'),
(24,'Piña',NULL),
(25,'Gorgonzola','Lácteos'),
(26,'Parmesano','Lácteos'),
(27,'Emmental','Lácteos');
/*!40000 ALTER TABLE `Ingredientes` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `LineaPedido`
--

DROP TABLE IF EXISTS `LineaPedido`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `LineaPedido` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pedido_id` int(11) NOT NULL,
  `producto_id` int(11) NOT NULL,
  `cantidad` int(11) NOT NULL DEFAULT 1,
  `precio_unidad` decimal(5,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `pedido_id` (`pedido_id`),
  KEY `producto_id` (`producto_id`),
  CONSTRAINT `LineaPedido_ibfk_1` FOREIGN KEY (`pedido_id`) REFERENCES `Pedidos` (`id`),
  CONSTRAINT `LineaPedido_ibfk_2` FOREIGN KEY (`producto_id`) REFERENCES `Productos` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `LineaPedido`
--

LOCK TABLES `LineaPedido` WRITE;
/*!40000 ALTER TABLE `LineaPedido` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `LineaPedido` VALUES
(1,1,5,1,9.00),
(2,2,2,4,8.00),
(3,2,6,1,8.50),
(4,2,15,1,9.50),
(5,2,16,1,8.00);
/*!40000 ALTER TABLE `LineaPedido` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `Pedidos`
--

DROP TABLE IF EXISTS `Pedidos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Pedidos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fecha` datetime DEFAULT current_timestamp(),
  `nombre_cliente` varchar(100) NOT NULL,
  `telefono` varchar(15) DEFAULT NULL,
  `tipo` enum('local','domicilio') DEFAULT 'local',
  `zona` varchar(50) DEFAULT NULL,
  `notas` text DEFAULT NULL,
  `estado` enum('pendiente','preparando','listo','entregado') DEFAULT 'pendiente',
  `total` decimal(6,2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Pedidos`
--

LOCK TABLES `Pedidos` WRITE;
/*!40000 ALTER TABLE `Pedidos` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `Pedidos` VALUES
(1,'2026-04-29 20:31:00','Jose','680 93 06 77','local','Albaida','a las 22.00','pendiente',9.00),
(2,'2026-04-29 20:33:55','Jose','980930677','domicilio','Olivares','','pendiente',59.50);
/*!40000 ALTER TABLE `Pedidos` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ProductoIngredientes`
--

DROP TABLE IF EXISTS `ProductoIngredientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ProductoIngredientes` (
  `producto_id` int(11) NOT NULL,
  `ingrediente_id` int(11) NOT NULL,
  PRIMARY KEY (`producto_id`,`ingrediente_id`),
  KEY `ingrediente_id` (`ingrediente_id`),
  CONSTRAINT `ProductoIngredientes_ibfk_1` FOREIGN KEY (`producto_id`) REFERENCES `Productos` (`id`),
  CONSTRAINT `ProductoIngredientes_ibfk_2` FOREIGN KEY (`ingrediente_id`) REFERENCES `Ingredientes` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ProductoIngredientes`
--

LOCK TABLES `ProductoIngredientes` WRITE;
/*!40000 ALTER TABLE `ProductoIngredientes` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `ProductoIngredientes` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `Productos`
--

DROP TABLE IF EXISTS `Productos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Productos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `categoria_id` int(11) NOT NULL,
  `codigo` varchar(10) DEFAULT NULL,
  `nombre` varchar(150) NOT NULL,
  `ingredientes` text DEFAULT NULL,
  `precio` decimal(5,2) NOT NULL,
  `disponible` tinyint(1) DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `categoria_id` (`categoria_id`),
  CONSTRAINT `Productos_ibfk_1` FOREIGN KEY (`categoria_id`) REFERENCES `Categorias` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=88 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Productos`
--

LOCK TABLES `Productos` WRITE;
/*!40000 ALTER TABLE `Productos` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `Productos` VALUES
(2,1,'1.002','MARGHERITA','Tomate, mozzarella, albahaca',8.00,1),
(5,1,'1.005','PEPPERONI','Tomate, mozzarella, pepperoni picante',9.00,1),
(6,1,'1.006','BARBACOA','Salsa barbacoa, mozzarella, pollo, cebolla',8.50,1),
(14,1,'1.014','4 ESTACIONES','Tomate, mozzarella, jamón cocido, champiñones, alcachofas, aceitunas',9.00,1),
(15,1,'1.015','4 QUESOS','Mozzarella, gorgonzola, parmesano, emmental',9.50,1),
(16,1,'1.016','HAWAIANA','Tomate, mozzarella, jamón cocido, piña',8.00,1),
(18,2,'2.001','SIMPLE BURGER','Carne buey 200g, lechuga, tomate',5.00,1),
(19,2,'2.002','CHEESE BURGER','Carne buey 200g, queso cheddar, lechuga, tomate',6.00,1),
(20,2,'2.003','BACON BURGER','Carne buey 200g, bacon, lechuga, tomate',6.50,1),
(21,2,'2.004','BACON CHEESE','Carne buey 200g, bacon, queso cheddar, lechuga, tomate',7.00,1),
(22,2,'2.005','STEAK CHICKEN BURGER',NULL,6.50,1),
(23,2,'2.006','TEXAS BURGER','Carne buey 200g, bacon, queso, cebolla crujiente, jalapeños, salsa BBQ',8.00,1),
(24,2,'2.007','EXTREMA BURGER','Doble carne buey 200g, doble queso, bacon, lechuga, tomate, cebolla',9.50,1),
(30,4,'4.001','HOT DOG SIMPLE',NULL,3.50,1),
(31,4,'4.002','HOT DOG CHEESE',NULL,4.00,1),
(32,4,'4.003','HOT DOG BACON',NULL,4.50,1),
(33,4,'4.004','HOT DOG ESPECIAL',NULL,5.00,1),
(34,5,'5.001','KEBAB POLLO','Carne kebab de pollo, lechuga, tomate, cebolla, salsa yogur',5.50,1),
(35,5,'5.002','KEBAB MIXTO','Carne kebab mixta pollo y ternera, lechuga, tomate, cebolla, salsa',6.00,1),
(41,7,'7.001','SANDWICH MIXTO',NULL,4.00,1),
(42,7,'7.002','SANDWICH POLLO',NULL,5.00,1),
(44,7,'7.004','SANDWICH VEGETAL',NULL,4.00,1),
(45,8,'8.001','MEDITERRÁNEA','Lechuga, tomate, pepino, aceitunas, cebolla, queso feta',6.00,1),
(46,8,'8.002','CÉSAR','Lechuga romana, pollo a la plancha, picatostes, parmesano, salsa césar',7.00,1),
(47,8,'8.003','MIXTA','Lechuga, tomate, zanahoria, maíz, pepino, cebolla',5.00,1),
(48,8,'8.004','CAMPERA','Lechuga, tomate, atún, maíz, aceitunas, huevo duro',6.50,1),
(49,9,'9.001','PATATAS FRITAS',NULL,4.00,1),
(51,9,'9.003','AROS DE CEBOLLA',NULL,4.50,1),
(52,9,'9.004','NUGGETS DE POLLO',NULL,4.50,1),
(53,9,'9.005','ALITAS DE POLLO',NULL,4.50,1),
(54,9,'9.006','MOZZARELLA STICKS',NULL,4.00,1),
(57,10,'10.001','AGUA',NULL,1.00,1),
(58,10,'10.002','COCA-COLA',NULL,2.00,1),
(59,10,'10.003','COCA-COLA ZERO',NULL,2.00,1),
(60,10,'10.004','FANTA NARANJA',NULL,2.00,1),
(62,10,'10.006','AQUARIUS',NULL,2.00,1),
(63,10,'10.007','NESTEA',NULL,2.00,1),
(64,10,'10.008','CERVEZA',NULL,2.00,1),
(65,10,'10.009','ZUMO NATURAL',NULL,2.50,1),
(66,11,'11.001','KETCHUP',NULL,0.90,1),
(67,11,'11.002','MAYONESA',NULL,0.90,1),
(68,11,'11.003','MOSTAZA',NULL,0.90,1),
(69,11,'11.004','BARBACOA',NULL,0.90,1),
(70,11,'11.005','BRAVA',NULL,0.90,1),
(71,11,'11.006','ALIOLI',NULL,0.90,1),
(72,1,'1.018','TRUFADA','Tomate, mozzarella, trufa negra, nata',9.80,1),
(73,1,'1.019','SERRANITO','Tomate, mozzarella, jamón serrano, pimiento asado',9.80,1),
(74,1,'1.020','SAN BLAS','Tomate, mozzarella, carne picada, bacon, huevo',9.80,1),
(75,1,'1.021','MICHIGAN','Tomate, mozzarella, pollo, bacon, champiñones, pimiento',9.50,1),
(76,2,'2.008','TORRE PELLI','Carne buey 200g, queso, bacon, cebolla caramelizada, salsa especial',9.00,1),
(77,3,'3.001','PANINO BBQ','Pan artesano, pollo, bacon, salsa BBQ, queso',6.50,1),
(78,3,'3.002','PANINO NEW YORK','Pan artesano, pollo, queso, salsa especial, lechuga',6.00,1),
(79,3,'3.003','PANINO CESAR','Pan artesano, pollo, queso, salsa césar, lechuga, parmesano',6.50,1),
(80,3,'3.004','PANINO ROMA','Pan artesano, jamón, queso, tomate, lechuga',6.50,1),
(81,5,'5.004','KEBAB SOLO CARNE','Solo carne kebab de ternera, sin verduras',8.00,1),
(82,6,'6.001','BAGUETTE VEGETAL',NULL,7.00,1),
(83,6,'6.002','PIRIPI',NULL,6.50,1),
(84,6,'6.003','SERRANITO',NULL,7.00,1),
(85,6,'6.004','PETISU',NULL,6.50,1),
(86,6,'6.005','WANGO',NULL,6.50,1);
/*!40000 ALTER TABLE `Productos` ENABLE KEYS */;
UNLOCK TABLES;
commit;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2026-04-29 22:29:52
