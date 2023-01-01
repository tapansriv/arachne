SELECT MIN("t22"."name2") AS "voicing_actress", MIN("t25"."title") AS "jap_engl_voiced_movie"
FROM (SELECT "t19"."movie_id", "t19"."movie_id0", "t19"."movie_id1", "t19"."name2"
FROM (SELECT "t15"."movie_id", "t15"."role_id", "t15"."movie_id0", "t15"."movie_id1", "t18"."name" AS "name2"
FROM (SELECT "t11"."person_id", "t11"."person_id0", "t11"."movie_id", "t11"."role_id", "t11"."movie_id0", "t14"."movie_id" AS "movie_id1"
FROM (SELECT "t4"."person_id", "t4"."person_id0", "t4"."movie_id", "t4"."role_id", "t9"."id" AS "id3", "t10"."movie_id" AS "movie_id0"
FROM (SELECT "t"."person_id", "t3"."person_id" AS "person_id0", "t3"."movie_id", "t3"."role_id"
FROM (SELECT "person_id"
FROM aka_name) AS "t"
CROSS JOIN 
(SELECT "id"
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
INNER JOIN (SELECT "movie_id", "company_id"
FROM movie_companies) AS "t10" ON "t4"."movie_id" = "t10"."movie_id" AND "t7"."id" = "t10"."company_id") AS "t11"
INNER JOIN (SELECT "movie_id", "info_type_id"
FROM movie_info
WHERE "info" LIKE 'Japan:%200%' OR "info" LIKE 'USA:%200%') AS "t14" ON "t11"."movie_id0" = "t14"."movie_id" AND "t11"."movie_id" = "t14"."movie_id" AND "t11"."id3" = "t14"."info_type_id") AS "t15"
INNER JOIN (SELECT "id", "name"
FROM name
WHERE "gender" = 'f' AND "name" LIKE '%An%') AS "t18" ON "t15"."person_id0" = "t18"."id" AND "t15"."person_id" = "t18"."id") AS "t19"
INNER JOIN (SELECT "id"
FROM role_type
WHERE "role" = 'actress') AS "t21" ON "t19"."role_id" = "t21"."id") AS "t22"
INNER JOIN (SELECT "id", "title"
FROM title
WHERE "production_year" > 2000) AS "t25" ON "t22"."movie_id1" = "t25"."id" AND "t22"."movie_id0" = "t25"."id" AND "t22"."movie_id" = "t25"."id"
;
