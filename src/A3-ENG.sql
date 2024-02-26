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

--ENGINEERING
CREATE TABLE Engineering_Student of Student;
CREATE TABLE Engineering_Course of Course;
CREATE TABLE Engineering_Can_Teach of Can_Teach;
CREATE TABLE Engineering_Teaches of Teaches;
CREATE TABLE Engineering_Enrolled of Enrolled;

CREATE Table Engineering_Professor(
ProfName VARCHAR(64) PRIMARY KEY,
EngOffice VARCHAR(64),
EngPhone VARCHAR(13)
);

ALTER TABLE Engineering_Student
ADD PRIMARY KEY (StudentNo);

ALTER TABLE Engineering_Course
ADD PRIMARY KEY (CourseNo);

ALTER TABLE Engineering_Teaches
ADD FOREIGN KEY (CourseNo) REFERENCES Engineering_Course(CourseNo);

ALTER TABLE Engineering_Teaches
ADD FOREIGN KEY (ProfName) References Engineering_Professor(ProfName);

ALTER TABLE Engineering_Enrolled
ADD FOREIGN KEY (ProfName) References Engineering_Professor(ProfName);

ALTER TABLE Engineering_Enrolled
ADD FOREIGN KEY (CourseNo) REFERENCES Engineering_Course(CourseNo);

ALTER TABLE Engineering_Enrolled
ADD FOREIGN KEY (StudentNo) References Engineering_Student(StudentNo);

INSERT INTO Engineering_Student SELECT * FROM Central_Student@CEN_CONN;
INSERT INTO Engineering_Course SELECT * FROM Central_Course@CEN_CONN;
INSERT INTO Engineering_Can_Teach SELECT * FROM Central_Can_Teach@CEN_CONN;
INSERT INTO Engineering_Teaches SELECT * FROM Central_Teaches@CEN_CONN;
INSERT INTO Engineering_Enrolled SELECT * FROM Central_Enrolled@CEN_CONN;
INSERT INTO Engineering_Professor(ProfName, EngOffice, EngPhone) SELECT ProfName, SciOffice, SciPhone FROM Central_Professor@CEN_CONN;

Commit;

--Engineering_Student <- Central_Student
--Engineering_Course <- Central_Course
--Engineering_Can_Teach <- Central_Can_Teach
--Engineering_Teaches <- Central_Teaches
--Engineering_Enrolled <- Central_Enrolled
--Engineering_Professor <- �? ProfName, EngOffice, EngPhone(Central_Professor)
--Note: Engineeering Professor statement should be projection, if symbol is broken.
SELECT * FROM Engineering_Student;

