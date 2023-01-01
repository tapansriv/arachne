SELECT MIN("t13"."info1") AS "movie_budget", MIN("t13"."info2") AS "movie_votes", MIN("t14"."title") AS "movie_title"
FROM (SELECT "t9"."movie_id", "t9"."movie_id0", "t9"."info1", "t9"."movie_id1", "t9"."info2"
FROM (SELECT "t7"."person_id", "t7"."movie_id", "t7"."movie_id0", "t7"."info1", "t8"."movie_id" AS "movie_id1", "t8"."info" AS "info2"
FROM (SELECT "t1"."person_id", "t1"."movie_id", "t5"."id" AS "id1", "t6"."movie_id" AS "movie_id0", "t6"."info" AS "info1"
FROM (SELECT "person_id", "movie_id"
FROM cast_info
WHERE "note" IN ('(executive producer)', '(producer)')) AS "t1"
CROSS JOIN 
(SELECT "id"
FROM info_type
WHERE "info" = 'budget') AS "t3"
CROSS JOIN 
(SELECT "id"
FROM info_type
WHERE "info" = 'votes') AS "t5"
INNER JOIN (SELECT "movie_id", "info_type_id", "info"
FROM movie_info) AS "t6" ON "t1"."movie_id" = "t6"."movie_id" AND "t3"."id" = "t6"."info_type_id") AS "t7"
INNER JOIN (SELECT "movie_id", "info_type_id", "info"
FROM movie_info_idx) AS "t8" ON "t7"."movie_id" = "t8"."movie_id" AND "t7"."movie_id0" = "t8"."movie_id" AND "t7"."id1" = "t8"."info_type_id") AS "t9"
INNER JOIN (SELECT "id"
FROM name
WHERE "gender" = 'm' AND "name" LIKE '%Tim%') AS "t12" ON "t9"."person_id" = "t12"."id") AS "t13"
INNER JOIN (SELECT "id", "title"
FROM title) AS "t14" ON "t13"."movie_id0" = "t14"."id" AND "t13"."movie_id1" = "t14"."id" AND "t13"."movie_id" = "t14"."id"
;
