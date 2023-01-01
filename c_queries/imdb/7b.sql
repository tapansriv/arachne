SELECT MIN("t15"."name0") AS "of_person", MIN("t18"."title") AS "biography_movie"
FROM (SELECT "t8"."movie_id", "t8"."linked_movie_id", "t11"."name" AS "name0"
FROM (SELECT "t1"."person_id", "t2"."person_id" AS "person_id0", "t2"."movie_id", "t4"."id" AS "id1", "t7"."linked_movie_id"
FROM (SELECT "person_id"
FROM aka_name
WHERE "name" LIKE '%a%') AS "t1"
INNER JOIN (SELECT "person_id", "movie_id"
FROM cast_info) AS "t2" ON "t1"."person_id" = "t2"."person_id"
CROSS JOIN 
(SELECT "id"
FROM info_type
WHERE "info" = 'mini biography') AS "t4"
CROSS JOIN 
(SELECT "id"
FROM link_type
WHERE "link" = 'features') AS "t6"
INNER JOIN (SELECT "linked_movie_id", "link_type_id"
FROM movie_link) AS "t7" ON "t6"."id" = "t7"."link_type_id" AND "t2"."movie_id" = "t7"."linked_movie_id") AS "t8"
INNER JOIN (SELECT "id", "name"
FROM name
WHERE "name_pcode_cf" LIKE 'D%' AND "gender" = 'm') AS "t11" ON "t8"."person_id" = "t11"."id" AND "t8"."person_id0" = "t11"."id"
INNER JOIN (SELECT "person_id", "info_type_id"
FROM person_info
WHERE "note" = 'Volker Boehm') AS "t14" ON "t11"."id" = "t14"."person_id" AND "t8"."id1" = "t14"."info_type_id" AND "t8"."person_id" = "t14"."person_id" AND "t8"."person_id0" = "t14"."person_id") AS "t15"
INNER JOIN (SELECT "id", "title"
FROM title
WHERE "production_year" >= 1980 AND "production_year" <= 1984) AS "t18" ON "t15"."movie_id" = "t18"."id" AND "t15"."linked_movie_id" = "t18"."id"
;
