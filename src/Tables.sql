DROP TABLE student;
DROP TABLE course;
DROP TABLE section;
DROP TABLE grade_report;
DROP TABLE prerequisite;


CREATE TABLE student(
    Name VARCHAR(32),
    Student_number INT,
    Class VARCHAR(16),
    Major VARCHAR(16)
);

CREATE TABLE course(
  Course_name VARCHAR(128),
  Course_number VARCHAR(128),
  Credit_hours INT,
  Department VARCHAR(32)
);

CREATE TABLE section(
    Section_identifier INT,
    Course_number VARCHAR(128),
    Semester VARCHAR(128),
    Year INT,
    Instructor VARCHAR(64)
);

CREATE TABLE grade_report(
    Student_number INT,
    Section_identifier INT,
    Grade VARCHAR(2)
);

CREATE TABLE prerequisite(
  Course_number VARCHAR(128),
  Prerequisite_number VARCHAR(128)
);

INSERT INTO student(Name, Student_number, Class, Major) VALUES('Violet', 1, 1, 'CS');
INSERT INTO student(Name, Student_number, Class, Major) VALUES('Brown', 2, 1, 'CS');
INSERT INTO student(Name, Student_number, Class, Major) VALUES('White', 3, 1, 'CS');
INSERT INTO student(Name, Student_number, Class, Major) VALUES('Black', 4, 1, 'CS');
INSERT INTO student(Name, Student_number, Class, Major) VALUES('Yellow', 5, 1, 'CS');
INSERT INTO student(Name, Student_number, Class, Major) VALUES('Red', 6, 2, 'CS');
INSERT INTO student(Name, Student_number, Class, Major) VALUES('Blue', 7, 2, 'CS');
INSERT INTO student(Name, Student_number, Class, Major) VALUES('Orange', 8, 2, 'CS');
INSERT INTO student(Name, Student_number, Class, Major) VALUES('Grey', 9, 2, 'CS');
INSERT INTO student(Name, Student_number, Class, Major) VALUES('Purple', 10, 2, 'CS');
INSERT INTO grade_report(Student_number, Section_identifier, Grade) VALUES (1, 111, 'A');
INSERT INTO grade_report(Student_number, Section_identifier, Grade) VALUES (1, 112, 'B');
INSERT INTO grade_report(Student_number, Section_identifier, Grade) VALUES (1, 113, 'A');
INSERT INTO grade_report(Student_number, Section_identifier, Grade) VALUES (1, 114, 'B');
INSERT INTO grade_report(Student_number, Section_identifier, Grade) VALUES (1, 115, 'A');
INSERT INTO grade_report(Student_number, Section_identifier, Grade) VALUES (2, 111, 'C');
INSERT INTO grade_report(Student_number, Section_identifier, Grade) VALUES (2, 112, 'B');
INSERT INTO grade_report(Student_number, Section_identifier, Grade) VALUES (2, 113, 'C');
INSERT INTO grade_report(Student_number, Section_identifier, Grade) VALUES (2, 114, 'B');
INSERT INTO grade_report(Student_number, Section_identifier, Grade) VALUES (2, 115, 'C');
INSERT INTO grade_report(Student_number, Section_identifier, Grade) VALUES (3, 111, 'C');
INSERT INTO grade_report(Student_number, Section_identifier, Grade) VALUES (3, 112, 'D');
INSERT INTO grade_report(Student_number, Section_identifier, Grade) VALUES (3, 113, 'C');
INSERT INTO grade_report(Student_number, Section_identifier, Grade) VALUES (3, 114, 'C');
INSERT INTO grade_report(Student_number, Section_identifier, Grade) VALUES (3, 115, 'D');
INSERT INTO grade_report(Student_number, Section_identifier, Grade) VALUES (4, 111, 'D');
INSERT INTO grade_report(Student_number, Section_identifier, Grade) VALUES (4, 112, 'F');
INSERT INTO grade_report(Student_number, Section_identifier, Grade) VALUES (4, 113, 'F');
INSERT INTO grade_report(Student_number, Section_identifier, Grade) VALUES (4, 114, 'F');
INSERT INTO grade_report(Student_number, Section_identifier, Grade) VALUES (4, 115, 'F');
INSERT INTO section(section_identifier, Course_number, semester, year, instructor) VALUES(111, 'AB111', 'Fall', 07, 'King');
INSERT INTO section(section_identifier, Course_number, semester, year, instructor) VALUES(112, 'CD112', 'Fall', 07, 'Queen');
INSERT INTO section(section_identifier, Course_number, semester, year, instructor) VALUES(113, 'EF113', 'Fall', 07, 'Jack');
INSERT INTO section(section_identifier, Course_number, semester, year, instructor) VALUES(114, 'GH114', 'Fall', 07, 'Ace');
INSERT INTO section(section_identifier, Course_number, semester, year, instructor) VALUES(115, 'IJ115', 'Fall', 07, 'Club');
INSERT INTO course(Course_name, Course_number, Credit_hours, Department) VALUES('Intro to AB', 'AB111', 1, 'CS');
INSERT INTO course(Course_name, Course_number, Credit_hours, Department) VALUES('Intro to CD', 'CD112', 1, 'CS');
INSERT INTO course(Course_name, Course_number, Credit_hours, Department) VALUES('Intro to EF', 'EF113', 1, 'CS');
INSERT INTO course(Course_name, Course_number, Credit_hours, Department) VALUES('Intro to GH', 'GH114', 1, 'CS');
INSERT INTO course(Course_name, Course_number, Credit_hours, Department) VALUES('Intro to IJ', 'IJ115', 1, 'CS');