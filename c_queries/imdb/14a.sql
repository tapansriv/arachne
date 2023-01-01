SELECT MIN("t16"."info2") AS "rating", MIN("t19"."title") AS "northern_dark_movie"
FROM (SELECT "t14"."id2", "t14"."movie_id", "t14"."movie_id0", "t14"."info2", "t15"."movie_id" AS "movie_id1"
FROM (SELECT "t11"."id1", "t11"."id2", "t11"."movie_id", "t13"."movie_id" AS "movie_id0", "t13"."info" AS "info2"
FROM (SELECT "t2"."id" AS "id0", "t5"."id" AS "id1", "t7"."id" AS "id2", "t10"."movie_id"
FROM (SELECT "id"
FROM info_type
WHERE "info" = 'countries') AS "t0"
CROSS JOIN 
(SELECT "id"
FROM info_type
WHERE "info" = 'rating') AS "t2"
CROSS JOIN 
(SELECT "id"
FROM keyword
WHERE "keyword" IN ('blood', 'murder', 'murder-in-title', 'violence')) AS "t5"
CROSS JOIN 
(SELECT "id"
FROM kind_type
WHERE "kind" = 'movie') AS "t7"
INNER JOIN (SELECT "movie_id", "info_type_id"
FROM movie_info
WHERE "info" IN ('American', 'Denish', 'Denmark', 'German', 'Germany', 'Norway', 'Norwegian', 'Sweden', 'Swedish', 'USA')) AS "t10" ON "t0"."id" = "t10"."info_type_id") AS "t11"
INNER JOIN (SELECT "movie_id", "info_type_id", "info"
FROM movie_info_idx
WHERE "info" < '8.5') AS "t13" ON "t11"."movie_id" = "t13"."movie_id" AND "t11"."id0" = "t13"."info_type_id") AS "t14"
INNER JOIN (SELECT "movie_id", "keyword_id"
FROM movie_keyword) AS "t15" ON "t14"."movie_id" = "t15"."movie_id" AND "t14"."movie_id0" = "t15"."movie_id" AND "t14"."id1" = "t15"."keyword_id") AS "t16"
INNER JOIN (SELECT "id", "title", "kind_id"
FROM title
WHERE "production_year" > 2010) AS "t19" ON "t16"."id2" = "t19"."kind_id" AND "t16"."movie_id" = "t19"."id" AND "t16"."movie_id1" = "t19"."id" AND "t16"."movie_id0" = "t19"."id"
;
