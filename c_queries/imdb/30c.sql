SELECT MIN("t26"."info1") AS "movie_budget", MIN("t26"."info2") AS "movie_votes", MIN("t26"."name") AS "writer", MIN("t27"."title") AS "complete_violent_movie"
FROM (SELECT "t22"."movie_id", "t22"."movie_id0", "t22"."movie_id1", "t22"."info1", "t22"."movie_id2", "t22"."info2", "t22"."movie_id3", "t25"."name"
FROM (SELECT "t20"."movie_id", "t20"."person_id", "t20"."movie_id0", "t20"."movie_id1", "t20"."info1", "t20"."movie_id2", "t20"."info2", "t21"."movie_id" AS "movie_id3"
FROM (SELECT "t18"."movie_id", "t18"."person_id", "t18"."movie_id0", "t18"."id5", "t18"."movie_id1", "t18"."info1", "t19"."movie_id" AS "movie_id2", "t19"."info" AS "info2"
FROM (SELECT "t5"."movie_id", "t8"."person_id", "t8"."movie_id" AS "movie_id0", "t12"."id" AS "id4", "t15"."id" AS "id5", "t17"."movie_id" AS "movie_id1", "t17"."info" AS "info1"
FROM (SELECT "t2"."movie_id"
FROM (SELECT "t"."movie_id", "t"."status_id"
FROM (SELECT "movie_id", "subject_id", "status_id"
FROM complete_cast) AS "t"
INNER JOIN (SELECT "id"
FROM comp_cast_type
WHERE "kind" = 'cast') AS "t1" ON "t"."subject_id" = "t1"."id") AS "t2"
INNER JOIN (SELECT "id"
FROM comp_cast_type
WHERE "kind" = 'complete+verified') AS "t4" ON "t2"."status_id" = "t4"."id") AS "t5"
INNER JOIN (SELECT "person_id", "movie_id"
FROM cast_info
WHERE "note" IN ('(head writer)', '(story editor)', '(story)', '(writer)', '(written by)')) AS "t8" ON "t5"."movie_id" = "t8"."movie_id"
CROSS JOIN 
(SELECT "id"
FROM info_type
WHERE "info" = 'genres') AS "t10"
CROSS JOIN 
(SELECT "id"
FROM info_type
WHERE "info" = 'votes') AS "t12"
CROSS JOIN 
(SELECT "id"
FROM keyword
WHERE "keyword" IN ('blood', 'death', 'female-nudity', 'gore', 'hospital', 'murder', 'violence')) AS "t15"
INNER JOIN (SELECT "movie_id", "info_type_id", "info"
FROM movie_info
WHERE "info" IN ('Action', 'Crime', 'Horror', 'Sci-Fi', 'Thriller', 'War')) AS "t17" ON "t8"."movie_id" = "t17"."movie_id" AND "t5"."movie_id" = "t17"."movie_id" AND "t10"."id" = "t17"."info_type_id") AS "t18"
INNER JOIN (SELECT "movie_id", "info_type_id", "info"
FROM movie_info_idx) AS "t19" ON "t18"."movie_id0" = "t19"."movie_id" AND "t18"."movie_id1" = "t19"."movie_id" AND "t18"."movie_id" = "t19"."movie_id" AND "t18"."id4" = "t19"."info_type_id") AS "t20"
INNER JOIN (SELECT "movie_id", "keyword_id"
FROM movie_keyword) AS "t21" ON "t20"."movie_id0" = "t21"."movie_id" AND "t20"."movie_id1" = "t21"."movie_id" AND "t20"."movie_id2" = "t21"."movie_id" AND "t20"."movie_id" = "t21"."movie_id" AND "t20"."id5" = "t21"."keyword_id") AS "t22"
INNER JOIN (SELECT "id", "name"
FROM name
WHERE "gender" = 'm') AS "t25" ON "t22"."person_id" = "t25"."id") AS "t26"
INNER JOIN (SELECT "id", "title"
FROM title) AS "t27" ON "t26"."movie_id1" = "t27"."id" AND "t26"."movie_id2" = "t27"."id" AND "t26"."movie_id0" = "t27"."id" AND "t26"."movie_id3" = "t27"."id" AND "t26"."movie_id" = "t27"."id"
;
