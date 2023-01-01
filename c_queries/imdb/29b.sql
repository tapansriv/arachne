SELECT MIN("t39"."name0") AS "voiced_char", MIN("t39"."name2") AS "voicing_actress", MIN("t42"."title") AS "voiced_animation"
FROM (SELECT "t36"."movie_id", "t36"."name0", "t36"."movie_id0", "t36"."movie_id1", "t36"."movie_id2", "t36"."movie_id3", "t36"."name2"
FROM (SELECT "t34"."movie_id", "t34"."name0", "t34"."movie_id0", "t34"."role_id", "t34"."movie_id1", "t34"."movie_id2", "t34"."movie_id3", "t34"."name2"
FROM (SELECT "t30"."movie_id", "t30"."name0", "t30"."person_id0", "t30"."movie_id0", "t30"."role_id", "t30"."id7", "t30"."movie_id1", "t30"."movie_id2", "t30"."movie_id3", "t33"."id" AS "id12", "t33"."name" AS "name2"
FROM (SELECT "t28"."person_id", "t28"."movie_id", "t28"."name0", "t28"."person_id0", "t28"."movie_id0", "t28"."role_id", "t28"."id7", "t28"."movie_id1", "t28"."movie_id2", "t29"."movie_id" AS "movie_id3"
FROM (SELECT "t24"."person_id", "t24"."movie_id", "t24"."name0", "t24"."person_id0", "t24"."movie_id0", "t24"."role_id", "t24"."id7", "t24"."id8", "t24"."movie_id1", "t27"."movie_id" AS "movie_id2"
FROM (SELECT "t12"."person_id", "t12"."movie_id", "t12"."name0", "t12"."person_id0", "t12"."movie_id0", "t12"."role_id", "t17"."id" AS "id6", "t19"."id" AS "id7", "t22"."id" AS "id8", "t23"."movie_id" AS "movie_id1"
FROM (SELECT "t6"."person_id", "t6"."movie_id", "t8"."name" AS "name0", "t11"."person_id" AS "person_id0", "t11"."movie_id" AS "movie_id0", "t11"."role_id"
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
FROM char_name
WHERE "name" = 'Queen') AS "t8"
INNER JOIN (SELECT "person_id", "movie_id", "person_role_id", "role_id"
FROM cast_info
WHERE "note" IN ('(voice)', '(voice) (uncredited)', '(voice: English version)')) AS "t11" ON "t6"."movie_id" = "t11"."movie_id" AND "t6"."person_id" = "t11"."person_id" AND "t8"."id" = "t11"."person_role_id") AS "t12"
CROSS JOIN 
(SELECT "id"
FROM company_name
WHERE "country_code" = '[us]') AS "t15"
CROSS JOIN 
(SELECT "id"
FROM info_type
WHERE "info" = 'release dates') AS "t17"
CROSS JOIN 
(SELECT "id"
FROM info_type
WHERE "info" = 'height') AS "t19"
CROSS JOIN 
(SELECT "id"
FROM keyword
WHERE "keyword" = 'computer-animation') AS "t22"
INNER JOIN (SELECT "movie_id", "company_id"
FROM movie_companies) AS "t23" ON "t12"."movie_id0" = "t23"."movie_id" AND "t12"."movie_id" = "t23"."movie_id" AND "t15"."id" = "t23"."company_id") AS "t24"
INNER JOIN (SELECT "movie_id", "info_type_id"
FROM movie_info
WHERE "info" LIKE 'USA:%200%') AS "t27" ON "t24"."movie_id1" = "t27"."movie_id" AND "t24"."movie_id0" = "t27"."movie_id" AND "t24"."movie_id" = "t27"."movie_id" AND "t24"."id6" = "t27"."info_type_id") AS "t28"
INNER JOIN (SELECT "movie_id", "keyword_id"
FROM movie_keyword) AS "t29" ON "t28"."movie_id1" = "t29"."movie_id" AND "t28"."movie_id2" = "t29"."movie_id" AND "t28"."movie_id0" = "t29"."movie_id" AND "t28"."movie_id" = "t29"."movie_id" AND "t28"."id8" = "t29"."keyword_id") AS "t30"
INNER JOIN (SELECT "id", "name"
FROM name
WHERE "gender" = 'f' AND "name" LIKE '%An%') AS "t33" ON "t30"."person_id0" = "t33"."id" AND "t30"."person_id" = "t33"."id") AS "t34"
INNER JOIN (SELECT "person_id", "info_type_id"
FROM person_info) AS "t35" ON "t34"."id12" = "t35"."person_id" AND "t34"."person_id0" = "t35"."person_id" AND "t34"."id7" = "t35"."info_type_id") AS "t36"
INNER JOIN (SELECT "id"
FROM role_type
WHERE "role" = 'actress') AS "t38" ON "t36"."role_id" = "t38"."id") AS "t39"
INNER JOIN (SELECT "id", "title"
FROM title
WHERE "title" = 'Shrek 2' AND ("production_year" >= 2000 AND "production_year" <= 2005)) AS "t42" ON "t39"."movie_id2" = "t42"."id" AND "t39"."movie_id1" = "t42"."id" AND "t39"."movie_id0" = "t42"."id" AND "t39"."movie_id3" = "t42"."id" AND "t39"."movie_id" = "t42"."id"
;
