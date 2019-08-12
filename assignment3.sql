DROP DATABASE IF EXISTS assignment3;
CREATE DATABASE assignment3;
USE assignment3;
CREATE TABLE userList(
	userID INT(11) PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(80) NOT NULL,
    pictureUrl varchar(1000) NOT NULL,
    email varchar(500) UNIQUE NOT NULL
);



CREATE TABLE eventList (
	eventIndex INT(11) PRIMARY KEY AUTO_INCREMENT,
    userID INT(11) NOT NULL,
    summary VARCHAR(50) NOT NULL,
    startDate VARCHAR(30) NOT NULL,
    startTime VARCHAR(30) NOT NULL,
    endDate VARCHAR(30) NOT NULL,
    endTime VARCHAR(30) NOT NULL,
    inputStart VARCHAR(100) NOT NULL,
    inputEnd VARCHAR(100) NOT NULL,
    eventID VARCHAR(500) UNIQUE NOT NULL,
    FOREIGN KEY fk1(userID) REFERENCES userList(userID)
    
);

Create TABLE relationList(
	relationID INT(11) PRIMARY KEY AUTO_INCREMENT,
    userID INT(11) NOT NULL,
    friendID INT(11) NOT NULL,
    FOREIGN KEY fk2(userID) REFERENCES userList(userID),
    FOREIGN KEY fk3(friendID) REFERENCES userList(userID),
    UNIQUE KEY (userID, friendID)
);
