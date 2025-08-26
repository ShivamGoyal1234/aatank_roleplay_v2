
CREATE TABLE IF NOT EXISTS `ak4y_dailytasks` (
  `#` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) NOT NULL,
  `playTime` int(11) DEFAULT NULL,
  `selectedTask` varchar(50) NOT NULL,
  `taskResetTime` datetime NOT NULL,
  `done` int(11) DEFAULT 0,
  PRIMARY KEY (`#`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8;
