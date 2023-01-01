SELECT MIN("t13"."name0") AS "cast_member_name", MIN("t13"."info0") AS "cast_member_info"
FROM (SELECT "t8"."movie_id", "t8"."linked_movie_id", "t11"."name" AS "name0", "t12"."info" AS "info0"
FROM (SELECT "t1"."person_id", "t2"."person_id" AS "person_id0", "t2"."movie_id", "t4"."id" AS "id1", "t7"."linked_movie_id"
FROM (SELECT "person_id"
FROM aka_name
WHERE "name" LIKE '%a%' OR "name" LIKE 'A%') AS "t1"
INNER JOIN (SELECT "person_id", "movie_id"
FROM cast_info) AS "t2" ON "t1"."person_id" = "t2"."person_id"
CROSS JOIN 
(SELECT "id"
FROM info_type
WHERE "info" = 'mini biography') AS "t4"
CROSS JOIN 
(SELECT "id"
FROM link_type
WHERE "link" IN ('featured in', 'features', 'referenced in', 'references')) AS "t6"
INNER JOIN (SELECT "linked_movie_id", "link_type_id"
FROM movie_link) AS "t7" ON "t6"."id" = "t7"."link_type_id" AND "t2"."movie_id" = "t7"."linked_movie_id") AS "t8"
INNER JOIN (SELECT "id", "name"
FROM name
WHERE "name_pcode_cf" >= 'A' AND "name_pcode_cf" <= 'F' AND ("gender" = 'm' OR "gender" = 'f' AND "name" LIKE 'A%')) AS "t11" ON "t8"."person_id" = "t11"."id" AND "t8"."person_id0" = "t11"."id"
INNER JOIN (SELECT "person_id", "info_type_id", "info"
FROM person_info) AS "t12" ON "t11"."id" = "t12"."person_id" AND "t8"."id1" = "t12"."info_type_id" AND "t8"."person_id" = "t12"."person_id" AND "t8"."person_id0" = "t12"."person_id") AS "t13"
INNER JOIN (SELECT "id"
FROM title
WHERE "production_year" >= 1980 AND "production_year" <= 2010) AS "t16" ON "t13"."movie_id" = "t16"."id" AND "t13"."linked_movie_id" = "t16"."id"
;
