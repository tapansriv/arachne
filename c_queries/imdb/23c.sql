SELECT MIN("t19"."kind1") AS "movie_kind", MIN("t22"."title") AS "complete_us_internet_movie"
FROM (SELECT "t17"."movie_id", "t17"."id5", "t17"."kind1", "t17"."movie_id0", "t17"."movie_id1", "t18"."movie_id" AS "movie_id2"
FROM (SELECT "t13"."movie_id", "t13"."id4", "t13"."id5", "t13"."kind1", "t13"."movie_id0", "t16"."movie_id" AS "movie_id1"
FROM (SELECT "t2"."movie_id", "t8"."id" AS "id3", "t9"."id" AS "id4", "t11"."id" AS "id5", "t11"."kind" AS "kind1", "t12"."movie_id" AS "movie_id0"
FROM (SELECT "t"."movie_id"
FROM (SELECT "movie_id", "status_id"
FROM complete_cast) AS "t"
INNER JOIN (SELECT "id"
FROM comp_cast_type
WHERE "kind" = 'complete+verified') AS "t1" ON "t"."status_id" = "t1"."id") AS "t2"
CROSS JOIN 
(SELECT "id"
FROM company_name
WHERE "country_code" = '[us]') AS "t5"
CROSS JOIN 
(SELECT "id"
FROM company_type) AS "t6"
CROSS JOIN 
(SELECT "id"
FROM info_type
WHERE "info" = 'release dates') AS "t8"
CROSS JOIN 
(SELECT "id"
FROM keyword) AS "t9"
CROSS JOIN 
(SELECT *
FROM kind_type
WHERE "kind" IN ('movie', 'tv movie', 'video game', 'video movie')) AS "t11"
INNER JOIN (SELECT "movie_id", "company_id", "company_type_id"
FROM movie_companies) AS "t12" ON "t2"."movie_id" = "t12"."movie_id" AND "t5"."id" = "t12"."company_id" AND "t6"."id" = "t12"."company_type_id") AS "t13"
INNER JOIN (SELECT "movie_id", "info_type_id"
FROM movie_info
WHERE "note" LIKE '%internet%' AND ("info" LIKE 'USA:% 199%' OR "info" LIKE 'USA:% 200%')) AS "t16" ON "t13"."movie_id0" = "t16"."movie_id" AND "t13"."movie_id" = "t16"."movie_id" AND "t13"."id3" = "t16"."info_type_id") AS "t17"
INNER JOIN (SELECT "movie_id", "keyword_id"
FROM movie_keyword) AS "t18" ON "t17"."movie_id1" = "t18"."movie_id" AND "t17"."movie_id0" = "t18"."movie_id" AND "t17"."movie_id" = "t18"."movie_id" AND "t17"."id4" = "t18"."keyword_id") AS "t19"
INNER JOIN (SELECT "id", "title", "kind_id"
FROM title
WHERE "production_year" > 1990) AS "t22" ON "t19"."id5" = "t22"."kind_id" AND "t19"."movie_id1" = "t22"."id" AND "t19"."movie_id2" = "t22"."id" AND "t19"."movie_id0" = "t22"."id" AND "t19"."movie_id" = "t22"."id"
;
