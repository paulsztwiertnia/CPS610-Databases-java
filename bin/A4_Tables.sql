/*CPS610 Group 5
 * Lab 4
 * Eric 
 * Jacob
 * Kourosh 
 * Paul Sztwiertnia
*/

SET SERVEROUTPUT ON;

--LockStatus: 0 Unlocked, 1 Read-lock, 2 Write-lock
--RID = Record ID
--TID = Transaction ID (holding lock)
CREATE TABLE Lock_Table(
RID Integer,
LockStatus Integer,
TID Integer,
NumReads Integer DEFAULT 0
);

--If Only Old Value, it's a read task
--If Old and New/New only, it's a write task
--Neither, it's a commit
--TID = Transaction ID
CREATE TABLE Transaction_Log(
LogTime Integer,
TID Integer,
RID Integer,
OldValue VARCHAR(64),
NewValue VARCHAR(64),
PrevTime Integer
);

CREATE TABLE A4_Table(
ID Integer,
DataValue Integer
);
