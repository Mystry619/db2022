Use iths;

Drop Table  if exists UNF;


Create Table UNF (
	Id DECIMAL(38,0) Not Null,
	Name Varchar(26) Not Null,
	Grade Varchar(11) Not Null,
	Hobbies Varchar(25),
	City Varchar(10) Not Null,
	School Varchar(30) Not Null,
	HomePhone Varchar(15),
	JobPhone Varchar(15),
	MobilPhone1 Varchar(15),
	MobilPhone2 Varchar(15)
) ENGINE=INNODB;


LOAD DATA INFILE '/var/lib/mysql-files/denormalized-data.csv'
INTO TABLE UNF 
CHARACTER SET latin1
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;




Drop Table if exists Student;
CREATE TABLE Student (
    StudentId INT NOT NULL,
    FirstName VARCHAR(255) NOT NULL,
    LastName VARCHAR(255) NOT NULL,
    CONSTRAINT PRIMARY KEY (StudentId)
)  ENGINE=INNODB;

INSERT INTO Student (StudentID, FirstName, LastName) 
SELECT DISTINCT Id, SUBSTRING_INDEX(Name, ' ', 1), SUBSTRING_INDEX(Name, ' ', -1) 
FROM UNF;

DROP TABLE IF EXISTS School;

CREATE TABLE School AS SELECT DISTINCT 0 AS SchoolId, School As Name, City FROM UNF;

SET @Id = 0;

UPDATE School SET SchoolId = (SELECT @Id := @Id + 1);
ALTER TABLE School ADD PRIMARY KEY(SchoolId);

DROP TABLE IF EXISTS StudentSchool;
CREATE TABLE StudentSchool AS SELECT DISTINCT UNF.Id AS StudentId, School.SchoolId FROM UNF INNER JOIN School ON UNF.School = School.Name;
ALTER TABLE StudentSchool MODIFY COLUMN StudentId INT;
ALTER TABLE StudentSchool MODIFY COLUMN SchoolId INT;
ALTER TABLE StudentSchool ADD PRIMARY KEY (StudentId, SchoolId);




