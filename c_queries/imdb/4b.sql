SELECT MIN("t8"."info0") AS "rating", MIN("t11"."title") AS "movie_title"
FROM (SELECT "t6"."movie_id", "t6"."info0", "t7"."movie_id" AS "movie_id0"
FROM (SELECT "t3"."id" AS "id0", "t5"."movie_id", "t5"."info" AS "info0"
FROM (SELECT "id"
FROM info_type
WHERE "info" = 'rating') AS "t0"
CROSS JOIN 
(SELECT "id"
FROM keyword
WHERE "keyword" LIKE '%sequel%') AS "t3"
INNER JOIN (SELECT "movie_id", "info_type_id", "info"
FROM movie_info_idx
WHERE "info" > '9.0') AS "t5" ON "t0"."id" = "t5"."info_type_id") AS "t6"
INNER JOIN (SELECT "movie_id", "keyword_id"
FROM movie_keyword) AS "t7" ON "t6"."movie_id" = "t7"."movie_id" AND "t6"."id0" = "t7"."keyword_id") AS "t8"
INNER JOIN (SELECT "id", "title"
FROM title
WHERE "production_year" > 2010) AS "t11" ON "t8"."movie_id" = "t11"."id" AND "t8"."movie_id0" = "t11"."id"
;
