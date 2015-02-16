select distinct year
from Movie, Rating
where Movie.mID = Rating.mID
and stars in (4,5)
order by year;


#Find the titles of all movies that have no ratings.

select title
from Movie left outer join Rating
on Movie.mID = Rating.mID
where Rating.mID is null;

#Some reviewers didn't provide a date with their rating. Find the names of all reviewers who have ratings with a NULL value for the date.

select Reviewer.name
from Reviewer, Rating
where Reviewer.rID = Rating.rID
and Rating.ratingDate is null;

#Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars.
#Movie ( mID, title, year, director )
#Reviewer ( rID, name )
#Rating ( rID, mID, stars, ratingDate )

select name, title, stars, ratingDate
from
Reviewer, Movie, Rating
where
Movie.mID = Rating.mID
and Reviewer.rID = Rating.rID
order by
name, title, stars;

#For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, return the reviewer's name and the title of the movie.
#Movie ( mID, title, year, director )
#Reviewer ( rID, name )
#Rating ( rID, mID, stars, ratingDate )

select Reviewer.name, Movie.title
from
Reviewer, Movie
where Reviewer.rID in (

select R1.rID from
Rating R1, Rating R2
where
R1.rID = R2.rID
and
R1.miD = R2.mID
and
R1.stars > R2.stars
and
R1.ratingDate > R2.ratingDate)

and Movie.mID in (

  select R1.mID from
  Rating R1, Rating R2
  where
  R1.rID = R2.rID
  and
  R1.miD = R2.mID
  and
  R1.stars > R2.stars
  and
  R1.ratingDate > R2.ratingDate

);

#For each movie that has at least one rating, find the highest number of stars that movie received. Return the movie title and number of stars. Sort by movie title.
#Movie ( mID, title, year, director )
#Reviewer ( rID, name )
#Rating ( rID, mID, stars, ratingDate )

select  Movie.title, max(stars)
from Rating, Movie
where Movie.mID = Rating.mID
group by Movie.title
having count(*) >=1
order by Movie.title;


#For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings given to that movie. Sort by rating spread from highest to lowest, then by movie title.
#Movie ( mID, title, year, director )
#Reviewer ( rID, name )
#Rating ( rID, mID, stars, ratingDate )

select Movie.title, max(stars) - min(stars) as spread
from Rating, Movie
where Rating.mID = Movie.mID
group by Rating.mID
order by spread desc, title;

#Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980. (Make sure to calculate the average rating for each movie, then the average of those averages for movies before 1980 and movies after. Don't just calculate the overall average rating before and after 1980.)
#Movie ( mID, title, year, director )
#Reviewer ( rID, name )
#Rating ( rID, mID, stars, ratingDate )

#########_________________________________________________

 WITH g AS
    ( SELECT mID, AVG(stars) AS average
      FROM Rating
      GROUP BY mID
    )
  , j AS
    ( SELECT mID, average, year
      FROM g NATURAL JOIN Movie
    )
  , t1 AS
    ( SELECT AVG(average) AS p1
      FROM j
      WHERE year >= 1980
    )
  , t2 AS
    ( SELECT AVG(average) AS p2
      FROM j
      WHERE year < 1980
    )
  SELECT t1.p1 - t2.p2 AS result
  FROM t1 CROSS JOIN t2
;

#_____________________________________________
# the "WITH" syntax is not supported by my version of SQLite
# but the above seems like a much more sensible way to do it


select max(a1)-min(a1) from
(select avg(av1) a1 from
(select avg(stars) av1 from rating r join movie m on r.mid=m.mid where m.year < 1980
group by r.mid)
union
select avg(av2) a1 from
(select avg(stars) av2 from rating r join movie m on r.mid=m.mid where m.year > 1980
group by r.mid))
