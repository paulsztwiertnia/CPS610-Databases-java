/*CPS610 Group 5
 * Lab 2
 * Eric  
 * Jacob
 * Kourosh 
 * Paul Sztwiertnia 
*/

SET SERVEROUTPUT ON;
BEGIN
dbms_output.put_line('Hello world!');
END;

CREATE TYPE ST_Rec AS OBJECT
(St_Name VARCHAR(10),
St_Id Number(7),
St_Email VARCHAR(50));

CREATE TABLE st_table of St_Rec;

CREATE TYPE depart_type AS OBJECT
(
Name VARCHAR(50),
Faculty VARCHAR(50),
Building VARCHAR(50),
Phone VARCHAR(14)
);

CREATE TYPE Prof AS OBJECT(
Name VARCHAR(50),
Emp_id VARCHAR(50),
Email VARCHAR(50),
dpt_type depart_type
);

--DROP TABLE Professor;
--DROP TYPE Prof;

CREATE TABLE Professor of Prof;

INSERT INTO Professor(Name, Emp_id, Email, dpt_type) VALUES ('Brown', '11111', 'Brown@uni.ca', depart_type('CS','Science', 'ENG', '(111)111-1111'));
INSERT INTO Professor(Name, Emp_id, Email, dpt_type) VALUES ('Black', '22222', 'Black@uni.ca', depart_type('CS','Science', 'ENG', '(222)111-1111'));
INSERT INTO Professor(Name, Emp_id, Email, dpt_type) VALUES ('Red', '33333', 'Red@uni.ca', depart_type('CS','Science', 'TRS', '(333)111-1111'));
INSERT INTO Professor(Name, Emp_id, Email, dpt_type) VALUES ('Blue', '44444', 'Blue@uni.ca', depart_type('SOC','Sociology', 'TRS', '(444)111-1111'));
INSERT INTO Professor(Name, Emp_id, Email, dpt_type) VALUES ('Yellow', '55555', 'Yellow@uni.ca', depart_type('MTH','MATH', 'MAC', '(555)111-1111'));
INSERT INTO Professor(Name, Emp_id, Email, dpt_type) VALUES ('Green', '66666', 'Green@uni.ca', depart_type('MTH','Math', 'MAC', '(666)111-1111'));

SELECT * FROM Professor;

ALTER TYPE Prof
ADD ATTRIBUTE Income Number(10) CASCADE;

UPDATE Professor SET Income = 100000 WHERE Name = 'Brown';
UPDATE Professor SET Income = 40000 WHERE Name = 'Black';
UPDATE Professor SET Income = 50000 WHERE Name = 'Red';
UPDATE Professor SET Income = 60000 WHERE Name = 'Blue';
UPDATE Professor SET Income = 30000 WHERE Name = 'Yellow';
UPDATE Professor SET Income = 35000 WHERE Name = 'Green';


BEGIN
    FOR i in (select Name, Income from Professor)
    LOOP
        dbms_output.put_line(i.name||' - Taxes:'||i.Income*0.3);    
    END LOOP;
END;

--DROP Procedure income_func;

CREATE OR REPLACE PROCEDURE income_func AS
BEGIN
    For j in (SELECT Name, Income from Professor WHERE Income > 40000)
    LOOP
        dbms_output.put_line(j.Name||' '||j.Income);
    END LOOP;
END;

EXECUTE income_func;

CREATE OR REPLACE PROCEDURE avg_income AS
    total number;
    entries number;
BEGIN
    SELECT sum(Income), Count(*) INTO total, entries From Professor;
    dbms_output.put_line(total/entries);
END;

EXECUTE avg_income;