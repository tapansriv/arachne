SELECT MIN("t22"."info1") AS "movie_budget", MIN("t22"."info2") AS "movie_votes", MIN("t22"."name0") AS "writer", MIN("t23"."title") AS "violent_liongate_movie"
FROM (SELECT "t20"."movie_id", "t20"."movie_id0", "t20"."movie_id1", "t20"."info1", "t20"."movie_id2", "t20"."info2", "t20"."movie_id3", "t21"."name" AS "name0"
FROM (SELECT "t18"."person_id", "t18"."movie_id", "t18"."movie_id0", "t18"."movie_id1", "t18"."info1", "t18"."movie_id2", "t18"."info2", "t19"."movie_id" AS "movie_id3"
FROM (SELECT "t16"."person_id", "t16"."movie_id", "t16"."id3", "t16"."movie_id0", "t16"."movie_id1", "t16"."info1", "t17"."movie_id" AS "movie_id2", "t17"."info" AS "info2"
FROM (SELECT "t13"."person_id", "t13"."movie_id", "t13"."id2", "t13"."id3", "t13"."movie_id0", "t15"."movie_id" AS "movie_id1", "t15"."info" AS "info1"
FROM (SELECT "t1"."person_id", "t1"."movie_id", "t6"."id" AS "id1", "t8"."id" AS "id2", "t11"."id" AS "id3", "t12"."movie_id" AS "movie_id0"
FROM (SELECT "person_id", "movie_id"
FROM cast_info
WHERE "note" IN ('(head writer)', '(story editor)', '(story)', '(writer)', '(written by)')) AS "t1"
CROSS JOIN 
(SELECT "id"
FROM company_name
WHERE "name" LIKE 'Lionsgate%') AS "t4"
CROSS JOIN 
(SELECT "id"
FROM info_type
WHERE "info" = 'genres') AS "t6"
CROSS JOIN 
(SELECT "id"
FROM info_type
WHERE "info" = 'votes') AS "t8"
CROSS JOIN 
(SELECT "id"
FROM keyword
WHERE "keyword" IN ('blood', 'death', 'female-nudity', 'gore', 'hospital', 'murder', 'violence')) AS "t11"
INNER JOIN (SELECT "movie_id", "company_id"
FROM movie_companies) AS "t12" ON "t1"."movie_id" = "t12"."movie_id" AND "t4"."id" = "t12"."company_id") AS "t13"
INNER JOIN (SELECT "movie_id", "info_type_id", "info"
FROM movie_info
WHERE "info" IN ('Action', 'Crime', 'Horror', 'Sci-Fi', 'Thriller', 'War')) AS "t15" ON "t13"."movie_id" = "t15"."movie_id" AND "t13"."movie_id0" = "t15"."movie_id" AND "t13"."id1" = "t15"."info_type_id") AS "t16"
INNER JOIN (SELECT "movie_id", "info_type_id", "info"
FROM movie_info_idx) AS "t17" ON "t16"."movie_id" = "t17"."movie_id" AND "t16"."movie_id1" = "t17"."movie_id" AND "t16"."movie_id0" = "t17"."movie_id" AND "t16"."id2" = "t17"."info_type_id") AS "t18"
INNER JOIN (SELECT "movie_id", "keyword_id"
FROM movie_keyword) AS "t19" ON "t18"."movie_id" = "t19"."movie_id" AND "t18"."movie_id1" = "t19"."movie_id" AND "t18"."movie_id2" = "t19"."movie_id" AND "t18"."movie_id0" = "t19"."movie_id" AND "t18"."id3" = "t19"."keyword_id") AS "t20"
INNER JOIN (SELECT "id", "name"
FROM name) AS "t21" ON "t20"."person_id" = "t21"."id") AS "t22"
INNER JOIN (SELECT "id", "title"
FROM title) AS "t23" ON "t22"."movie_id1" = "t23"."id" AND "t22"."movie_id2" = "t23"."id" AND "t22"."movie_id" = "t23"."id" AND "t22"."movie_id3" = "t23"."id" AND "t22"."movie_id0" = "t23"."id"
;
