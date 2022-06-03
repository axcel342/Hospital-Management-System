create database newhospital1
use newhospital1

use master

drop database newhospital1

create table Patient
(
  id int primary key, 
  name varchar(20) not null,
  cnic varchar(30) not null,
  phoneNumber varchar(15),
  age int not null,
  email varchar(30),
  admitted char not null check (admitted = 'T' OR admitted = 'F') default 'F',
  patientAddress nvarchar(50),
  appointmentNo int,
  Dues int default 0
)

alter table patient add password varchar(30) not null

alter table patient add gender char check (gender = 'F' or gender = 'M')

insert into patient values (1, 'ahmed', 3453267854392, 03008763421, 21, 'ahmed@gmail.com', 'T', 'Cantt', 1, 0, 'abcdefg', 'M')

select* from patient



create table Rooms
(
	roomID int primary key,
	patientID int foreign key references Patient(id) on delete cascade on update cascade,
	[status] varchar(10) check ([status] = 'Available' OR [status] = 'Not Available'),
)

create table RoomType
(
	typeid int primary key,
	typename varchar (15),
	price int
)

alter table Rooms add [typeid] int foreign key references RoomType(typeid)

insert into RoomType values (1,'VIP',6000)
insert into RoomType values (2,'Reg',2000)
insert into RoomType values (3,'OT',8000)

alter table Rooms alter column [status] varchar (15)
insert into Rooms values (6,1,'Not Available',1)

--insert into rooms values (1, 'single', 1, 'Available')

select* from rooms

create table Doctor
(
  id int primary key,
  name varchar(20) not null,
  cnic varchar(30) not null,
  phoneNumber varchar(15) not null,
  age int not null,
  timings nvarchar(30),
  email varchar(30), 
  departmentName varchar(20),
  gender char check (gender = 'M' or gender = 'F'),
  roomNo int foreign key references Rooms(RoomID),
  password nvarchar(30) not null
)

drop table doctor




create table [admin]
(
  id int primary key,
  name varchar(20) not null,
  cnic varchar(30),
  phoneNumber varchar(15),
  age int not null,
  email varchar(30) not null,
  password nvarchar not null
)

alter table [admin] drop column password
alter table [admin] add password nvarchar(30) 
create table laboratory
(
  testID int primary key,
  labNo int not null,
  testTime datetime,
  testDescription text,
  [status] varchar(10),
  amount float,
  patientID int foreign key references Patient(id) on delete cascade on update cascade
)

ALTER TABLE laboratory
ALTER COLUMN testTime nvarchar(30);
alter table laboratory drop column labNo
alter table laboratory drop column testDescription
alter table laboratory drop column amount



insert into laboratory values (1, 2, 1300, 'sugar test', 'Pending', 3300, 1)

create table viewlab
(
  testID int primary key,
  labNo int not null,
  testDescription nvarchar(30),
  amount float,
)

insert into viewlab values(1, 1, 'RBC', 500)
insert into viewlab values(2, 3, 'WBC', 1000)
insert into viewlab values(3, 2, 'kidney', 4000)
insert into viewlab values(4, 5, 'coroana', 5000)
insert into viewlab values(1, 1, 'RBC', 500)
insert into viewlab values(1, 1, 'RBC', 500)

select* from viewlab


create table pharmacy
(
  medicineNo int primary key,
  medicineName varchar(30) not null,
  expiry date not null,
  quantity int,
  price float
)

ALTER TABLE pharmacy
ALTER COLUMN expiry nvarchar(30);

insert into pharmacy values(1, 'acefyl', '2-2-2024', 30, 5500)
insert into pharmacy values(2, 'britanil', '24-1-2023', 10, 400)
insert into pharmacy values(3, 'acefyl', '26-6-2025', 50, 900)
insert into pharmacy values(4, 'acefyl', '20-8-2022', 15, 2500)

select* from pharmacy

create table Department
(
	id int primary key,
	departmentName varchar(30) not null,
	noOfDoctors int,
	roomID int foreign key references Rooms(roomID)
)

insert into Department values(1, 'rad', 2, 6) 

create table Catalogue
(
  treatmentsOffered varchar(30) not null,
  departmentID int foreign key references Department(id),
  doctorID int foreign key references Doctor(id) on delete cascade on update cascade
)

create table DoctorStats(

	 doctorID int foreign key references Doctor(id) on delete cascade on update cascade,
	 salary float, 
	 appointmentsLeft int,
	 appointmentsCleared int,
)



create table EHR
(
    patientID int foreign key references Patient(id) on delete cascade on update cascade,
	diagnosis text,
	testID int foreign key references Laboratory(TestID) default null
)

alter table EHR
add medicineNo int foreign key references Pharmacy(medicineNo)

drop table EHR

create table Appointments
(
	appointmentID int primary key,
	doctorID int foreign key references Doctor(id) on delete cascade on update cascade,
	patientID int foreign key references Patient(id) on delete cascade on update cascade,
	appointmentTime nvarchar(30),
	patientName nvarchar(30),
	patientPhone nvarchar(30),
	departmentid int,

	 unique(doctorID, appointmentTime)
)

drop table Appointments



insert into Appointments valueS(1, 1, 2, '1400', 'asad', '4324423434242', 1)

create table ratings
(
	docID int foreign key references Doctor(id) on delete cascade on update cascade,
	rating float check (rating >= 0 AND rating <=5)
)

insert into ratings values(1, 5.0)
insert into ratings values(2, 4.0)
insert into ratings values(3, 2.0)




select * from Patient 

--------------------------------------------------------------PROCEDURES--------------------------------------------------------------------------

--------------------------------------------signup and login --------------------------------------------------------------
create procedure SignupDoctor
@name varchar(30),
@cnic varchar(30),
@phno varchar(30),
@age int,
@email nvarchar(30),
@room int,
@dept nvarchar(30),
@time nvarchar(30),
@gender char,
@password nvarchar(30)
as begin
declare @id int
	select @id = max(id) + 1
	from Doctor d

	insert into Doctor values (@id,@name,@cnic,@phno,@age,@time,@email,@dept,@gender,@room,@password );
end

drop procedure SignupDoctor

select* from Doctor

insert into Doctor values(1, 'asad', 3520128232564, 03008457877, 35, '0800-1600', 'asad@gmail.com', 'radiology', 'M', 6, 'abcdefg');

create procedure LoginDoctor
@username int,
@password nvarchar(30),
@flag int output
as begin
declare @pass nvarchar(30)
set @flag = 0
select @pass = d.password
from doctor d
where d.id = @username

if(@pass = @password)
begin
set @flag = 1
end
if(@flag = 0)
begin
print 'invalid credentials'
end

end

declare @out int;
exec LoginDoctor
@username='1',
@password='abcdefg',
@flag = @out output
select @out as 'return_value'

select* from doctor




--2)
drop proc LoginPatient

create procedure LoginPatient
@id int,
@password varchar(15),
@flag int output
as begin
declare @pass nvarchar (15)
set @flag = 0
select @pass = p.password
from Patient p
where p.id = @id

if(@pass = @password)
begin
set @flag = 1
end
if(@flag = 0)
begin
print 'invalid credentials'
end

end

select* from patient

declare @out int
exec LoginPatient
@id=1,@password='abcdefg',@flag = @out output
select @out



create procedure SignupPatient
@name varchar(20),
@cnic nvarchar(30),
@phno nvarchar(30),
@age int,
@email nvarchar(30),
@add nvarchar(30),
@appno int,
@pass nvarchar(30),
@gender char
as begin
	declare @id int
	select @id = max(id) + 1
	from Patient p

	insert into Patient values (@id,@name,@cnic,@phno,@age,@email,'F',@add,@appno,0,@pass,@gender);

end

drop procedure SignupPatient

select* from patient


exec SignupPatient
@name = 'momin',
@cnic = '5476583754435543',
@phno = '134243243243',
@age = 12,
@email = 'momin@gmail.com',
@add = 'cantt',
@appno = 14,
@pass = 'abcdefg',
@gender = 'M'

select* from patient

--alter table patient add gender char check (gender = 'F' or gender = 'M')
--3)
drop procedure LoginAdmin

create procedure LoginAdmin
@username nvarchar(30),
@password nvarchar(30),
@flag int output
as begin
declare @pass nvarchar (15)
set @flag = 0		
		select @pass = a.password
		from [admin] a
		where a.id = @username

		if(@pass = @password)
		begin
		set @flag = 1
		end

		if (@flag = 0)
		begin
		print 'invalid credentials'
		end

end



declare @out int
exec LoginAdmin
@username=1,@password='123456',@flag = @out output
select @out as return_result

select* from [admin]


--6)

drop procedure SignupAdmin

insert into [admin] values (1, 'ahmed', '34657463584357', '74983274932', 30, 'ahmed@gmail.com', '123456')

create procedure SignupAdmin
@name nvarchar(30),
@cnic nvarchar(30),
@phno nvarchar(30),
@age int,
@email nvarchar(30),
@pass nvarchar(30)
as begin
	declare @id int
	select @id = max(id) + 1
	from [admin] a

	insert into [admin] values (@id,@name,@cnic,@phno,@age,@email,@pass);
end

exec SignupAdmin @name = 'momin', @cnic = '43746384376632', @phno = '054894400540', @age = 10, @email = 'momin@gmail.com', @pass = 'abcd123'

select* from [admin]


-------------------------EHR ------------------------------------------
-- 20)
	create procedure enterEHR
	@patid int,
	@diag text,
	@testid int = null,
	@medno int = null
	as begin
	insert into EHR values (@patid, @diag, @testid,@medno)

	end

	exec enterEHR @patid = 1, @diag = 'cough', @testid = 1, @medno = 1

	select * from EHR


--18)
create procedure patient_EHR
 @patient_id int
 as begin

 select patientID, diagnosis, testID, medicineNo
 from EHR
 where EHR.patientID = @patient_id

 end

 exec patient_EHR @patient_id = 1

 drop procedure patient_EHR

 select* from EHR

 ----------------------------------------Appointments----------------------------------------------------
--13)
create procedure searchAppointment
@patientID int

as begin
select appointmentID, a.patientName,d.name as 'DoctorName', d.departmentName as 'Department', a.appointmentTime   
from [Appointments] a inner join Doctor d on a.doctorID = d.id
where @patientID = a.patientID
end

drop procedure searchAppointment

exec searchAppointment @patientID = 2
-----------
--12)
create procedure makeAppointment
@patientID int,
@doctorID int,
@patientName nvarchar(30),
@phoneNo nvarchar(30),
@dept int,
@time nvarchar(30)

as begin
declare @appointmentID int

select @appointmentID = max(appointmentID) + 1
from [Appointments] app


insert into [Appointments] values (@appointmentID, @doctorID, @patientID, @time, @patientName, @phoneNo, @dept )

end

select* from Appointments
select* from Department

exec makeAppointment @patientID = 1, @doctorID = 1, @patientName = 'asad', @phoneNo = '03304256565', @dept = 1, @time = '1500'

drop procedure makeAppointment
--------------------
create procedure deleteAppointment
@id int
as begin

delete from Appointments 
where Appointments.appointmentID = @id

end

exec deleteAppointment @id = 3

----------------------
create procedure viewAppointments
as begin

select* from Appointments

end

exec viewAppointments

--------------------------laboratory procedures-----------------------------------------
select * from laboratory
--1)
create procedure labTest
@patientID int,
@testTime nvarchar(30)
as begin

declare @testID int
select @testID = max(testID) + 1
from [laboratory] lab

insert into [laboratory] values (@testID, @testTime, 'pending', @patientID)

end

exec labTest @patientID = 3, @testTime = '1500'

drop procedure labTest

select* from laboratory


--2)
create procedure viewtests
as begin

select* from viewlab 

end

exec viewtests


--3)
create procedure addtests
@labNo int,
@testDescription nvarchar(30),
@amount float
as begin

declare @testID int
select @testID = max(testID) + 1
from viewlab lab

insert into viewlab values(@testID, @labNo,@testDescription, @amount)


end

exec addtests @labNo = 4, @testDescription = 'LFT', @amount = 3000

drop procedure addtests

select* from viewlab

--4)
create procedure removetests
@testid int
as begin

delete from viewlab 
where viewlab.testid = @testid

end

exec removetests @testid = 5
---------------------------------------------Pharmacy procedures-----------------------------------------
create procedure viewpharmacy
as begin

select* from pharmacy
end

exec viewpharmacy

----------
--15) Add medicine
CREATE PROCEDURE Add_Medicine
@medicineNo integer,
@medicineName nvarchar(30),
@expiry nvarchar(30),
@quantity int,
@price float
AS
BEGIN


if(exists(select * from pharmacy
		where medicineNo=@medicineNo ))
	begin
			update pharmacy
			set quantity=@quantity+quantity
			where medicineNo=@medicineNo
		--increase quantity number
	end
	else
	begin
		
		select @medicineNo = max(medicineNo) + 1 
		from pharmacy

		INSERT INTO pharmacy
         VALUES(@medicineNo, @medicineName,@expiry,@quantity,@price)
	end
end

exec Add_Medicine @medicineNo = 0,@medicineName = 'glycerin', @expiry ='2-2-2024', @quantity = 20, @price = 600

select* from pharmacy

drop procedure Add_Medicine


--14)remove medicine
CREATE PROCEDURE Remove_Medicine
@medicineNo integer
AS
BEGIN
Delete from pharmacy where medicineNo=@medicineNo
END

exec Remove_Medicine @medicineNo = 5


------------------------------------Delete Admin/patient/Doctor-----------------------------------

create procedure ViewDoctor
as begin

	select* from doctor

end

exec ViewDoctor

--7)
create procedure DeleteDoctor
@id int
as begin

	delete from Doctor 
	where Doctor.id = @id

end

exec DeleteDoctor @id = 1

select * from doctor

create procedure viewpatient
as begin
select* from patient
end

exec viewpatient

 --8)
 create procedure DeletePatient
@id int
as begin

	delete from Patient  
	where Patient.id = @id

end

exec DeletePatient @id = 6

create procedure viewAdmin
as begin
select * from admin
end

exec viewAdmin

--9)
 create procedure DeleteAdmin
 @id int
as begin

	delete from [admin]
	where [admin].id = @id

end

exec DeleteAdmin @id = 4



-----------------------------------------------------------------procedures not connected---------------------------------------------------------------------------

--19)
 create procedure RatingDocs
as begin
	select avg(rating), d.name
	from ratings r
	join Doctor d
	on d.id = r.docID
	group by r.docID, d.name
end

exec RatingDocs 





--11)
create procedure PremiumDocs
as begin

	select docID,avg(rating)
	from ratings
	group by docID
	having avg(rating)=
	(
	select top 1 avg(rating)
	from ratings r
	group by r.docID
	order by avg(rating) desc
	)
end


--16)expired medicine nefiunerin 
CREATE PROCEDURE expired_Medicine
AS
BEGIN

      Delete from pharmacy  
	  where expiry < GETDATE()
END


--14) details of doctor by using doctor id 
CREATE PROCEDURE doctor_detail 
@id_of_doctor int
AS
BEGIN
select * from Doctor where id=@id_of_doctor
END





--17)
 create procedure available_rooms
 as begin

 select *
 from rooms
 where rooms.status = 'available'

 end

 exec available_rooms

 
 --18)
 

 --19)

 create procedure operation_room_availability
 @room_id int
 as begin

 select *
 from rooms
 where rooms.roomType = 'OP' AND rooms.roomID = @room_id

 end





 ---- TRIGGERS -----
 --1)
 create trigger NoDoc
 on Doctor
 Instead of update
 as begin
 print 'not allowed'
end

--2)
 create trigger NoPat
 on Patient
 Instead of update
 as begin
 print 'not allowed'
end
 
 --3)
  create trigger NoAdmin
 on [admin]
 Instead of update
 as begin
 print 'not allowed'
end



---- VIEWS ---
--1)
create view AdmPat
as
select *
from Patient p
where p.admitted = 'T'
go

--2)
create view App
as
select *
from Appointments app
where app.appointmentTime >'9:00'

--3)
create view expMed
as
select * 
from pharmacy ph
where ph.expiry < GETDATE()
