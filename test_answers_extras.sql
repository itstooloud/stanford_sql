#Find the names of all reviewers who rated Gone with the Wind.
#Movie ( mID, title, year, director )
#Reviewer ( rID, name )
#Rating ( rID, mID, stars, ratingDate )

select distinct Reviewer.name
from  Reviewer,
      Rating,
      Movie
where
      Reviewer.rID =
      Rating.rID
      and
      Movie.mID =
      Rating.mID
and
      Movie.title = "Gone with the Wind";


#For any rating where the reviewer is the same as the director of the movie, return the reviewer name, movie title, and number of stars.
#Movie ( mID, title, year, director )
#Reviewer ( rID, name )
#Rating ( rID, mID, stars, ratingDate )

select  Reviewer.name,
        Movie.title,
        Rating.stars
from
        Movie,
        Reviewer,
        Rating
where
        Reviewer.rID =
        Rating.rID
        and
        Movie.mID =
        Rating.mID
and
        Movie.director =
        Reviewer.name;


#Return all reviewer names and movie names together in a single list, alphabetized. (Sorting by the first name of the reviewer and first word in the title is fine; no need for special processing on last names or removing "The".)
#Movie ( mID, title, year, director )
#Reviewer ( rID, name )
#Rating ( rID, mID, stars, ratingDate )


select item from
(select Reviewer.name as item
from    Reviewer
union
select Movie.title
from Movie)
order by item;


#Find the titles of all movies not reviewed by Chris Jackson.
#Movie ( mID, title, year, director )
#Reviewer ( rID, name )
#Rating ( rID, mID, stars, ratingDate )

########################### this is not my work

select title
from Movie
where mID not in

    (select mID
    from Rating
    where rID in

          (select rID
          from Reviewer
          where name = "Chris Jackson")
      );

#For all pairs of reviewers such that both reviewers gave a rating to the same movie, return the names of both reviewers. Eliminate duplicates, don't pair reviewers with themselves, and include each pair only once. For each pair, return the names in the pair in alphabetical order.
#Movie ( mID, title, year, director )
#Reviewer ( rID, name )
#Rating ( rID, mID, stars, ratingDate )

############################# this is not my work

SELECT DISTINCT Re1.name, Re2.name
FROM Rating R1, Rating R2, Reviewer Re1, Reviewer Re2
WHERE R1.mID = R2.mID
AND R1.rID = Re1.rID
AND R2.rID = Re2.rID
AND Re1.name < Re2.name
ORDER BY Re1.name, Re2.name;


#Q6  (1 point possible)
#For each rating that is the lowest (fewest stars) currently in the database, return the reviewer name, movie title, and number of stars.
#Movie ( mID, title, year, director )
#Reviewer ( rID, name )
#Rating ( rID, mID, stars, ratingDate )

with j as (select mID, rID,  min(stars) as lowest
from Rating
group by mID)

select Reviewer.name, Movie.title,  lowest from
j, Movie, Reviewer
where
j.mID = Movie.mID
and
Reviewer.rID = j.rID;


#List movie titles and average ratings, from highest-rated to lowest-rated. If two or more movies have the same average rating, list them in alphabetical order.
#Movie ( mID, title, year, director )
#Reviewer ( rID, name )
#Rating ( rID, mID, stars, ratingDate )

select title, avg(stars) as avg_rating
from Movie, Rating
where Movie.mID = Rating.mID
group by title
order by avg(stars) desc, title;


#Find the names of all reviewers who have contributed three or more ratings. (As an extra challenge, try writing the query without HAVING or without COUNT.)
#Movie ( mID, title, year, director )
#Reviewer ( rID, name )
#Rating ( rID, mID, stars, ratingDate )

select Reviewer.name from
Rating, Reviewer
where
Rating.rID = Reviewer.rID
group by Reviewer.name
having count(*) >=3;

#Some directors directed more than one movie. For all such directors, return the titles of all movies directed by them, along with the director name. Sort by director name, then movie title. (As an extra challenge, try writing the query both with and without COUNT.)
#Movie ( mID, title, year, director )
#Reviewer ( rID, name )
#Rating ( rID, mID, stars, ratingDate )


select title, director from Movie where director in
(select director
from Movie
group by director
having count(*) > 1)
order by director, title;

#Find the movie(s) with the highest average rating. Return the movie title(s) and average rating. (Hint: This query is more difficult to write in SQLite than other systems; you might think of it as finding the highest average rating and then choosing the movie(s) with that average rating.)
#Movie ( mID, title, year, director )
#Reviewer ( rID, name )
#Rating ( rID, mID, stars, ratingDate )

select title, max(av) from (
select mID, avg(stars) as av
from Rating
group by mID) R1,
Movie
where R1.mID = Movie.MID;

#note: this query returns the correct result in SQLite3, both from the terminal window and from the
#GUI called SQLiteStudio. It returns the wrong result on stanford.edu.


#Find the movie(s) with the lowest average rating. Return the movie title(s) and average rating. (Hint: This query may be more difficult to write in SQLite than other systems; you might think of it as finding the lowest average rating and then choosing the movie(s) with that average rating.)

#Movie ( mID, title, year, director )
#Reviewer ( rID, name )
#Rating ( rID, mID, stars, ratingDate )


select Movie.title, avg(stars) as avs

from Movie,
    Rating
where
    Movie.mID = Rating.mID
group by Movie.mID
having
avs = (select min(stars) from (select avg(stars) as stars
from Rating
group by mID));
