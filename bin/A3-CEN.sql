/*CPS610 Group 5
 * Lab 3
 * Eric 
 * Jacob 
 * Kourosh 
 * Paul Sztwiertnia 
*/

SET SERVEROUTPUT ON;

--DATABASE LINKS
CREATE DATABASE LINK ENG_CONN
CONNECT TO C##ENG
IDENTIFIED BY abcd1234
USING 'ENG';

CREATE DATABASE LINK SCI_CONN
CONNECT TO C##SCI
IDENTIFIED BY abcd1234
USING 'SCI';
--DATABASE LINKS

--TYPE CREATION
CREATE TYPE Student AS OBJECT(
StudentNo VARCHAR(32),
StudentName VARCHAR(64),
GPA Number(4),
Department VARCHAR(64)
);

DROP TYPE Student;
DROP TABLE Central_Student;

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
--TYPE CREATION

--TABLE CREATION
CREATE TABLE Central_Student of Student;
CREATE TABLE Central_Course of Course;
CREATE TABLE Central_Can_Teach of Can_Teach;
CREATE TABLE Central_Teaches of Teaches;
CREATE TABLE Central_Enrolled of Enrolled;

CREATE TABLE Central_Professor(
ProfName VARCHAR(64) PRIMARY KEY,
EngOffice VARCHAR(64),
EngPhone VARCHAR(13),
SciOffice VARCHAR(64),
SciPhone VARCHAR(13)
);

ALTER TABLE Central_Student
ADD PRIMARY KEY (StudentNo);

ALTER TABLE Central_Course
ADD PRIMARY KEY (CourseNo);

ALTER TABLE Central_Teaches
ADD FOREIGN KEY (CourseNo) REFERENCES Central_Course(CourseNo);

ALTER TABLE Central_Teaches
ADD FOREIGN KEY (ProfName) References Central_Professor(ProfName);

ALTER TABLE Central_Enrolled
ADD FOREIGN KEY (ProfName) References Central_Professor(ProfName);

ALTER TABLE Central_Enrolled
ADD FOREIGN KEY (CourseNo) REFERENCES Central_Course(CourseNo);

ALTER TABLE Central_Enrolled
ADD FOREIGN KEY (StudentNo) References Central_Student(StudentNo);
--TABLE CREATION

--TABLE INSERTION
INSERT INTO Central_Student(StudentNo, StudentName, GPA, Department) VALUES('1111111111', 'Red', '4', 'CS');
INSERT INTO Central_Student(StudentNo, StudentName, GPA, Department) VALUES('2222222222', 'Blue', '3', 'MTH');
INSERT INTO Central_Student(StudentNo, StudentName, GPA, Department) VALUES('3333333333', 'Yellow', '2', 'SCI');
INSERT INTO Central_Student(StudentNo, StudentName, GPA, Department) VALUES('4444444444', 'Green', '1', 'ENG');

INSERT INTO Central_Professor(ProfName, EngOffice, EngPhone, SciOffice, SciPhone) VALUES('PBlack', 'ENG', '(111)111-1111', 'SCI', '(121)111-1111');
INSERT INTO Central_Professor(ProfName, EngOffice, EngPhone, SciOffice, SciPhone) VALUES('PGrey', 'ENG', '(222)222-2222', 'SCI', '(212)222-2222');
INSERT INTO Central_Professor(ProfName, EngOffice, EngPhone, SciOffice, SciPhone) VALUES('PWhite', 'ENG', '(333)333-3333', 'SCI', '(313)333-3333');
INSERT INTO Central_Professor(ProfName, EngOffice, EngPhone, SciOffice, SciPhone) VALUES('PBrown', 'ENG', '(444)444-4444', 'SCI', '(414)444-4444');

INSERT INTO Central_Course(CourseNo, CourseName, Credits, Department) VALUES('MTH111', 'Math 1', 1, 'MTH');
INSERT INTO Central_Course(CourseNo, CourseName, Credits, Department) VALUES('ENG111', 'Engineering 1', 1, 'ENG');
INSERT INTO Central_Course(CourseNo, CourseName, Credits, Department) VALUES('CPS111', 'Comp Sci 1', 1, 'SCI');
INSERT INTO Central_Course(CourseNo, CourseName, Credits, Department) VALUES('SOC111', 'Sociology 1', 1, 'SOC');

INSERT INTO Central_Can_Teach(CourseNo, ProfName, Preference, Eval) VALUES('MTH111', 'PBlack', 'Fall', 'Good');
INSERT INTO Central_Can_Teach(CourseNo, ProfName, Preference, Eval) VALUES('ENG111', 'PGrey', 'Fall', 'Good');
INSERT INTO Central_Can_Teach(CourseNo, ProfName, Preference, Eval) VALUES('CPS111', 'PWhite', 'Spring', 'Good');
INSERT INTO Central_Can_Teach(CourseNo, ProfName, Preference, Eval) VALUES('SOC111', 'PBrown', 'Winter', 'Good');

INSERT INTO Central_Teaches(CourseNo, ProfName, CTerm) VALUES('MTH111', 'PBlack', 'Fall2022');
INSERT INTO Central_Teaches(CourseNo, ProfName, CTerm) VALUES('ENG111', 'PGrey', 'Fall2022');
INSERT INTO Central_Teaches(CourseNo, ProfName, CTerm) VALUES('CPS111', 'PWhite', 'Spring2020');
INSERT INTO Central_Teaches(CourseNo, ProfName, CTerm) VALUES('SOC111', 'PBrown', 'Spring2022');

INSERT INTO Central_Enrolled(CourseNo, ProfName, StudentNo, Status) VALUES('MTH111', 'PBlack', '1111111111', 'Enrolled');
INSERT INTO Central_Enrolled(CourseNo, ProfName, StudentNo, Status) VALUES('ENG111', 'PGrey', '2222222222', 'Enrolled');
INSERT INTO Central_Enrolled(CourseNo, ProfName, StudentNo, Status) VALUES('CPS111', 'PWhite', '3333333333', 'Enrolled');
INSERT INTO Central_Enrolled(CourseNo, ProfName, StudentNo, Status) VALUES('SOC111', 'PBrown', '4444444444', 'Enrolled');
--TABLE INSERTION
COMMIT;

SELECT * FROM Central_Student;
SELECT * FROM Central_Professor;

--DELETE TO CHECK STATEMENTS IN P1, Q4
DELETE FROM Central_Can_Teach;
DELETE FROM Central_Teaches;
DELETE FROM Central_Enrolled;

DELETE FROM Central_Student;
DELETE FROM Central_Professor;
DELETE FROM Central_Course;

--Q4
INSERT INTO Central_Student SELECT * FROM Engineering_Student@ENG_CONN UNION SELECT * FROM Science_Student@SCI_CONN;

INSERT INTO Central_Professor(ProfName, EngOffice, EngPhone, SciOffice, SciPhone)
SELECT ENG.ProfName, ENG.EngOffice, ENG.EngPhone, SCI.SciOffice, SCI.SciPhone FROM Engineering_Professor@ENG_CONN ENG
INNER JOIN Science_Professor@SCI_CONN SCI ON ENG.ProfName = SCI.ProfName;

INSERT INTO Central_Course SELECT * FROM Engineering_Course@ENG_CONN UNION SELECT * FROM Science_Course@SCI_CONN;
INSERT INTO Central_Can_Teach SELECT * FROM Engineering_Can_Teach@ENG_CONN UNION SELECT * FROM Science_Can_Teach@SCI_CONN;
INSERT INTO Central_Teaches SELECT * FROM Engineering_Teaches@ENG_CONN UNION SELECT * FROM Science_Teaches@SCI_CONN;
INSERT INTO Central_Enrolled SELECT * FROM Engineering_Enrolled@ENG_CONN UNION SELECT * FROM Science_Enrolled@SCI_CONN;
--Q4

--PART 2
CREATE TABLE Central_Course_Size(
Capsize int,
CourseNo VARCHAR(64) REFERENCES Central_Course(CourseNo)
);

INSERT INTO Central_Course_Size(CourseNo, Capsize) VALUES('MTH111', 5);
INSERT INTO Central_Course_Size(CourseNo, Capsize) VALUES('ENG111', 5);
INSERT INTO Central_Course_Size(CourseNo, Capsize) VALUES('CPS111', 5);
INSERT INTO Central_Course_Size(CourseNo, Capsize) VALUES('SOC111', 5);

--DEBUG
SELECT * FROM Central_Enrolled;
SELECT * FROM Central_Teaches;
SELECT * FROM Central_Can_Teach;
SELECT * FROM Central_Course;

--PART 2 CODE
DECLARE
 /* Student changing classes */
 movingStudent varchar(64);
 
 /* Classes size information */
 capLimit int;
 currentSize int;
BEGIN
 /* Select student that wants to change departments such as John*/
 SELECT StudentNo into movingStudent FROM Central_Student WHERE StudentName='Yellow';
 SELECT Capsize into capLimit FROM Central_Course_Size WHERE CourseNo ='CPS111';
 SELECT COUNT(*) into currentSize FROM Central_Course WHERE CourseNo='CPS111';
 /* Finds the class size and class limit of some engineering course such as 203 */
 
 IF (currentSize >= caplimit) 

THEN
 /* do not let the student change departments if course has enough capacity*/
 dbms_output.put_line('Did not change departments.');
 ELSE
 /* drop the student's science courses if leaving the department*/
 DELETE FROM Central_Enrolled WHERE CourseNo in (SELECT CourseNo FROM Central_Course) and StudentNo = movingStudent;
 DELETE FROM Science_Enrolled@SCI_CONN WHERE CourseNo in (SELECT CourseNo FROM Science_Course@SCI_CONN) and StudentNo = movingStudent;
 
 /* move the student from the science database to the engineering database */
 INSERT INTO Engineering_Student@ENG_CONN SELECT * FROM Science_Student@SCI_CONN WHERE StudentNo=movingStudent;
 DELETE FROM Science_Student@SCI_CONN WHERE StudentNo = movingStudent;
 /* add the student into some engineering courses */
 INSERT INTO Engineering_Enrolled@ENG_CONN(CourseNo, ProfName, StudentNo, Status) SELECT EC.CourseNo, ProfName, movingStudent as StudentNo, 'Enrolled' as Status FROM Engineering_Course@ENG_CONN EC
 INNER JOIN Engineering_Teaches@ENG_CONN ET ON EC.CourseNo = ET.CourseNo WHERE Department='ENG';
 
 END IF;
 dbms_output.put_line('Finished');
END;