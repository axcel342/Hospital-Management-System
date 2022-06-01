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

create table pharmacy
(
  medicineNo int primary key,
  medicineName varchar(30) not null,
  expiry date not null,
  quantity int,
  price float
)

create table Department
(
	id int primary key,
	departmentName varchar(30) not null,
	noOfDoctors int,
	roomID int foreign key references Rooms(roomID)
)

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
	testID int foreign key references Laboratory(TestID)
)

alter table EHR
add medicineNo int foreign key references Pharmacy(medicineNo)

create table Appointments
(
	appointmentID int primary key,
	doctorID int foreign key references Doctor(id) on delete cascade on update cascade,
	patientID int foreign key references Patient(id) on delete cascade on update cascade,
	appointmentTime datetime,
	doctorName nvarchar,
	patientName nvarchar,
	patientPhone nvarchar,
	department nvarchar,
	room nvarchar

	 unique(doctorID, appointmentTime)
)

create table ratings
(
	docID int foreign key references Doctor(id) on delete cascade on update cascade,
	rating float check (rating >= 0 AND rating <=5)
)

-------------insert statements-------------------

select * from Patient 




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
@phno int,
@age int,
@email nvarchar(30),
@add nvarchar(30),
@appno int,
@pass int,
@gender char
as begin
	declare @id int
	select @id = max(id) + 1
	from Patient p

	insert into Patient values (@id,@name,@cnic,@phno,@age,@email,'F',@add,@appno,0,@pass,@gender);

end

drop procedure SignupPatient

select* from patient

--alter table patient add gender char check (gender = 'F' or gender = 'M')
-----------------------------------------------------------------procedures not connected---------------------------------------------------------------------------
--3)
create procedure LoginAdmin
@username nvarchar,
@password nvarchar
as begin
declare @flag int
declare @pass nvarchar
		
		select @pass = a.password
		from admin a
		where a.name = @username

		if(@pass = @password)
		begin
		set @flag = 1
		end

		else
		begin
		print 'invalid credentials'
		end

end
exec LoginAdmin 'ndc','hbdcb'



--6)
create procedure SignupAdmin
@name nvarchar,
@cnic nvarchar,
@phno nvarchar,
@age int,
@email nvarchar,
@pass nvarchar
as begin
	declare @id int
	select @id = max(id) + 1
	from [admin] a

	insert into [admin] values (@id,@name,@cnic,@phno,@age,@email,@pass);
end


--7)
create procedure DeleteDoctor
@id int
as begin

	delete from Doctor 
	where Doctor.id = @id

end

 --8)
 create procedure DeletePatient
@id int
as begin

	delete from Patient  
	where Patient.id = @id

end

--9)
 create procedure DeleteAdmin
 @id int
as begin

	delete from [admin]
	where [admin].id = @id

end

--10)
create procedure RatingDocs
as begin
	select avg(rating), d.name
	from ratings r
	join Doctor d
	on d.id = r.docID
	group by r.docID, d.name
end

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

--12)
create procedure makeAppointment
@patientID int,
@doctorID int,
@doctorName nvarchar,
@patientName nvarchar,
@phoneNo nvarchar,
@dept nvarchar,
@room int,
@time time

as begin
declare @appointmentID int
select @appointmentID = max(@appointmentID) + 1
from [Appointments] app
insert into [Appointments] values (@appointmentID, @doctorID, @patientID, @time,  @doctorName, @patientName, @phoneNo, @dept, @room)

end

--13)
create procedure searchAppointment
@patientID int

as begin
select * from [Appointments] a
where @patientID = a.patientID
end

select * from laboratory
create procedure labTest
@patientID int,
@labno int,
@testTime time,
@testDescription nvarchar,
@status int,
@amount int
as begin

declare @testID int
select @testID = max(@testID) + 1
from [laboratory] lab

insert into [laboratory] values (@testID, @labno, @testTime, @testDescription, @status, @amount, @patientID)

end




--14) details of doctor by using doctor id 
CREATE PROCEDURE doctor_detail 
@id_of_doctor int
AS
BEGIN
select * from Doctor where id=@id_of_doctor
END


--15) Add medicine
CREATE PROCEDURE Add_Medicine
@medicineNo integer,
@expiry date,
@quantity int,
@price float
AS
BEGIN 
if(exists(select * from pharmacy
		where medicineNo=@medicineNo ))
	begin
			update pharmacy
			set @quantity=@quantity+1
			where quantity=@quantity
		--increase quantity number
	end
	else
	begin
		INSERT INTO pharmacy(medicineNo,expiry,quantity,price)
         VALUES(@medicineNo,@expiry,@quantity,@price)
	end
end
 
--14)remove medicine
CREATE PROCEDURE Remove_Medicine
@medicineNo integer
AS
BEGIN
Delete from pharmacy where medicineNo=@medicineNo
END


--16)expired medicine nefiunerin 
CREATE PROCEDURE expired_Medicine
AS
BEGIN

      Delete from pharmacy  
	  where expiry < GETDATE()
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
 create procedure patient_EHR
 @patient_id int
 as begin

 select*
 from EHR
 where EHR.patientID = @patient_id

 end

 --19)

 create procedure operation_room_availability
 @room_id int
 as begin

 select *
 from rooms
 where rooms.roomType = 'OP' AND rooms.roomID = @room_id

 end

-- 20)
	create procedure enterEHR
	@patid int,
	@diag text,
	@testid int,
	@medno int
	as begin
	insert into EHR values (@patid, @diag, @testid,@medno)

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