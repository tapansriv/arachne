SELECT MIN("t13"."info1") AS "budget", MIN("t16"."title") AS "unsuccsessful_movie"
FROM (SELECT "t11"."movie_id", "t11"."movie_id0", "t11"."info1", "t12"."movie_id" AS "movie_id1"
FROM (SELECT "t9"."id2", "t9"."movie_id", "t10"."movie_id" AS "movie_id0", "t10"."info" AS "info1"
FROM (SELECT "t5"."id" AS "id1", "t7"."id" AS "id2", "t8"."movie_id"
FROM (SELECT "id"
FROM company_name
WHERE "country_code" = '[us]') AS "t1"
CROSS JOIN 
(SELECT "id"
FROM company_type
WHERE "kind" IN ('distributors', 'production companies')) AS "t3"
CROSS JOIN 
(SELECT "id"
FROM info_type
WHERE "info" = 'budget') AS "t5"
CROSS JOIN 
(SELECT "id"
FROM info_type
WHERE "info" = 'bottom 10 rank') AS "t7"
INNER JOIN (SELECT "movie_id", "company_id", "company_type_id"
FROM movie_companies) AS "t8" ON "t3"."id" = "t8"."company_type_id" AND "t1"."id" = "t8"."company_id") AS "t9"
INNER JOIN (SELECT "movie_id", "info_type_id", "info"
FROM movie_info) AS "t10" ON "t9"."id1" = "t10"."info_type_id" AND "t9"."movie_id" = "t10"."movie_id") AS "t11"
INNER JOIN (SELECT "movie_id", "info_type_id"
FROM movie_info_idx) AS "t12" ON "t11"."id2" = "t12"."info_type_id" AND "t11"."movie_id" = "t12"."movie_id" AND "t11"."movie_id0" = "t12"."movie_id") AS "t13"
INNER JOIN (SELECT "id", "title"
FROM title
WHERE "production_year" > 2000 AND ("title" LIKE 'Birdemic%' OR "title" LIKE '%Movie%')) AS "t16" ON "t13"."movie_id0" = "t16"."id" AND "t13"."movie_id1" = "t16"."id" AND "t13"."movie_id" = "t16"."id"
;
