
CREATE TABLE project1_harika_db.PERSON
(
SSN numeric(10),
NAME varchar(50) NOT NULL,
ADDRESS varchar(50),
CITY varchar(50),
STATE varchar(50),
TELEPHONE numeric(10) UNIQUE,
PERSONTYPE CHAR(10),
ZIP numeric(38),
CONSTRAINT PKSSN PRIMARY KEY (SSN)
);

CREATE TABLE project1_harika_db.EMPLOYEE
(
EID numeric(10),
SSN numeric(10),
DATEHIRED DATE,
CONSTRAINT PKEID PRIMARY KEY (EID),
CONSTRAINT FKSSN FOREIGN KEY (SSN) REFERENCES PERSON(SSN)
);

CREATE TABLE project1_harika_db.VOLUNTEER
(
VID numeric(10),
SSN numeric(10),
SKILL varchar(50),
CONSTRAINT PKVID PRIMARY KEY (VID),
CONSTRAINT FKSSNV FOREIGN KEY (SSN) REFERENCES PERSON(SSN)
);
CREATE TABLE project1_harika_db.ITEM
(
ITEMID numeric(8),
ITEMDESC varchar(20),
CONSTRAINT PKID PRIMARY KEY (ITEMID)
);
CREATE TABLE project1_harika_db.DONOR
(
DID numeric(10),
SSN numeric(10),
ITEMID numeric(8),
CONSTRAINT PKDID PRIMARY KEY (DID),
CONSTRAINT FKSSND FOREIGN KEY (SSN) REFERENCES PERSON(SSN),
CONSTRAINT FKIDD FOREIGN KEY (ITEMID) REFERENCES ITEM(ITEMID)
);

SELECT COUNT(*) as totalrows from project1_harika_db.PERSON;
DELETE FROM project1_harika_db.person;
DELETE FROM project1_harika_db.donor;
DELETE FROM project1_harika_db.employee;
DELETE FROM project1_harika_db.item;
DELETE FROM project1_harika_db.volunteer;

select vid,ssn,skill,state from 
(select p.ssn,v.vid,v.skill,p.state from
 project1_harika_db.person p, project1_harika_db.volunteer v where v.ssn = p.ssn) 
 as P1 where skill = 'SKILL 14' and state = 'GA' group by skill,state,vid,ssn;

select p.ssn,p.name,e.eid,e.datehired,p.state from project1_harika_db.person p, project1_harika_db.employee e where e.ssn = p.ssn and 
datehired >= '2022-02-02' ;

create table project1_harika_db.denormperson as select p.ssn,v.vid,v.skill,p.state from project1_harika_db.person p, project1_harika_db .volunteer v where v.ssn = p.ssn;
create index inx_denorm on project1_harika_db.denormperson (SSN,VID,SKILL,STATE);
select skill,count(*) from project1_harika_db.denormperson where skill = 'SKILL 14' and state = 'AL' group by skill;


select  d.itemid,i.itemdesc from(select itemid, noofitems from (select itemid, it.noofitems As noofitems, Row_Number() Over (Order By noofitems desc) As RowNum from
 (select itemid,count(*) as noofitems from project1_harika_db.donor group by itemid 
order by noofitems desc) as it) as it2 where RowNum<=1) as d inner join 
project1_harika_db.item i on d.itemid = i.itemid;

select * from project1_harika_db.person where ssn in (select ssn from project1_harika_db.donor where itemid in
(select itemid from (select itemid, Row_Number() Over (Order By itemid desc)
As RowNum from (select itemid,count(*) from project1_harika_db.donor group by itemid order by count(*) desc) 
as t1 ) as t2 where RowNum<=1)  );

select * from project1_harika_db.person where ssn in (select ssn from project1_harika_db.volunteer where ssn in (select ssn from project1_harika_db.donor where itemid in
(select itemid from (select itemid, Row_Number() Over (Order By itemid desc)
 As RowNum from (select itemid,count(*) from project1_harika_db.donor group by itemid order by count(*) desc) 
 as t1 ) as t2 where RowNum<=1)  ));

SELECT * FROM project1_harika_db.employee;
