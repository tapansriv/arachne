SELECT MIN("t11"."name") AS "c", MIN("t14"."title") AS "movie_with_american_producer"
FROM (SELECT "t9"."name", "t9"."movie_id", "t9"."movie_id0"
FROM (SELECT "t3"."name", "t3"."movie_id", "t3"."role_id", "t8"."movie_id" AS "movie_id0"
FROM (SELECT "t"."name", "t2"."movie_id", "t2"."role_id"
FROM (SELECT "id", "name"
FROM char_name) AS "t"
INNER JOIN (SELECT "movie_id", "person_role_id", "role_id"
FROM cast_info
WHERE "note" LIKE '%(producer)%') AS "t2" ON "t"."id" = "t2"."person_role_id") AS "t3"
CROSS JOIN 
(SELECT "id"
FROM company_name
WHERE "country_code" = '[us]') AS "t6"
CROSS JOIN 
(SELECT "id"
FROM company_type) AS "t7"
INNER JOIN (SELECT "movie_id", "company_id", "company_type_id"
FROM movie_companies) AS "t8" ON "t3"."movie_id" = "t8"."movie_id" AND "t6"."id" = "t8"."company_id" AND "t7"."id" = "t8"."company_type_id") AS "t9"
INNER JOIN (SELECT "id"
FROM role_type) AS "t10" ON "t9"."role_id" = "t10"."id") AS "t11"
INNER JOIN (SELECT "id", "title"
FROM title
WHERE "production_year" > 1990) AS "t14" ON "t11"."movie_id0" = "t14"."id" AND "t11"."movie_id" = "t14"."id"
;
