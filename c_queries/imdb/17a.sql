SELECT MIN("t12"."name0") AS "member_in_charnamed_american_movie", MIN("t12"."name0") AS "a1"
FROM (SELECT "t9"."movie_id", "t9"."movie_id0", "t9"."movie_id1", "t11"."name" AS "name0"
FROM (SELECT "t7"."person_id", "t7"."movie_id", "t7"."movie_id0", "t8"."movie_id" AS "movie_id1"
FROM (SELECT "t"."person_id", "t"."movie_id", "t5"."id" AS "id1", "t6"."movie_id" AS "movie_id0"
FROM (SELECT "person_id", "movie_id"
FROM cast_info) AS "t"
CROSS JOIN 
(SELECT "id"
FROM company_name
WHERE "country_code" = '[us]') AS "t2"
CROSS JOIN 
(SELECT "id"
FROM keyword
WHERE "keyword" = 'character-name-in-title') AS "t5"
INNER JOIN (SELECT "movie_id", "company_id"
FROM movie_companies) AS "t6" ON "t2"."id" = "t6"."company_id" AND "t"."movie_id" = "t6"."movie_id") AS "t7"
INNER JOIN (SELECT "movie_id", "keyword_id"
FROM movie_keyword) AS "t8" ON "t7"."id1" = "t8"."keyword_id" AND "t7"."movie_id" = "t8"."movie_id" AND "t7"."movie_id0" = "t8"."movie_id") AS "t9"
INNER JOIN (SELECT "id", "name"
FROM name
WHERE "name" LIKE 'B%') AS "t11" ON "t9"."person_id" = "t11"."id") AS "t12"
INNER JOIN (SELECT "id"
FROM title) AS "t13" ON "t12"."movie_id" = "t13"."id" AND "t12"."movie_id1" = "t13"."id" AND "t12"."movie_id0" = "t13"."id"
;
