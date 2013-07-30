/* Name: Kyle So
   Student ID: A10233937 */
   
/* PART 1 */

create table fan (
	fanID int,
	fanName varchar(100),
	primary key (fanID)
);

create table band (
	bandID int,
	bandName varchar(100),
	genre varchar(100),
	year int,
	primary key (bandID)
);


create table likes (
	fanID int,
	bandID int,
	primary key (fanID, bandID),
	foreign key (fanID) references fan,
	foreign key (bandID) references band
);

create table bandMember (
	memID int,
	memName varchar(100),
	bandID int,
	nationality varchar(100),
	primary key (memID),
	foreign key (bandID) references band
);


/* END OF PART 1 */
