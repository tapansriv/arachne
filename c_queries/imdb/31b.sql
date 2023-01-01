SELECT MIN("t26"."info1") AS "movie_budget", MIN("t26"."info2") AS "movie_votes", MIN("t26"."name0") AS "writer", MIN("t29"."title") AS "violent_liongate_movie"
FROM (SELECT "t22"."movie_id", "t22"."movie_id0", "t22"."movie_id1", "t22"."info1", "t22"."movie_id2", "t22"."info2", "t22"."movie_id3", "t25"."name" AS "name0"
FROM (SELECT "t20"."person_id", "t20"."movie_id", "t20"."movie_id0", "t20"."movie_id1", "t20"."info1", "t20"."movie_id2", "t20"."info2", "t21"."movie_id" AS "movie_id3"
FROM (SELECT "t18"."person_id", "t18"."movie_id", "t18"."id3", "t18"."movie_id0", "t18"."movie_id1", "t18"."info1", "t19"."movie_id" AS "movie_id2", "t19"."info" AS "info2"
FROM (SELECT "t15"."person_id", "t15"."movie_id", "t15"."id2", "t15"."id3", "t15"."movie_id0", "t17"."movie_id" AS "movie_id1", "t17"."info" AS "info1"
FROM (SELECT "t1"."person_id", "t1"."movie_id", "t6"."id" AS "id1", "t8"."id" AS "id2", "t11"."id" AS "id3", "t14"."movie_id" AS "movie_id0"
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
FROM movie_companies
WHERE "note" LIKE '%(Blu-ray)%') AS "t14" ON "t1"."movie_id" = "t14"."movie_id" AND "t4"."id" = "t14"."company_id") AS "t15"
INNER JOIN (SELECT "movie_id", "info_type_id", "info"
FROM movie_info
WHERE "info" IN ('Horror', 'Thriller')) AS "t17" ON "t15"."movie_id" = "t17"."movie_id" AND "t15"."movie_id0" = "t17"."movie_id" AND "t15"."id1" = "t17"."info_type_id") AS "t18"
INNER JOIN (SELECT "movie_id", "info_type_id", "info"
FROM movie_info_idx) AS "t19" ON "t18"."movie_id" = "t19"."movie_id" AND "t18"."movie_id1" = "t19"."movie_id" AND "t18"."movie_id0" = "t19"."movie_id" AND "t18"."id2" = "t19"."info_type_id") AS "t20"
INNER JOIN (SELECT "movie_id", "keyword_id"
FROM movie_keyword) AS "t21" ON "t20"."movie_id" = "t21"."movie_id" AND "t20"."movie_id1" = "t21"."movie_id" AND "t20"."movie_id2" = "t21"."movie_id" AND "t20"."movie_id0" = "t21"."movie_id" AND "t20"."id3" = "t21"."keyword_id") AS "t22"
INNER JOIN (SELECT "id", "name"
FROM name
WHERE "gender" = 'm') AS "t25" ON "t22"."person_id" = "t25"."id") AS "t26"
INNER JOIN (SELECT "id", "title"
FROM title
WHERE "production_year" > 2000 AND ("title" LIKE '%Freddy%' OR "title" LIKE '%Jason%' OR "title" LIKE 'Saw%')) AS "t29" ON "t26"."movie_id1" = "t29"."id" AND "t26"."movie_id2" = "t29"."id" AND "t26"."movie_id" = "t29"."id" AND "t26"."movie_id3" = "t29"."id" AND "t26"."movie_id0" = "t29"."id"
;
