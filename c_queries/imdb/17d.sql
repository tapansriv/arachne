SELECT MIN("t10"."name0") AS "member_in_charnamed_movie"
FROM (SELECT "t7"."movie_id", "t7"."movie_id0", "t7"."movie_id1", "t9"."name" AS "name0"
FROM (SELECT "t5"."person_id", "t5"."movie_id", "t5"."movie_id0", "t6"."movie_id" AS "movie_id1"
FROM (SELECT "t"."person_id", "t"."movie_id", "t3"."id" AS "id1", "t4"."movie_id" AS "movie_id0"
FROM (SELECT "person_id", "movie_id"
FROM cast_info) AS "t"
CROSS JOIN 
(SELECT "id"
FROM company_name) AS "t0"
CROSS JOIN 
(SELECT "id"
FROM keyword
WHERE "keyword" = 'character-name-in-title') AS "t3"
INNER JOIN (SELECT "movie_id", "company_id"
FROM movie_companies) AS "t4" ON "t0"."id" = "t4"."company_id" AND "t"."movie_id" = "t4"."movie_id") AS "t5"
INNER JOIN (SELECT "movie_id", "keyword_id"
FROM movie_keyword) AS "t6" ON "t5"."id1" = "t6"."keyword_id" AND "t5"."movie_id" = "t6"."movie_id" AND "t5"."movie_id0" = "t6"."movie_id") AS "t7"
INNER JOIN (SELECT "id", "name"
FROM name
WHERE "name" LIKE '%Bert%') AS "t9" ON "t7"."person_id" = "t9"."id") AS "t10"
INNER JOIN (SELECT "id"
FROM title) AS "t11" ON "t10"."movie_id" = "t11"."id" AND "t10"."movie_id1" = "t11"."id" AND "t10"."movie_id0" = "t11"."id"
;
