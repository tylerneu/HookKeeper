DROP DATABASE IF EXISTS `WebSockets`;
CREATE DATABASE `WebSockets`;

use `WebSockets`;

CREATE TABLE `pulls` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `make` varchar(256) NOT NULL DEFAULT '',
  `model` varchar(256) NOT NULL DEFAULT '',
  `distance` int(11),
  `notified` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `pulls` (make, model) VALUES
  ('John Deere', '4430'), 
  ('Oliver', '2255'), 
  ('International', '1066'), 
  ('Ford', '9600'), 
  ('Allis Chalmers', '7030');