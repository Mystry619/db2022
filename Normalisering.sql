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


DROP TABLE IF EXISTS Phone;
CREATE TABLE Phone (
	PhoneId INT NOT NULL AUTO_INCREMENT,
	StudentId INT NOT NULL,
	Type VARCHAR(32),
	Number VARCHAR(32) NOT NULL,
	CONSTRAINT PRIMARY KEY(PhoneId));

INSERT INTO Phone(StudentId,Type,Number) SELECT Id AS StudentId, "Home" AS Type, HomePhone AS Number FROM UNF WHERE HomePhone IS NOT NULL AND HomePhone != ''
UNION SELECT Id AS StudentId, "Job" AS TYPE, JobPhone AS Number FROM UNF WHERE JobPhone IS NOT NULL AND JobPhone != ''
UNION SELECT Id AS StudnetId, "Mobil" AS Type, MobilPhone1 AS Number FROM UNF WHERE MobilPhone1 IS NOT NULL AND MobilPhone1 != ''
UNION SELECT Id AS StudentId, "Mobil" AS Type, MobilPhone2 AS Number FROM UNF WHERE MobilPhone2 IS NOT NULL AND MobilPhone2 != '';

DROP VIEW IF EXISTS PhoneList;
CREATE VIEW PhoneList AS SELECT StudentId, group_concat(Number) AS Numbers FROM Phone GROUP BY StudentId;


DROP TABLE IF EXISTS Hobbies;
CREATE TABLE Hobbies(
	HobbyId INT NOT NULL AUTO_INCREMENT,
	Name VARCHAR(255) NOT NULL,
	CONSTRAINT PRIMARY KEY (HobbyId))
ENGINE = INNODB;

INSERT INTO Hobbies(Name)
SELECT DISTINCT Hobby FROM (
	SELECT Id as StudentId, TRIM(SUBSTRING_INDEX(Hobbies,",",1)) AS Hobby FROM UNF Where Hobbies != ""
	UNION SELECT Id AS StudentId, TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(Hobbies,",",-2),",",1)) FROM UNF WHERE Hobbies != ""
	UNION SELECT Id AS StudentId, TRIM(SUBSTRING_INDEX(Hobbies,",",-1)) FROM UNF WHERE Hobbies != "") AS Hobbies2;


DROP TABLE IF EXISTS StudentHobby;
CREATE TABLE StudentHobby(
        StudentId INT NOT NULL,
        HobbyId INT NOT NULL,
        CONSTRAINT PRIMARY KEY (StudentId, HobbyId))
ENGINE = INNODB;

INSERT INTO StudentHobby(StudentId,HobbyId)
SELECT DISTINCT StudentId,HobbyId FROM (
        SELECT Id AS StudentId, TRIM(SUBSTRING_INDEX(Hobbies, ",", 1)) AS Hobby FROM UNF
  WHERE HOBBIES != ""
  UNION SELECT Id AS StudentId, TRIM(SUBSTRING_INDEX(substring_index(Hobbies, ",", -2),"," ,1)) FROM UNF
  WHERE HOBBIES != ""
  UNION SELECT Id AS StudentId, TRIM(SUBSTRING_INDEX(Hobbies, ",", -1)) FROM UNF
  WHERE HOBBIES != ""
) AS Hobbies2 INNER JOIN Hobbies ON Hobbies2.Hobby = Hobbies.Name;


DROP VIEW IF EXISTS HobbiesList;
CREATE VIEW HobbiesList AS SELECT StudentId, group_concat(Name) AS Name FROM StudentHobby JOIN Hobbies USING (HobbyId) GROUP BY StudentId;


DROP TABLE IF EXISTS Grade;
CREATE TABLE Grade(
	GradeId INT NOT NULL AUTO_INCREMENT,
	Name VARCHAR(255) NOT NULL,
	CONSTRAINT PRIMARY KEY(GradeId))
ENGINE = INNODB;

INSERT INTO Grade(Name) SELECT DISTINCT Grade FROM UNF;

ALTER TABLE Student ADD COLUMN GradeID INT NOT NULL;

UPDATE Student JOIN UNF ON (StudentID = Id) JOIN Grade ON Grade.Name = UNF.Grade SET Student.GradeId = Grade.GradeId;




DROP VIEW IF EXISTS Avslut;
CREATE VIEW Avslut AS
SELECT StudentId as ID, Student.FirstName,Student.LastName, Grade.Name AS Grade, HobbiesList.Name, School.Name AS School, City, Numbers FROM StudentSchool
LEFT JOIN Student USING (StudentId)
LEFT JOIN Grade USING (GradeId)
LEFT JOIN HobbiesList USING (StudentId)
LEFT JOIN School USING (SchoolId)
LEFT JOIN PhoneList USING (StudentId);









