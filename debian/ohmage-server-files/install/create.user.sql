-- Run this at the very end 
CREATE USER 'andwellness'@'localhost' IDENTIFIED BY '&!sickly';
GRANT ALL PRIVILEGES ON andwellness.* TO 'andwellness'@'localhost';
drop user awstemproot;
FLUSH PRIVILEGES;
