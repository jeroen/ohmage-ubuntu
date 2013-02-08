-- Run this at the very end 
FLUSH PRIVILEGES;
CREATE USER 'ohmage'@'localhost' IDENTIFIED BY '&!sickly';
GRANT ALL PRIVILEGES ON ohmage.* TO 'ohmage'@'localhost';

