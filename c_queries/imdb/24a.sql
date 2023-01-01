SELECT MIN("t27"."name0") AS "voiced_char_name", MIN("t27"."name2") AS "voicing_actress_name", MIN("t30"."title") AS "voiced_action_movie_jap_eng"
FROM (SELECT "t24"."name0", "t24"."movie_id", "t24"."movie_id0", "t24"."movie_id1", "t24"."movie_id2", "t24"."name2"
FROM (SELECT "t20"."name0", "t20"."movie_id", "t20"."role_id", "t20"."movie_id0", "t20"."movie_id1", "t20"."movie_id2", "t23"."name" AS "name2"
FROM (SELECT "t18"."person_id", "t18"."name0", "t18"."person_id0", "t18"."movie_id", "t18"."role_id", "t18"."movie_id0", "t18"."movie_id1", "t19"."movie_id" AS "movie_id2"
FROM (SELECT "t14"."person_id", "t14"."name0", "t14"."person_id0", "t14"."movie_id", "t14"."role_id", "t14"."id4", "t14"."movie_id0", "t17"."movie_id" AS "movie_id1"
FROM (SELECT "t4"."person_id", "t4"."name0", "t4"."person_id0", "t4"."movie_id", "t4"."role_id", "t9"."id" AS "id3", "t12"."id" AS "id4", "t13"."movie_id" AS "movie_id0"
FROM (SELECT "t"."person_id", "t0"."name" AS "name0", "t3"."person_id" AS "person_id0", "t3"."movie_id", "t3"."role_id"
FROM (SELECT "person_id"
FROM aka_name) AS "t"
CROSS JOIN 
(SELECT "id", "name"
FROM char_name) AS "t0"
INNER JOIN (SELECT "person_id", "movie_id", "person_role_id", "role_id"
FROM cast_info
WHERE "note" IN ('(voice)', '(voice) (uncredited)', '(voice: English version)', '(voice: Japanese version)')) AS "t3" ON "t"."person_id" = "t3"."person_id" AND "t0"."id" = "t3"."person_role_id") AS "t4"
CROSS JOIN 
(SELECT "id"
FROM company_name
WHERE "country_code" = '[us]') AS "t7"
CROSS JOIN 
(SELECT "id"
FROM info_type
WHERE "info" = 'release dates') AS "t9"
CROSS JOIN 
(SELECT "id"
FROM keyword
WHERE "keyword" IN ('hand-to-hand-combat', 'hero', 'martial-arts')) AS "t12"
INNER JOIN (SELECT "movie_id", "company_id"
FROM movie_companies) AS "t13" ON "t4"."movie_id" = "t13"."movie_id" AND "t7"."id" = "t13"."company_id") AS "t14"
INNER JOIN (SELECT "movie_id", "info_type_id"
FROM movie_info
WHERE "info" LIKE 'Japan:%201%' OR "info" LIKE 'USA:%201%') AS "t17" ON "t14"."movie_id0" = "t17"."movie_id" AND "t14"."movie_id" = "t17"."movie_id" AND "t14"."id3" = "t17"."info_type_id") AS "t18"
INNER JOIN (SELECT "movie_id", "keyword_id"
FROM movie_keyword) AS "t19" ON "t18"."movie_id0" = "t19"."movie_id" AND "t18"."movie_id1" = "t19"."movie_id" AND "t18"."movie_id" = "t19"."movie_id" AND "t18"."id4" = "t19"."keyword_id") AS "t20"
INNER JOIN (SELECT "id", "name"
FROM name
WHERE "gender" = 'f' AND "name" LIKE '%An%') AS "t23" ON "t20"."person_id0" = "t23"."id" AND "t20"."person_id" = "t23"."id") AS "t24"
INNER JOIN (SELECT "id"
FROM role_type
WHERE "role" = 'actress') AS "t26" ON "t24"."role_id" = "t26"."id") AS "t27"
INNER JOIN (SELECT "id", "title"
FROM title
WHERE "production_year" > 2010) AS "t30" ON "t27"."movie_id1" = "t30"."id" AND "t27"."movie_id0" = "t30"."id" AND "t27"."movie_id" = "t30"."id" AND "t27"."movie_id2" = "t30"."id"
;
