
							----------NAME:MOHAMMAD JASHIM UDDIN-----
							----------SQL Project---------------------
							----------Project Name:Payroll Management
							----------Trainee ID:1246758--------------
							----------TSP:NVIT------------------------
							----------Supervised By:FAISAL WAHID------

use master
Create database Payroll
Go

--use master
--Drop database Payroll
--Go

--use master
--DROP database Payroll
--Go
--ON Primary(Name=N'Payroll_Data',Filename=N'D:\1246758_PAYROLL\D:\SQL SERVER2017\Payroll_Data.mdf',Size=10MB,Maxsize=Unlimited,FileGrowth=1024KB)
--Log ON(Name=N'Payroll_log',Filename=N'D:\1246758_PAYROLL\D:\SQL SERVER2017\Payroll_log.ldf',Size=8MB,Maxsize=10MB,FileGrowth=10%)
--Go

Alter Database Payroll Modify  File(Name=N'Payroll',Size=25Mb,Maxsize=unlimited,FileGrowth=1024KB)
Go
Alter Database Payroll Modify  File(Name=N'Payroll_log',Size=25Mb,Maxsize=unlimited,FileGrowth=10%)
Go

Use  Payroll
Create table Department
(
DeptID int primary key identity,
DeptName Varchar(50) not null
)
Go
Insert Into Department (DeptName)
						Values ('Purchase department'),
						('Sales department'),
						('HR department'),
						('Training department'),
						('Finance department'),
						('Facilities department'),
						('Engineering department'),
						('R&D department')
Go


Use  Payroll
Create table Designation
(
DesignationID int primary key identity,
Title Varchar (20) not null,
DeptID int FOREIGN KEY REFERENCES Designation(DesignationID) not null

)
Go

Insert into Designation(Title,DeptID) 
				values  ('Manager',1),
						('Manager',2),
						('Manager',3),
						('Manager',4),
						('Manager',5),
						('Manager',6),
						('Manager',7),
						('Manager',8)
Go

Use  Payroll
CREATE TABLE Employees 
( 
 EmployeeID int IDENTITY PRIMARY KEY NOT NULL, 
 --Image VarBinary(Max) null,
 EmployeeName varchar(25) NOT NULL, 
 FathersName varchar(25) NOT NULL,
 MothersName varchar(25) NOT NULL,
 DateofBirth Nvarchar(20) NOT NULL,
 CellPhone  Nvarchar(20) NOT NULL Check ((CellPhone Like '[0][1][0-9][0-9][0-9] [0-9][0-9][0-9] [0-9][0-9][0-9]')),
 Address  Nvarchar(60) NOT NULL Constraint CN_CustomerAddress Default ('Unknown'),
 BasicSalary money NOT NULL, 
 PriorSalary money NOT NULL, 
 LastRaise  AS (BasicSalary-PriorSalary), 
 HireDate Datetime not null Constraint CN_CustomerDefaultHireDate Default (getdate()) check ((HireDate<=getdate())), 
 TerminationDate date NULL, 
 DesignationID int NOT NULL FOREIGN KEY REFERENCES Employees (EmployeeID), 
) 
GO 

--Create Nonclustered Index MyNonclustered ON Employees(EmployeeName)
--Go

--Drop Index MyNonclustered  On Employee
--Go

-----========Sequence==========
Use Payroll
Create  sequence Sq_Employee
AS Bigint
Start with 1
Increment by 1
MinValue 1
Maxvalue 100
no cycle 
cache 10
Go
--=============================

INSERT INTO Employees (EmployeeName,FathersName,MothersName,DateofBirth,CellPhone,Address, BasicSalary,PriorSalary,HireDate,TerminationDate,DesignationID)
				VALUES('Foysal','Abdul Ahad','Nishat Faria','1985-01-01','01725 467 987','Chittagong',50000,45500,'2005-12-05',NULL,1)
GO

--Select * from Employees
--Go
 --===============================================================
Use  Payroll
CREATE TABLE Payroll
(
PayrollID Int IDENTITY PRIMARY KEY NOT NULL, 
EmployeeID int NOT NULL FOREIGN KEY REFERENCES Payroll (PayrollID),
BasicSalary money NOT NULL,
OverTime Money,
HouseRentAllowance Money,
TransportAllowance Money,
DarenessAllowance Money,
MedicalAllowance money,
GrossSalary money,
ProvidentFund Money,
CashAdvanced Money,
TotalDeduction Money,
NetSalary as (GrossSalary-TotalDeduction)
)
Go

--Truncate table payroll
--Go

--Drop table Payroll
--Go

--=====================================================================
--select * from Department
--Go
--select * from Designation
--Go
--select * from Employees
--Go
--select * from Payroll
--Go



---==Function==---
CREATE FUNCTION fn_GrossSalary
(
@payrollid int
)
Returns money
As
Begin
Declare
@basicSalary money,
@overtime money,
@houserentallowance money,
@transportallowance money,
@darenessallowance money,
@medicalallowance money,
@grosssalary money
Select @basicSalary=BasicSalary from Payroll_01 where PayrollID=@payrollid
Set @houserentallowance=@basicSalary*.40 
set @transportallowance=@basicSalary*.15
set @darenessallowance=@basicSalary*.10
set @medicalallowance=@basicSalary*.07
set @grosssalary=@basicSalary+@overtime+@houserentallowance+@transportallowance+@darenessallowance+@medicalallowance
return @grosssalary
End
--======================================================================================================

--Use Function---
--Declare @priorsalary Money
--Declare @overtime Money
--Declare @houserentallowance Money
--Declare @transportallowance Money
--Declare @darenessallowance Money
--set @priorsalary=25000
--set @overtime=1000
--set @houserentallowance=12000
--set @transportallowance =1200
--set @darenessallowance=500
--declare @grosssalary Money=dbo.fn_GrossSalary(@priorsalary,@overtime,@houserentallowance,@transportallowance,@darenessallowance) 
--Select @grosssalary As [Gross Salary]
--GO 

--=================================================================================================
Create function fn_TotalDeduction
(
@basicsalary money,
@providentfund Money,
@cashadvanced Money
)
returns Money
as
begin
	declare @totaldeduction Money
	set @providentfund=@basicsalary*.1
	Set @totaldeduction=@providentfund+@cashadvanced
	Return @totaldeduction 
end
go
---=================================================================================

----=====Use function=======
--Declare @providentfund Money
--Declare @cashadvanced Money
--set @providentfund=200
--set @cashadvanced=5000
--declare @totaldeduction Money=dbo.fn_TotalDeduction(@providentfund,@cashadvanced)
--Select @totaldeduction As [Total Deduction]
--GO 
--==================================================================================

----=======Function======-----
--Create function fn_NetSalary
--(
--@grosssalary Money,
--@totaldeduction Money
--)
--returns Money
--as
--begin
--	declare @netsalary Money
--	Set @netsalary=@grosssalary-@totaldeduction
--	Return @totaldeduction 
--end
--go
--=================================================

--===========use function----------
--Declare @grosssalary Money
--Declare @totaldeduction Money
--set @grosssalary =Null
--set @totaldeduction =Null
--declare @netsalary Money=dbo.fn_TotalDeduction(@grosssalary,@totaldeduction)
--Select @netsalary As [Net Salary]
--GO

--===========================================================================

------Store Procedure-------
Create Proc sp_Payroll
(
 @employeeid int, 
 @employeename varchar(25), 
 @fathersname varchar(25),
 @mothersname varchar(25),
 @cellphone  Nvarchar(20),
 @dateofbirth Nvarchar(20),
 @address  Nvarchar(60),
 @basicsalary money, 
 @priorSalary money, 
 @hiredate date, 
 @terminationdate date, 
 @designationid int, 

@payrollid Int,
@overtime Money,
@houserentallowance Money,
@transportallowance Money,
@darenessallowance Money,
@medicalallowance money,
@providentfund Money,
@cashadvanced Money,
@netsalary Money,

@operation varchar(25),
@tablename varchar(25)
)
AS
BEGIN
	if(@tablename='Employees')
	BEGIN
		if(@operation='Select')
		BEGIN
			SELECT * FROM Employees WHERE EmployeeID=@employeeid
		END
		else if(@operation='Insert')
		BEGIN
			Insert into Employees values(@employeename,@fathersname,@mothersname,@cellphone,@dateofbirth,@address,@basicsalary,@priorSalary,@hiredate,@terminationdate,@designationid)
		END
		else if (@operation='Update')
		BEGIN
			Update Employees
			Set EmployeeName=@employeename,FathersName=@fathersname,MothersName=@mothersname,CellPhone=@cellphone,DateofBirth=@dateofbirth,Address=@address,BasicSalary=@basicsalary,PriorSalary=@priorSalary,HireDate=@hiredate,TerminationDate=@terminationdate
			Where EmployeeID=@employeeid
			END
			else if(@operation = 'DELETE')
		BEGIN
			DELETE FROM Employees WHERE EmployeeID = @employeeid		
		END
	END

	else if(@tablename='Payroll')
	BEGIN
	declare @grossSalary money
	declare @totaldeduction money
	Set @GrossSalary =dbo.fn_GrossSalary(@basicsalary,@overtime,@houserentallowance,@transportallowance,@darenessallowance,@medicalallowance)
	Set @totaldeduction =dbo.fn_TotalDeduction(@providentfund,@cashadvance)
		if(@operation='Select')
		BEGIN
			SELECT * FROM Payroll_01 WHERE PayrollID=@payrollid
		END
		else if(@operation='Insert')
		BEGIN
		Insert into Payroll_01(BasicSalary,OverTime,HouseRentAllowance,TransportAllowance,DarenessAllowance,MedicalAllowance,GrossSalary,ProvidentFund,CashAdvanced,TotalDeduction)
		values (@basicSalary,@overtime,@houserentallowance,@transportallowance,@darenessallowance,@medicalallowance,@grossSalary,@providentfund,@cashadvance,@totaldeduction)
		END
		else if (@operation='Update')
		BEGIN
			Update Payroll
			Set EmployeeID=@employeeid,BasicSalary=@basicsalary,OverTime=@overtime,HouseRentAllowance=@houserentallowance,TransportAllowance=@transportallowance,DarenessAllowance=@darenessallowance,GrossSalary=@grosssalary,ProvidentFund=@providentfund,CashAdvanced=@cashadvanced,TotalDeduction=@totaldeduction,NetSalary=@netsalary
			Where PayrollID=@payrollid
		END
			else if(@operation = 'DELETE')
		BEGIN
			DELETE FROM Payroll WHERE PayrollID=@payrollid		
		END
	END
END
GO
Exec dbo.sp_Payroll 1,40000,5000,11000,1500,6000,500,25000,'Insert','Payroll'
go

select * from Payroll
Go
----=============================================================================================

--Create View--
create view vw_EmplpoyeePayroll
With Encryption
--With Schemabinding
As
Select e.EmployeeID,p.PayrollID,Sum(NetSalary) As [Net salary]
From Employees e
Join Payroll p
ON e.EmployeeID=P.EmployeeID
where NetSalary>12000
Group By e.EmployeeID,P.PayrollID
Having P.PayrollID In (select PayrollID From Payroll)
Go

Select * from vw_EmplpoyeePayroll
Go
-----=================================================================================================

--Trigger--
Create Trigger tr_InsteadofTrigger On Payroll
INSTEAD OF INSERT,update,delete
As
Begin
	Begin
	Declare @rowcount int
	Set @rowcount=@@ROWCOUNT
	IF(@rowcount>3)
		BEGIN
			RAISERROR('You can not insert more than 3 items at a time',16,1)
		END
		else
			print 'Insert is Successfull'
	End
End
GO
--=====================================================================================================

--Insert into Payroll values (1,5000,2000,300,500,600,400,600,800,40,117000),
--							(1,5000,2000,300,500,600,400,600,800,40,117000),
--							(1,5000,2000,300,500,600,400,600,800,40,117000),
--							(1,5000,2000,300,500,600,400,600,800,40,117000)

--Go

--======================================================================================================

--Select * From payroll
--Go


--============================ Local Temporary Table =======================
Use  Payroll
Create Table #Payroll
(
PayrollID Int,
EmployeeID int,
BasicSalary money NOT NULL,
OverTime Money,
Total as (BasicSalary+OverTime)
)
Go

Insert into #Payroll Values (1,1,5000,2000)
Go

select * from #Payroll
Go

--=========================================================================

--========================== Global Temporary Table =======================
Use  Payroll
Create Table ##Payroll
(
PayrollID Int,
EmployeeID int,
BasicSalary money NOT NULL,
OverTime Money,
Total as(BasicSalary+OverTime)
)
Go

Insert into ##Payroll Values (1,1,15000,3500)
Go

select * from ##Payroll
Go
--=======================================================================
---INNER JOIN
SELECT e.EmployeeID,e.EmployeeName,e.BasicSalary,p.PayrollID,p.OverTime
FROM Employees e
join Payroll p
on e.EmployeeID=p.EmployeeID
where e.HireDate>'1996-09-19'
go

--Left Join
SELECT e.EmployeeID,e.EmployeeName,e.BasicSalary,p.PayrollID,p.OverTime
FROM Employees e
Left join Payroll p
on e.EmployeeID=p.EmployeeID
where e.HireDate>'1996-09-19'
go

--Right Join
SELECT e.EmployeeID,e.EmployeeName,e.BasicSalary,p.PayrollID,p.OverTime
FROM Employees e
join Payroll p
on e.EmployeeID=p.EmployeeID
where e.HireDate>'1996-09-19'
go
------====================================================================================
--With RollUp
Select PayrollID, SUM(NetSalary) as 'Net Salary' 
from Payroll_01
Group by PayrollID
with Rollup
Go
--Only RollUp
Select PayrollID, SUM(NetSalary) as 'Net Salary' 
from Payroll_01
Group by
Rollup(PayrollID)
Go
-----=====================================================================


----==================UNIQUE====================
Use Payroll
CREATE TABLE EmployeeUnique (
    EmployeeID int,
    EmployeeName varchar(255) NOT NULL,
    UserID varchar(255),
    Age int,
	Constraint PK_Persons Primary Key(EmployeeID,UserID) 
);
Go
INSERT INTO EmployeeUnique (EmployeeID,EmployeeName,UserID,Age) VALUES(1,'Asif',101,21) -- OK
INSERT INTO EmployeeUnique (EmployeeID,EmployeeName,UserID,Age) VALUES(2,'Nazrul',101,25) -- OK
INSERT INTO EmployeeUnique (EmployeeID,EmployeeName,UserID,Age) VALUES(2,'Asif',101,21) -- Problem
INSERT INTO EmployeeUnique (EmployeeID,EmployeeName,UserID,Age) VALUES(2,'Nazrul',102,25) -- OK
INSERT INTO EmployeeUnique (EmployeeID,EmployeeName,UserID,Age) VALUES(2,'Nazrul',103,25) -- OK

Select * from EmployeeUnique
Go

Use Payroll
Create TABLE Employee
(
EmployeeID int Primary key identity,
EmployeeName varchar(255) NOT NULL,
CellPhone varchar(255) UNIQUE,
);
GO

INSERT INTO Employee VALUES('Asif','123')
INSERT INTO Employee VALUES('Sumon','123')
Go
select * from Employee
Go
------====================================================


----=========Declare Variable=========================
Declare @i int=0;
While @i<10
	Begin
		Print 'i= '+Cast( @i As varchar)
		Set @i=@i+1;
	End
Go
----=====================================================

----=========Declare Variable Remainder===================
Declare @i int=0;
While @i<10
	Begin
		If @i%2!=0
		begin 
				Print @i
				End
		Set @i=@i+1;
	End
Go
----=======================================================