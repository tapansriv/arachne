SELECT MIN("t9"."title") AS "movie_title"
FROM (SELECT "t6"."movie_id", "t7"."movie_id" AS "movie_id0"
FROM (SELECT "t4"."id" AS "id0", "t5"."movie_id"
FROM (SELECT "id"
FROM company_name
WHERE "country_code" = '[us]') AS "t1"
CROSS JOIN 
(SELECT "id"
FROM keyword
WHERE "keyword" = 'character-name-in-title') AS "t4"
INNER JOIN (SELECT "movie_id", "company_id"
FROM movie_companies) AS "t5" ON "t1"."id" = "t5"."company_id") AS "t6"
INNER JOIN (SELECT "movie_id", "keyword_id"
FROM movie_keyword) AS "t7" ON "t6"."id0" = "t7"."keyword_id" AND "t6"."movie_id" = "t7"."movie_id") AS "t8"
INNER JOIN (SELECT "id", "title"
FROM title) AS "t9" ON "t8"."movie_id" = "t9"."id" AND "t8"."movie_id0" = "t9"."id"
;
