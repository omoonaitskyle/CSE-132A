/* Name: Kyle So
   Student ID: A10233937 */

/* PART 3 */

/* Change the nationality of all band members that have a 'british' 
   nationality to 'us' and the nationality of all band members that have 
   initially a 'us' nationality to 'british' */


update bandMember
set nationality = 'temp'
where nationality = 'british';

update bandMember
set nationality = 'british'
where nationality = 'us';

update bandMember
set nationality = 'us'
where nationality = 'temp';


/* Delete all 'rock' bands, as well as the fans that like them (this has 
   to be done carefully to avoid violation of the referential integrity 
   constraint from likes to band). */

/* Deletes tuples from likes where the bandID has genre = 'rock' */
delete from likes
where bandID in 
	(select bandID 
	 from band
	 where genre = 'rock');

/* Deletes tuples from bandMember where the bandID has genre = 'rock' */
delete from bandMember
where bandID in
	(select bandID
	 from band
	 where genre = 'rock');

/* Deletes tuples from band where genre = 'rock' */
delete from band
where genre = 'rock';


/* END OF PART 3 */