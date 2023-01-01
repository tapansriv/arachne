SELECT MIN("t18"."name") AS "alternative_name", MIN("t18"."name0") AS "character_name", MIN("t21"."title") AS "movie"
FROM (SELECT "t15"."name", "t15"."name0", "t15"."movie_id", "t15"."movie_id0"
FROM (SELECT "t11"."name", "t11"."name0", "t11"."movie_id", "t11"."role_id", "t11"."movie_id0"
FROM (SELECT "t4"."person_id", "t4"."name", "t4"."name0", "t4"."person_id0", "t4"."movie_id", "t4"."role_id", "t10"."movie_id" AS "movie_id0"
FROM (SELECT "t"."person_id", "t"."name", "t0"."name" AS "name0", "t3"."person_id" AS "person_id0", "t3"."movie_id", "t3"."role_id"
FROM (SELECT "person_id", "name"
FROM aka_name) AS "t"
CROSS JOIN 
(SELECT "id", "name"
FROM char_name) AS "t0"
INNER JOIN (SELECT "person_id", "movie_id", "person_role_id", "role_id"
FROM cast_info
WHERE "note" IN ('(voice)', '(voice) (uncredited)', '(voice: English version)', '(voice: Japanese version)')) AS "t3" ON "t0"."id" = "t3"."person_role_id" AND "t"."person_id" = "t3"."person_id") AS "t4"
CROSS JOIN 
(SELECT "id"
FROM company_name
WHERE "country_code" = '[us]') AS "t7"
INNER JOIN (SELECT "movie_id", "company_id"
FROM movie_companies
WHERE "note" LIKE '%(USA)%' OR "note" LIKE '%(worldwide)%') AS "t10" ON "t4"."movie_id" = "t10"."movie_id" AND "t7"."id" = "t10"."company_id") AS "t11"
INNER JOIN (SELECT "id"
FROM name
WHERE "gender" = 'f' AND "name" LIKE '%Ang%') AS "t14" ON "t11"."person_id0" = "t14"."id" AND "t11"."person_id" = "t14"."id") AS "t15"
INNER JOIN (SELECT "id"
FROM role_type
WHERE "role" = 'actress') AS "t17" ON "t15"."role_id" = "t17"."id") AS "t18"
INNER JOIN (SELECT "id", "title"
FROM title
WHERE "production_year" >= 2005 AND "production_year" <= 2015) AS "t21" ON "t18"."movie_id" = "t21"."id" AND "t18"."movie_id0" = "t21"."id"
;
