SELECT MIN("t19"."info1") AS "movie_budget", MIN("t19"."info2") AS "movie_votes", MIN("t19"."name") AS "male_writer", MIN("t20"."title") AS "violent_movie_title"
FROM (SELECT "t15"."movie_id", "t15"."movie_id0", "t15"."info1", "t15"."movie_id1", "t15"."info2", "t15"."movie_id2", "t18"."name"
FROM (SELECT "t13"."person_id", "t13"."movie_id", "t13"."movie_id0", "t13"."info1", "t13"."movie_id1", "t13"."info2", "t14"."movie_id" AS "movie_id2"
FROM (SELECT "t11"."person_id", "t11"."movie_id", "t11"."id2", "t11"."movie_id0", "t11"."info1", "t12"."movie_id" AS "movie_id1", "t12"."info" AS "info2"
FROM (SELECT "t1"."person_id", "t1"."movie_id", "t5"."id" AS "id1", "t8"."id" AS "id2", "t10"."movie_id" AS "movie_id0", "t10"."info" AS "info1"
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
CROSS JOIN 
(SELECT "id"
FROM keyword
WHERE "keyword" IN ('blood', 'death', 'female-nudity', 'gore', 'hospital', 'murder', 'violence')) AS "t8"
INNER JOIN (SELECT "movie_id", "info_type_id", "info"
FROM movie_info
WHERE "info" IN ('Action', 'Crime', 'Horror', 'Sci-Fi', 'Thriller', 'War')) AS "t10" ON "t1"."movie_id" = "t10"."movie_id" AND "t3"."id" = "t10"."info_type_id") AS "t11"
INNER JOIN (SELECT "movie_id", "info_type_id", "info"
FROM movie_info_idx) AS "t12" ON "t11"."movie_id" = "t12"."movie_id" AND "t11"."movie_id0" = "t12"."movie_id" AND "t11"."id1" = "t12"."info_type_id") AS "t13"
INNER JOIN (SELECT "movie_id", "keyword_id"
FROM movie_keyword) AS "t14" ON "t13"."movie_id" = "t14"."movie_id" AND "t13"."movie_id0" = "t14"."movie_id" AND "t13"."movie_id1" = "t14"."movie_id" AND "t13"."id2" = "t14"."keyword_id") AS "t15"
INNER JOIN (SELECT "id", "name"
FROM name
WHERE "gender" = 'm') AS "t18" ON "t15"."person_id" = "t18"."id") AS "t19"
INNER JOIN (SELECT "id", "title"
FROM title) AS "t20" ON "t19"."movie_id0" = "t20"."id" AND "t19"."movie_id1" = "t20"."id" AND "t19"."movie_id" = "t20"."id" AND "t19"."movie_id2" = "t20"."id"
;
