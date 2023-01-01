SELECT MIN("t6"."keyword") AS "movie_keyword", MIN("t6"."name") AS "actor_name", MIN("t9"."title") AS "marvel_movie"
FROM (SELECT "t3"."movie_id", "t3"."keyword", "t3"."movie_id0", "t5"."name"
FROM (SELECT "t"."person_id", "t"."movie_id", "t1"."keyword", "t2"."movie_id" AS "movie_id0"
FROM (SELECT "person_id", "movie_id"
FROM cast_info) AS "t"
CROSS JOIN 
(SELECT "id", "keyword"
FROM keyword
WHERE "keyword" = 'marvel-cinematic-universe') AS "t1"
INNER JOIN (SELECT "movie_id", "keyword_id"
FROM movie_keyword) AS "t2" ON "t1"."id" = "t2"."keyword_id" AND "t"."movie_id" = "t2"."movie_id") AS "t3"
INNER JOIN (SELECT "id", "name"
FROM name
WHERE "name" LIKE '%Downey%Robert%') AS "t5" ON "t3"."person_id" = "t5"."id") AS "t6"
INNER JOIN (SELECT "id", "title"
FROM title
WHERE "production_year" > 2010) AS "t9" ON "t6"."movie_id0" = "t9"."id" AND "t6"."movie_id" = "t9"."id"
;
