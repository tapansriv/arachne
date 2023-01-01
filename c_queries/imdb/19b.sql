SELECT MIN("t24"."name2") AS "voicing_actress", MIN("t27"."title") AS "kung_fu_panda"
FROM (SELECT "t21"."movie_id", "t21"."movie_id0", "t21"."movie_id1", "t21"."name2"
FROM (SELECT "t17"."movie_id", "t17"."role_id", "t17"."movie_id0", "t17"."movie_id1", "t20"."name" AS "name2"
FROM (SELECT "t13"."person_id", "t13"."person_id0", "t13"."movie_id", "t13"."role_id", "t13"."movie_id0", "t16"."movie_id" AS "movie_id1"
FROM (SELECT "t4"."person_id", "t4"."person_id0", "t4"."movie_id", "t4"."role_id", "t9"."id" AS "id3", "t12"."movie_id" AS "movie_id0"
FROM (SELECT "t"."person_id", "t3"."person_id" AS "person_id0", "t3"."movie_id", "t3"."role_id"
FROM (SELECT "person_id"
FROM aka_name) AS "t"
CROSS JOIN 
(SELECT "id"
FROM char_name) AS "t0"
INNER JOIN (SELECT "person_id", "movie_id", "person_role_id", "role_id"
FROM cast_info
WHERE "note" = '(voice)') AS "t3" ON "t"."person_id" = "t3"."person_id" AND "t0"."id" = "t3"."person_role_id") AS "t4"
CROSS JOIN 
(SELECT "id"
FROM company_name
WHERE "country_code" = '[us]') AS "t7"
CROSS JOIN 
(SELECT "id"
FROM info_type
WHERE "info" = 'release dates') AS "t9"
INNER JOIN (SELECT "movie_id", "company_id"
FROM movie_companies
WHERE "note" LIKE '%(200%)%' AND ("note" LIKE '%(USA)%' OR "note" LIKE '%(worldwide)%')) AS "t12" ON "t4"."movie_id" = "t12"."movie_id" AND "t7"."id" = "t12"."company_id") AS "t13"
INNER JOIN (SELECT "movie_id", "info_type_id"
FROM movie_info
WHERE "info" LIKE 'Japan:%2007%' OR "info" LIKE 'USA:%2008%') AS "t16" ON "t13"."movie_id0" = "t16"."movie_id" AND "t13"."movie_id" = "t16"."movie_id" AND "t13"."id3" = "t16"."info_type_id") AS "t17"
INNER JOIN (SELECT "id", "name"
FROM name
WHERE "gender" = 'f' AND "name" LIKE '%Angel%') AS "t20" ON "t17"."person_id0" = "t20"."id" AND "t17"."person_id" = "t20"."id") AS "t21"
INNER JOIN (SELECT "id"
FROM role_type
WHERE "role" = 'actress') AS "t23" ON "t21"."role_id" = "t23"."id") AS "t24"
INNER JOIN (SELECT "id", "title"
FROM title
WHERE "production_year" >= 2007 AND "production_year" <= 2008 AND "title" LIKE '%Kung%Fu%Panda%') AS "t27" ON "t24"."movie_id1" = "t27"."id" AND "t24"."movie_id0" = "t27"."id" AND "t24"."movie_id" = "t27"."id"
;
