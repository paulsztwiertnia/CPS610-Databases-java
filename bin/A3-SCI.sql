/*CPS610 Group 5
 * Lab 3
 * Eric 
 * Jacob
 * Kourosh
 * Paul Sztwiertnia 
*/

SET SERVEROUTPUT ON;

CREATE DATABASE LINK CEN_CONN
CONNECT TO C##CEN
IDENTIFIED BY abcd1234
USING 'CEN';

CREATE TYPE Student AS OBJECT(
StudentNo VARCHAR(32),
StudentName VARCHAR(64),
GPA Number(4),
Department VARCHAR(64)
);

CREATE TYPE Course AS OBJECT(
CourseNo VARCHAR(32),
CourseName VARCHAR(64),
Credits Number(1),
Department VARCHAR(64)
);

CREATE TYPE Can_Teach AS OBJECT(
CourseNo VARCHAR(32),
ProfName VARCHAR(64),
Preference VARCHAR(64),
Eval VARCHAR(64)
);

CREATE TYPE Teaches AS OBJECT(
CourseNo VARCHAR(64),
ProfName VARCHAR(64),
CTerm VARCHAR(32)
);

CREATE TYPE Enrolled AS OBJECT(
CourseNo VARCHAR(64),
ProfName VARCHAR(64),
StudentNo VARCHAR(32),
Status VARCHAR(64)
);

--SCIENCE

CREATE TABLE Science_Student of Student;
CREATE TABLE Science_Course of Course;
CREATE TABLE Science_Can_Teach of Can_Teach;
CREATE TABLE Science_Teaches of Teaches;
CREATE TABLE Science_Enrolled of Enrolled;

CREATE Table Science_Professor(
ProfName VARCHAR(64) PRIMARY KEY,
SciOffice VARCHAR(64),
SciPhone VARCHAR(13)
);

ALTER TABLE Science_Student
ADD PRIMARY KEY (StudentNo);

ALTER TABLE Science_Course
ADD PRIMARY KEY (CourseNo);

ALTER TABLE Science_Teaches
ADD FOREIGN KEY (CourseNo) REFERENCES Science_Course(CourseNo);

ALTER TABLE Science_Teaches
ADD FOREIGN KEY (ProfName) References Science_Professor(ProfName);

ALTER TABLE Science_Enrolled
ADD FOREIGN KEY (ProfName) References Science_Professor(ProfName);

ALTER TABLE Science_Enrolled
ADD FOREIGN KEY (CourseNo) REFERENCES Science_Course(CourseNo);

ALTER TABLE Science_Enrolled
ADD FOREIGN KEY (StudentNo) References Science_Student(StudentNo);

INSERT INTO Science_Student SELECT * FROM Central_Student@CEN_CONN;
INSERT INTO Science_Course SELECT * FROM Central_Course@CEN_CONN;
INSERT INTO Science_Can_Teach SELECT * FROM Central_Can_Teach@CEN_CONN;
INSERT INTO Science_Teaches SELECT * FROM Central_Teaches@CEN_CONN;
INSERT INTO Science_Enrolled SELECT * FROM Central_Enrolled@CEN_CONN;
INSERT INTO Science_Professor(ProfName, SciOffice, SciPhone) SELECT ProfName, SciOffice, SciPhone FROM Central_Professor@CEN_CONN;

--Test reset statments for p2
INSERT INTO Science_Student(StudentNo, StudentName, GPA, Department) VALUES('3333333333', 'Yellow', '2', 'SCI');
INSERT INTO Science_Enrolled(CourseNo, ProfName, StudentNo, Status) VALUES('CPS111', 'PWhite', '3333333333', 'Enrolled');

Commit;

--Science_Student <- Central_Student
--Science_Course <- Central_Course
--Science_Can_Teach <- Central_Can_Teach
--Science_Teaches <- Central_Teaches
--Science_Enrolled <- Central_Enrolled
--Science_Professor <- �? ProfName, SciOffice, SciPhone(Central_Professor)
--Note: Science Professor statement should be projection, if symbol is broken.
