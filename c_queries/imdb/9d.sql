SELECT MIN("t16"."name") AS "alternative_name", MIN("t16"."name0") AS "voiced_char_name", MIN("t16"."name2") AS "voicing_actress", MIN("t17"."title") AS "american_movie"
FROM (SELECT "t13"."name", "t13"."name0", "t13"."movie_id", "t13"."movie_id0", "t13"."name2"
FROM (SELECT "t9"."name", "t9"."name0", "t9"."movie_id", "t9"."role_id", "t9"."movie_id0", "t12"."name" AS "name2"
FROM (SELECT "t4"."person_id", "t4"."name", "t4"."name0", "t4"."person_id0", "t4"."movie_id", "t4"."role_id", "t8"."movie_id" AS "movie_id0"
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
FROM movie_companies) AS "t8" ON "t4"."movie_id" = "t8"."movie_id" AND "t7"."id" = "t8"."company_id") AS "t9"
INNER JOIN (SELECT "id", "name"
FROM name
WHERE "gender" = 'f') AS "t12" ON "t9"."person_id0" = "t12"."id" AND "t9"."person_id" = "t12"."id") AS "t13"
INNER JOIN (SELECT "id"
FROM role_type
WHERE "role" = 'actress') AS "t15" ON "t13"."role_id" = "t15"."id") AS "t16"
INNER JOIN (SELECT "id", "title"
FROM title) AS "t17" ON "t16"."movie_id" = "t17"."id" AND "t16"."movie_id0" = "t17"."id"
;
