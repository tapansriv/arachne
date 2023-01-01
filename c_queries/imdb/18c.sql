SELECT MIN("t14"."info1") AS "movie_budget", MIN("t14"."info2") AS "movie_votes", MIN("t15"."title") AS "movie_title"
FROM (SELECT "t10"."movie_id", "t10"."movie_id0", "t10"."info1", "t10"."movie_id1", "t10"."info2"
FROM (SELECT "t8"."person_id", "t8"."movie_id", "t8"."movie_id0", "t8"."info1", "t9"."movie_id" AS "movie_id1", "t9"."info" AS "info2"
FROM (SELECT "t1"."person_id", "t1"."movie_id", "t5"."id" AS "id1", "t7"."movie_id" AS "movie_id0", "t7"."info" AS "info1"
FROM (SELECT "person_id", "movie_id"
FROM cast_info
WHERE "note" IN ('(head writer)', '(story editor)', '(story)', '(writer)', '(written by)')) AS "t1"
CROSS JOIN 
(SELECT "id"
FROM info_type
WHERE "info" = 'genres') AS "t3"
CROSS JOIN 
(SELECT "id"
FROM info_type
WHERE "info" = 'votes') AS "t5"
INNER JOIN (SELECT "movie_id", "info_type_id", "info"
FROM movie_info
WHERE "info" IN ('Action', 'Crime', 'Horror', 'Sci-Fi', 'Thriller', 'War')) AS "t7" ON "t1"."movie_id" = "t7"."movie_id" AND "t3"."id" = "t7"."info_type_id") AS "t8"
INNER JOIN (SELECT "movie_id", "info_type_id", "info"
FROM movie_info_idx) AS "t9" ON "t8"."movie_id" = "t9"."movie_id" AND "t8"."movie_id0" = "t9"."movie_id" AND "t8"."id1" = "t9"."info_type_id") AS "t10"
INNER JOIN (SELECT "id"
FROM name
WHERE "gender" = 'm') AS "t13" ON "t10"."person_id" = "t13"."id") AS "t14"
INNER JOIN (SELECT "id", "title"
FROM title) AS "t15" ON "t14"."movie_id0" = "t15"."id" AND "t14"."movie_id1" = "t15"."id" AND "t14"."movie_id" = "t15"."id"
;
