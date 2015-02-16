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
