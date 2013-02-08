-- Run this at the very end 
CREATE USER 'ohmage'@'localhost' IDENTIFIED BY '&!sickly';
GRANT ALL PRIVILEGES ON ohmage.* TO 'ohmage'@'localhost';
drop user awstemproot;
FLUSH PRIVILEGES;
