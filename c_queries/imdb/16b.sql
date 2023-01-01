SELECT MIN("t12"."name") AS "cool_actor_pseudonym", MIN("t13"."title") AS "series_named_after_char"
FROM (SELECT "t10"."name", "t10"."movie_id", "t10"."movie_id0", "t10"."movie_id1"
FROM (SELECT "t8"."person_id", "t8"."name", "t8"."person_id0", "t8"."movie_id", "t8"."movie_id0", "t9"."movie_id" AS "movie_id1"
FROM (SELECT "t"."person_id", "t"."name", "t0"."person_id" AS "person_id0", "t0"."movie_id", "t6"."id" AS "id2", "t7"."movie_id" AS "movie_id0"
FROM (SELECT "person_id", "name"
FROM aka_name) AS "t"
INNER JOIN (SELECT "person_id", "movie_id"
FROM cast_info) AS "t0" ON "t"."person_id" = "t0"."person_id"
CROSS JOIN 
(SELECT "id"
FROM company_name
WHERE "country_code" = '[us]') AS "t3"
CROSS JOIN 
(SELECT "id"
FROM keyword
WHERE "keyword" = 'character-name-in-title') AS "t6"
INNER JOIN (SELECT "movie_id", "company_id"
FROM movie_companies) AS "t7" ON "t3"."id" = "t7"."company_id" AND "t0"."movie_id" = "t7"."movie_id") AS "t8"
INNER JOIN (SELECT "movie_id", "keyword_id"
FROM movie_keyword) AS "t9" ON "t8"."id2" = "t9"."keyword_id" AND "t8"."movie_id" = "t9"."movie_id" AND "t8"."movie_id0" = "t9"."movie_id") AS "t10"
INNER JOIN (SELECT "id"
FROM name) AS "t11" ON "t10"."person_id" = "t11"."id" AND "t10"."person_id0" = "t11"."id") AS "t12"
INNER JOIN (SELECT "id", "title"
FROM title) AS "t13" ON "t12"."movie_id" = "t13"."id" AND "t12"."movie_id1" = "t13"."id" AND "t12"."movie_id0" = "t13"."id"
;
