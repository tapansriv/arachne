SELECT MIN("t10"."name") AS "writer_pseudo_name", MIN("t11"."title") AS "movie_title"
FROM (SELECT "t7"."name", "t7"."movie_id", "t7"."movie_id0"
FROM (SELECT "t5"."name", "t5"."movie_id", "t5"."role_id", "t5"."movie_id0"
FROM (SELECT "t"."person_id", "t"."name", "t0"."person_id" AS "person_id0", "t0"."movie_id", "t0"."role_id", "t4"."movie_id" AS "movie_id0"
FROM (SELECT "person_id", "name"
FROM aka_name) AS "t"
INNER JOIN (SELECT "person_id", "movie_id", "role_id"
FROM cast_info) AS "t0" ON "t"."person_id" = "t0"."person_id"
CROSS JOIN 
(SELECT "id"
FROM company_name
WHERE "country_code" = '[us]') AS "t3"
INNER JOIN (SELECT "movie_id", "company_id"
FROM movie_companies) AS "t4" ON "t3"."id" = "t4"."company_id" AND "t0"."movie_id" = "t4"."movie_id") AS "t5"
INNER JOIN (SELECT "id"
FROM name) AS "t6" ON "t5"."person_id" = "t6"."id" AND "t5"."person_id0" = "t6"."id") AS "t7"
INNER JOIN (SELECT "id"
FROM role_type
WHERE "role" = 'writer') AS "t9" ON "t7"."role_id" = "t9"."id") AS "t10"
INNER JOIN (SELECT "id", "title"
FROM title) AS "t11" ON "t10"."movie_id" = "t11"."id" AND "t10"."movie_id0" = "t11"."id"
;
