/* Name: Kyle So
   Student ID: A10233937 */

/* PART 2 */

/* View bandFans: List pairs of fans and bands they like.
   The output schema should be: (fanID, fanName, bandID, bandName). */
create view bandFans as
select b.fanID, a.fanName, b.bandID, c.bandName
from fan a, likes b, band c
where a.fanID = b.fanID AND b.bandID = c.bandID;

/* View fanLikeCount: List for each fan (identified by his ID 
   and name) the number of bands that he likes. If a fan does 
   not likes any band, this count should be zero. The output 
   schema should be (fanID, fanName, bandNum) */
create view fanLikeCount as
select a.fanID, a.fanName, count(b.fanID) as bandNum
from fan a NATURAL LEFT OUTER JOIN likes b
group by a.fanID
having count(*) >= 0; 

/* View hateRockBands: List the fans (identified by their ID 
   and name) that do not like any rock band. The output schema 
   should be (fanID, fanName). */
create view hateRockBands as
select distinct a.fanID, a.fanName
from (fan a NATURAL LEFT OUTER JOIN likes b), band c
where a.fanID not in 
	(select d.fanID
	from likes d, band e
	where d.bandID = e.bandID AND e.genre = 'rock');

/* List the genres for which we have the lowest number of bands. 
   The output schema should be (genre) and the output should not 
   contain duplicates. Provide two queries:
	1. View rareGenresWithMin: one using the MIN aggregate function
	2. View rareGenresWithoutMin: another without using MIN
*/
create view rareGenresWithMin as
select distinct a.genre
from band a
where
	(select count(*)
	 from band 
	 where genre = a.genre) = 
	(select min(x.total)
	 from 
		(select count(*) as total
		 from band
		 group by genre) as x);

create view rareGenresWithoutMin as
select a.genre
from band a
group by a.genre
having count(genre) <= ALL
	(select count(genre) as total
	from band
	group by genre);

/* List the fans (identified by their ID and name) that like every 
   rock band. The output schema should be (fanID, fanName). Provide 
   three SQL queries, using nested sub-queries in different ways:
	1. View fansAllRockWithNotIn: with NOT IN tests
	2. View fansAllRockWithNotExists: with NOT EXISTS tests
	3. View fansAllRockWithCount: with COUNT aggregate functions
*/
/* Computes IDs of bands that have genre "Rock" */
create view rockBandsOnly as
select a.bandID
from band a
where a.bandID not in
	(select b.bandID
	 from band b
	 where b.genre <> 'rock');

create view fansAllRockWithNotIn as
select distinct a.fanID, z.fanName
from likes a, fan z
where a.fanID = z.fanID AND a.fanID not in
	(select b.fanID
	 from likes b, rockBandsOnly c
	 where b.fanID not in
		(select fanID
		 from likes
		 where bandID = c.bandID));

create view fansAllRockWithNotExists as
select fanID, fanName
from fan a
where not exists
	(select b.bandID
	 from rockBandsOnly b
	 where not exists
		(select c.bandID
		 from likes c
		 where c.fanID = a.fanID AND c.bandID = b.bandID));

		

create view fansAllRockWithCount as
select a.fanID, z.fanName
from likes a, fan z, band b
where a.fanID = z.fanID AND b.bandID = a.bandID
group by a.fanID, z.fanName
having sum(case when b.genre='rock' then 1 else 0 end) =
	(select count(bandID)
	 from rockBandsOnly y);
	 

/* View bandLowerThanAvgFans: List the bands(identified by their ID and 
   name) that have a strictly lower number of fans than the average number
   of fans for all bands of the same genre. The output schema should be
   (bandID, bandName).
*/

/* Number of fans that like a specific genre */
create view numberOfFans as
select count(bandID) as numOfFans, genre
from likes natural left outer join band
group by genre;

/* Number of bands for a specific genre */
create view numberOfBands as
select count(bandID) as numOfBands, genre
from band
group by genre;

create view bandLowerThanAvgFans as
select distinct b.bandID, a.bandName
from band a, likes b, numberOfFans c, numberOfBands d
where b.bandID = a.bandID AND c.genre = a.genre AND d.genre = a.genre
group by b.bandID, a.bandName, c.numOfFans, d.numOfBands
having count(b.bandID) < ((c.numOfFans * 1.0) / (d.numOfBands * 1.0));


/* View sameBands: List pairs of fans(identified by their ID and name) who
   like the exact same bands(i.e. all bands liked by one are also liked 
   by the other and vice versa). Two fans that do not like any band count
   as liking the exact same bands and therefore should be included in the 
   query answer. The output schema should be (fanID1, fanName1, fanID2, 
   fanName2). The answer should contain only one tuple for each pair of 
   fans that like the exact same bands. For instance, if fans (f1, fN1) 
   and (f2, fN2) like the exact same bands, the answer should include 
   only one of the tuples (f1, fN1, f2, fN2) or (f2, fN2, f1, fN1), not
   both */
   
/* Number of likes for each fan */
create view countOfLikes as
select fanID, count(bandID) as numOfLikes
from likes
group by fanID;

create view sameBands as
select a.fanID as fanID1, b.fanName as fanName1, c.fanID as fanID2, d.fanName as fanName2
from likes a, fan b, likes c, fan d, countOfLikes e, countOfLikes f
where c.fanID > a.fanID AND c.bandID = a.bandID and c.fanID <> a.fanID AND 
      b.fanID = a.fanID AND d.fanID = c.fanID AND e.fanID = b.fanID AND 
      f.fanID = d.fanID AND e.numOfLikes = f.numOfLikes
group by a.fanID, b.fanName, c.fanID, d.fanName
having count(*) = max(e.numOfLikes);

/* END OF PART 2 */