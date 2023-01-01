SELECT MIN("t38"."name0") AS "voiced_char", MIN("t38"."name2") AS "voicing_actress", MIN("t41"."title") AS "voiced_animation"
FROM (SELECT "t35"."movie_id", "t35"."name0", "t35"."movie_id0", "t35"."movie_id1", "t35"."movie_id2", "t35"."movie_id3", "t35"."name2"
FROM (SELECT "t33"."movie_id", "t33"."name0", "t33"."movie_id0", "t33"."role_id", "t33"."movie_id1", "t33"."movie_id2", "t33"."movie_id3", "t33"."name2"
FROM (SELECT "t29"."movie_id", "t29"."name0", "t29"."person_id0", "t29"."movie_id0", "t29"."role_id", "t29"."id7", "t29"."movie_id1", "t29"."movie_id2", "t29"."movie_id3", "t32"."id" AS "id12", "t32"."name" AS "name2"
FROM (SELECT "t27"."person_id", "t27"."movie_id", "t27"."name0", "t27"."person_id0", "t27"."movie_id0", "t27"."role_id", "t27"."id7", "t27"."movie_id1", "t27"."movie_id2", "t28"."movie_id" AS "movie_id3"
FROM (SELECT "t23"."person_id", "t23"."movie_id", "t23"."name0", "t23"."person_id0", "t23"."movie_id0", "t23"."role_id", "t23"."id7", "t23"."id8", "t23"."movie_id1", "t26"."movie_id" AS "movie_id2"
FROM (SELECT "t11"."person_id", "t11"."movie_id", "t11"."name0", "t11"."person_id0", "t11"."movie_id0", "t11"."role_id", "t16"."id" AS "id6", "t18"."id" AS "id7", "t21"."id" AS "id8", "t22"."movie_id" AS "movie_id1"
FROM (SELECT "t6"."person_id", "t6"."movie_id", "t7"."name" AS "name0", "t10"."person_id" AS "person_id0", "t10"."movie_id" AS "movie_id0", "t10"."role_id"
FROM (SELECT "t3"."person_id", "t3"."movie_id"
FROM (SELECT "t"."person_id", "t0"."movie_id", "t0"."status_id"
FROM (SELECT "person_id"
FROM aka_name) AS "t"
CROSS JOIN 
(SELECT "movie_id", "subject_id", "status_id"
FROM complete_cast) AS "t0"
INNER JOIN (SELECT "id"
FROM comp_cast_type
WHERE "kind" = 'cast') AS "t2" ON "t0"."subject_id" = "t2"."id") AS "t3"
INNER JOIN (SELECT "id"
FROM comp_cast_type
WHERE "kind" = 'complete+verified') AS "t5" ON "t3"."status_id" = "t5"."id") AS "t6"
CROSS JOIN 
(SELECT "id", "name"
FROM char_name) AS "t7"
INNER JOIN (SELECT "person_id", "movie_id", "person_role_id", "role_id"
FROM cast_info
WHERE "note" IN ('(voice)', '(voice) (uncredited)', '(voice: English version)', '(voice: Japanese version)')) AS "t10" ON "t6"."movie_id" = "t10"."movie_id" AND "t6"."person_id" = "t10"."person_id" AND "t7"."id" = "t10"."person_role_id") AS "t11"
CROSS JOIN 
(SELECT "id"
FROM company_name
WHERE "country_code" = '[us]') AS "t14"
CROSS JOIN 
(SELECT "id"
FROM info_type
WHERE "info" = 'release dates') AS "t16"
CROSS JOIN 
(SELECT "id"
FROM info_type
WHERE "info" = 'trivia') AS "t18"
CROSS JOIN 
(SELECT "id"
FROM keyword
WHERE "keyword" = 'computer-animation') AS "t21"
INNER JOIN (SELECT "movie_id", "company_id"
FROM movie_companies) AS "t22" ON "t11"."movie_id0" = "t22"."movie_id" AND "t11"."movie_id" = "t22"."movie_id" AND "t14"."id" = "t22"."company_id") AS "t23"
INNER JOIN (SELECT "movie_id", "info_type_id"
FROM movie_info
WHERE "info" LIKE 'Japan:%200%' OR "info" LIKE 'USA:%200%') AS "t26" ON "t23"."movie_id1" = "t26"."movie_id" AND "t23"."movie_id0" = "t26"."movie_id" AND "t23"."movie_id" = "t26"."movie_id" AND "t23"."id6" = "t26"."info_type_id") AS "t27"
INNER JOIN (SELECT "movie_id", "keyword_id"
FROM movie_keyword) AS "t28" ON "t27"."movie_id1" = "t28"."movie_id" AND "t27"."movie_id2" = "t28"."movie_id" AND "t27"."movie_id0" = "t28"."movie_id" AND "t27"."movie_id" = "t28"."movie_id" AND "t27"."id8" = "t28"."keyword_id") AS "t29"
INNER JOIN (SELECT "id", "name"
FROM name
WHERE "gender" = 'f' AND "name" LIKE '%An%') AS "t32" ON "t29"."person_id0" = "t32"."id" AND "t29"."person_id" = "t32"."id") AS "t33"
INNER JOIN (SELECT "person_id", "info_type_id"
FROM person_info) AS "t34" ON "t33"."id12" = "t34"."person_id" AND "t33"."person_id0" = "t34"."person_id" AND "t33"."id7" = "t34"."info_type_id") AS "t35"
INNER JOIN (SELECT "id"
FROM role_type
WHERE "role" = 'actress') AS "t37" ON "t35"."role_id" = "t37"."id") AS "t38"
INNER JOIN (SELECT "id", "title"
FROM title
WHERE "production_year" >= 2000 AND "production_year" <= 2010) AS "t41" ON "t38"."movie_id2" = "t41"."id" AND "t38"."movie_id1" = "t41"."id" AND "t38"."movie_id0" = "t41"."id" AND "t38"."movie_id3" = "t41"."id" AND "t38"."movie_id" = "t41"."id"
;
