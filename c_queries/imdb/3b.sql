SELECT MIN("t9"."title") AS "movie_title"
FROM (SELECT "t4"."movie_id", "t5"."movie_id" AS "movie_id0"
FROM (SELECT "id"
FROM keyword
WHERE "keyword" LIKE '%sequel%') AS "t1"
CROSS JOIN 
(SELECT "movie_id"
FROM movie_info
WHERE "info" = 'Bulgaria') AS "t4"
INNER JOIN (SELECT "movie_id", "keyword_id"
FROM movie_keyword) AS "t5" ON "t4"."movie_id" = "t5"."movie_id" AND "t1"."id" = "t5"."keyword_id") AS "t6"
INNER JOIN (SELECT "id", "title"
FROM title
WHERE "production_year" > 2010) AS "t9" ON "t6"."movie_id" = "t9"."id" AND "t6"."movie_id0" = "t9"."id"
;
