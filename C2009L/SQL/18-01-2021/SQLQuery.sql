﻿CREATE DATABASE StudentManagementSystem;
USE StudentManagementSystem;
CREATE TABLE Class(
	ClassId INT NOT NULL,
	ClassCode NVARCHAR(50)
);
CREATE TABLE Student(
	StudentId INT NOT NULL,
	StudentName NVARCHAR(50),
	BirthDate DATETIME,
	ClassId INT
);
CREATE TABLE Subject(
	SubjectId INT NOT NULL,
	SubjectName NVARCHAR(100),
	SessionCount INT 
);

CREATE TABLE Result(
	StudentId INT NOT NULL,
	SubjectId INT NOT NULL,
	Mark INT 
);
CREATE NONCLUSTERED INDEX IX_StudentName   
ON Student (StudentName);   

DROP INDEX IX_StudentName ON Student;

ALTER TABLE Result
ALTER COLUMN Mark FLOAT;

ALTER TABLE Class
ADD CONSTRAINT PK_Class PRIMARY KEY (ClassId);

--ALTER TABLE Class DROP CONSTRAINT PK_Class; -- ko thi
ALTER TABLE Student
ADD CONSTRAINT PK_Student PRIMARY KEY (StudentId);
ALTER TABLE Subject
ADD CONSTRAINT PK_Subject PRIMARY KEY (SubjectId);

ALTER TABLE Result
ADD CONSTRAINT PK_Result PRIMARY KEY (StudentId, SubjectId);

ALTER TABLE Subject
ADD CONSTRAINT CK_Subject_SessionCount CHECK(SessionCount >= 0);

ALTER TABLE Subject 
DROP CONSTRAINT CK_Subject_SessionCount;

ALTER TABLE Student
ADD CONSTRAINT FK_Student_Class
FOREIGN KEY (ClassId) REFERENCES Class(ClassId);
INSERT INTO Class(ClassId, ClassCode) VALUES
(1, 'C1106KV'),
(2, 'C1108GV'),
(3, 'C1108IV'),
(4, 'C1108HV'),
(5, 'C1109GV');
SELECT * FROM Class;

INSERT INTO Student(StudentId, StudentName, BirthDate,ClassId)
VALUES(1,N'PhạmTuấnAnh', '1993/08/05', 1);

INSERT INTO Student(StudentId, StudentName, BirthDate,ClassId)
VALUES(2, N'PhanVănHuy', '1996/06/10', 1);

INSERT INTO Student(StudentId, StudentName, BirthDate,ClassId)
VALUES(3, N'NguyễnHoàng Minh', '1992/09/07', 2),
(4, N'TrầnTuấnTú', '1993/10/10', 2),
(5, N'ĐỗAnhTài', '1992/06/06', 3);

SELECT * FROM Student;
INSERT INTO Subject(SubjectId, SubjectName, SessionCount) VALUES
(1, N'C Programming', 22),
(2, N'Web Design', 18),
(3, N'Database Management', 23);
SELECT * FROM Subject;

INSERT INTO Result(StudentId, SubjectId, Mark) VALUES
(1,1,8),
(1,2,7),
(2,3,5),
(3,2,6),
(4,3,9),
(5,2,8);
SELECT * FROM Result;

SELECT * FROM Student 
ORDER BY StudentId
OFFSET 2*2 ROWS
FETCH NEXT 2 ROWS ONLY;

SELECT * FROM Student;
--inner join 2 tables
SELECT 
	Class.ClassCode, Student.StudentName, Student.BirthDate
FROM Class 
	INNER JOIN Student
ON 
	Class.ClassId = Student.ClassId
ORDER BY Class.ClassCode;


CREATE VIEW ViewGetStudentClassSubject AS
SELECT 
	Student.StudentId, 
	Student.StudentName AS FullName, 
	REVERSE(SUBSTRING(REVERSE(StudentName), 1, CHARINDEX(' ', REVERSE(StudentName)) - 1)) as Name,
	Student.BirthDate, 
	Class.ClassCode,
	Result.Mark,
	Subject.SubjectName	
FROM Student
INNER JOIN Class
ON 
	Class.ClassId = Student.ClassId
INNER JOIN Result
	ON Result.StudentId = Result.StudentId
INNER JOIN Subject
	ON Result.SubjectId = Subject.SubjectId
--ORDER BY Name;
SELECT * FROM ViewGetStudentClassSubject;

DROP VIEW ViewGetStudentClassSubject;

SELECT
  REVERSE(SUBSTRING(REVERSE(StudentName), 1, CHARINDEX(' ', REVERSE(StudentName)) - 1)) AS LastName
FROM
  Student;

 UPDATE Student SET StudentName = N'Đỗ Anh Tài'
 WHERE StudentId = 5;

 SELECT * FROM Student;
 DELETE FROM Student WHERE StudentId = 5;

 SELECT * FROM ViewGetStudentClassSubject ORDER BY Name DESC;
 DELETE FROM ViewGetStudentClassSubject WHERE StudentId = 4;

 --calculated fields
 CREATE TABLE DiemThi(
	id INT PRIMARY KEY IDENTITY(1,1),
	math FLOAT NOT NULL,
	physics FLOAT NOT NULL,
	chemistry FLOAT NOT NULL,
	--rang buoc : diem > 0 va <= 10
 );
 INSERT INTO DiemThi(math, physics, chemistry)
 VALUES
 (8,  7,  5.5),
 (9,  3,  6),
 (7,  6,  3),
 (5,  8,  3),
 (4,  9,  1),
 (3,  4,  2)

SELECT * FROM Student WHERE StudentId BETWEEN 2 AND 4;

DROP PROCEDURE findSomeStudents;
CREATE PROCEDURE findSomeStudents
@className INT AS
BEGIN
	SELECT * FROM Student WHERE StudentId = @className
END
EXECUTE findSomeStudents 2;

SELECT * FROM Student WHERE ClassId = 1;

DROP PROCEDURE sum2Numbers;
CREATE PROCEDURE sum2Numbers
@x Float,
@y Float AS
BEGIN
	SELECT @x + @y;
END

EXECUTE sum2Numbers 5,4;
--viet mot procedure co tham so dau vao/ra

DROP PROCEDURE findNumberOfStudents;
CREATE PROCEDURE findNumberOfStudents
@numberOfStudents INT OUTPUT,
@from INT,
@to INT AS
BEGIN
	SELECT @numberOfStudents = COUNT(*)
	FROM Student 
	WHERE StudentId BETWEEN @from AND @to;
	PRINT 'number of students = '+cast(@numberOfStudents AS VARCHAR);
END
EXECUTE findNumberOfStudents 0, 1,  3;

DROP PROCEDURE testDivideByZero;
CREATE PROCEDURE testDivideByZero 
@x FLOAT,
@y FLOAT AS
BEGIN
	BEGIN TRY
		PRINT 'mot';
		PRINT 'hai';
		PRINT 'ba';
		SELECT @x / @y
		PRINT 'bon';
		PRINT 'HEHE';
	END TRY 
	BEGIN CATCH
		SELECT ERROR_NUMBER() AS ErrorNumber;
		SELECT ERROR_SEVERITY() AS SeverityLevel;
	END CATCH
END
EXECUTE testDivideByZero 2, 0;	
--cau 7
DROP VIEW view_StudentSubjectMark;

CREATE VIEW view_StudentSubjectMark AS
SELECT 
	Student.StudentId AS StudentId, 
	Student.StudentName AS StudentName, 
	Subject.SubjectName AS SubjectName,
	Result.Mark AS Mark
FROM Student
INNER JOIN Result
	ON Result.StudentId = Result.StudentId
INNER JOIN Subject
	ON Result.SubjectId = Subject.SubjectId
SELECT * FROM view_StudentSubjectMark ORDER BY StudentId DESC;

DROP PROCEDURE up_IncreaseMark;
CREATE PROCEDURE up_IncreaseMark 
@SubjectId INT
AS
BEGIN 
	UPDATE Result 
	SET Result.Mark = Result.Mark + 1
	WHERE Result.SubjectId = @SubjectId;
END

EXECUTE up_IncreaseMark 2

SELECT * FROM Result WHERE SubjectId = 2;

SELECT * FROM Student;
SELECT * FROM Class;

DROP TRIGGER triggerAfterUpdateStudent;
CREATE TRIGGER triggerAfterUpdateStudent
ON Student 
AFTER UPDATE AS
DECLARE @studentName AS NVARCHAR(500);
BEGIN
	
	SET @studentName = (SELECT TOP 1 inserted.StudentName FROM inserted);
	PRINT @studentName + ' da bi update thong tin';
END

UPDATE Student SET ClassId = 3
WHERE StudentId = 4;

DROP TRIGGER TG_Result_Insert;
CREATE TRIGGER TG_Result_Insert
ON Result 
AFTER INSERT AS
DECLARE @Count AS INT
DECLARE @ErrorMessage AS NVARCHAR(300)
BEGIN
SET @Count = (SELECT COUNT(*) FROM inserted WHERE Mark < 0);
IF @Count > 0
BEGIN
	SET @ErrorMessage = 'Cannot insert Mark < 0, there are : ' + cast(@Count AS NVARCHAR) + ' invalid records';
	BEGIN RAISERROR(@ErrorMessage, 16, 2);
		ROLLBACK;
	END
END 
END

DELETE FROM Result WHERE StudentId = 5 AND SubjectId = 4;
SELECT * FROM Result;
INSERT INTO Result(StudentId, SubjectId, Mark) VALUES
(5, 4, -2),
(5, 5, -1);

DROP TRIGGER TG_Subject_Update;
CREATE TRIGGER TG_Subject_Update 
ON Subject AFTER UPDATE AS 
BEGIN
	IF UPDATE(SubjectName)
		BEGIN
			BEGIN RAISERROR('You don''t update this column', 16, 3);
				ROLLBACK;
			END
		END
END