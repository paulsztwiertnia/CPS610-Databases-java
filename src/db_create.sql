CREATE DATABASE "sci"
MAXINSTANCES 8
MAXLOGHISTORY 1
MAXLOGFILES 16
MAXLOGMEMBERS 3
MAXDATAFILES 1024
DATAFILE 'D:\OracleBase\oradata\SCI\system01.dbf' SIZE 700M REUSE AUTOEXTEND ON NEXT  10240K MAXSIZE UNLIMITED
EXTENT MANAGEMENT LOCAL
SYSAUX DATAFILE 'D:\OracleBase\oradata\SCI\sysaux01.dbf' SIZE 550M REUSE AUTOEXTEND ON NEXT  10240K MAXSIZE UNLIMITED
SMALLFILE DEFAULT TEMPORARY TABLESPACE TEMP TEMPFILE 'D:\OracleBase\oradata\SCI\temp01.dbf' SIZE 20M REUSE AUTOEXTEND ON NEXT  640K MAXSIZE UNLIMITED
SMALLFILE UNDO TABLESPACE "UNDOTBS1" DATAFILE  'D:\OracleBase\oradata\SCI\undotbs01.dbf' SIZE 200M REUSE AUTOEXTEND ON NEXT  5120K MAXSIZE UNLIMITED
CHARACTER SET AL32UTF8
NATIONAL CHARACTER SET AL16UTF16
LOGFILE GROUP 1 ('D:\OracleBase\oradata\SCI\redo01.log') SIZE 200M,
GROUP 2 ('D:\OracleBase\oradata\SCI\redo02.log') SIZE 200M,
GROUP 3 ('D:\OracleBase\oradata\SCI\redo03.log') SIZE 200M
USER SYS IDENTIFIED BY "&&sysPassword" USER SYSTEM IDENTIFIED BY "&&systemPassword"
enable pluggable database
seed file_name_convert=('D:\OracleBase\oradata\SCI\system01.dbf','D:\OracleBase\oradata\SCI\pdbseed\system01.dbf','D:\OracleBase\oradata\SCI\sysaux01.dbf','D:\OracleBase\oradata\SCI\pdbseed\sysaux01.dbf','D:\OracleBase\oradata\SCI\temp01.dbf','D:\OracleBase\oradata\SCI\pdbseed\temp01.dbf','D:\OracleBase\oradata\SCI\undotbs01.dbf','D:\OracleBase\oradata\SCI\pdbseed\undotbs01.dbf') LOCAL UNDO ON;

CREATE DATABASE "cen"
MAXINSTANCES 8
MAXLOGHISTORY 1
MAXLOGFILES 16
MAXLOGMEMBERS 3
MAXDATAFILES 1024
DATAFILE 'D:\oraclebase\oradata\CEN\system01.dbf' SIZE 700M REUSE AUTOEXTEND ON NEXT  10240K MAXSIZE UNLIMITED
EXTENT MANAGEMENT LOCAL
SYSAUX DATAFILE 'D:\oraclebase\oradata\CEN\sysaux01.dbf' SIZE 550M REUSE AUTOEXTEND ON NEXT  10240K MAXSIZE UNLIMITED
SMALLFILE DEFAULT TEMPORARY TABLESPACE TEMP TEMPFILE 'D:\oraclebase\oradata\CEN\temp01.dbf' SIZE 20M REUSE AUTOEXTEND ON NEXT  640K MAXSIZE UNLIMITED
SMALLFILE UNDO TABLESPACE "UNDOTBS1" DATAFILE  'D:\oraclebase\oradata\CEN\undotbs01.dbf' SIZE 200M REUSE AUTOEXTEND ON NEXT  5120K MAXSIZE UNLIMITED
CHARACTER SET AL32UTF8
NATIONAL CHARACTER SET AL16UTF16
LOGFILE GROUP 1 ('D:\oraclebase\oradata\CEN\redo01.log') SIZE 200M,
GROUP 2 ('D:\oraclebase\oradata\CEN\redo02.log') SIZE 200M,
GROUP 3 ('D:\oraclebase\oradata\CEN\redo03.log') SIZE 200M
USER SYS IDENTIFIED BY "&&sysPassword" USER SYSTEM IDENTIFIED BY "&&systemPassword"
enable pluggable database
seed file_name_convert=('D:\oraclebase\oradata\CEN\system01.dbf','D:\oraclebase\oradata\CEN\pdbseed\system01.dbf','D:\oraclebase\oradata\CEN\sysaux01.dbf','D:\oraclebase\oradata\CEN\pdbseed\sysaux01.dbf','D:\oraclebase\oradata\CEN\temp01.dbf','D:\oraclebase\oradata\CEN\pdbseed\temp01.dbf','D:\oraclebase\oradata\CEN\undotbs01.dbf','D:\oraclebase\oradata\CEN\pdbseed\undotbs01.dbf') LOCAL UNDO ON;

CREATE DATABASE "eng"
MAXINSTANCES 8
MAXLOGHISTORY 1
MAXLOGFILES 16
MAXLOGMEMBERS 3
MAXDATAFILES 1024
DATAFILE 'D:\OracleBase\oradata\ENG\system01.dbf' SIZE 700M REUSE AUTOEXTEND ON NEXT  10240K MAXSIZE UNLIMITED
EXTENT MANAGEMENT LOCAL
SYSAUX DATAFILE 'D:\OracleBase\oradata\ENG\sysaux01.dbf' SIZE 550M REUSE AUTOEXTEND ON NEXT  10240K MAXSIZE UNLIMITED
SMALLFILE DEFAULT TEMPORARY TABLESPACE TEMP TEMPFILE 'D:\OracleBase\oradata\ENG\temp01.dbf' SIZE 20M REUSE AUTOEXTEND ON NEXT  640K MAXSIZE UNLIMITED
SMALLFILE UNDO TABLESPACE "UNDOTBS1" DATAFILE  'D:\OracleBase\oradata\ENG\undotbs01.dbf' SIZE 200M REUSE AUTOEXTEND ON NEXT  5120K MAXSIZE UNLIMITED
CHARACTER SET AL32UTF8
NATIONAL CHARACTER SET AL16UTF16
LOGFILE GROUP 1 ('D:\OracleBase\oradata\ENG\redo01.log') SIZE 200M,
GROUP 2 ('D:\OracleBase\oradata\ENG\redo02.log') SIZE 200M,
GROUP 3 ('D:\OracleBase\oradata\ENG\redo03.log') SIZE 200M
USER SYS IDENTIFIED BY "&&sysPassword" USER SYSTEM IDENTIFIED BY "&&systemPassword"
enable pluggable database
seed file_name_convert=('D:\OracleBase\oradata\ENG\system01.dbf','D:\OracleBase\oradata\ENG\pdbseed\system01.dbf','D:\OracleBase\oradata\ENG\sysaux01.dbf','D:\OracleBase\oradata\ENG\pdbseed\sysaux01.dbf','D:\OracleBase\oradata\ENG\temp01.dbf','D:\OracleBase\oradata\ENG\pdbseed\temp01.dbf','D:\OracleBase\oradata\ENG\undotbs01.dbf','D:\OracleBase\oradata\ENG\pdbseed\undotbs01.dbf') LOCAL UNDO ON;