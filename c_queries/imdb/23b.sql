SELECT MIN("t21"."kind1") AS "movie_kind", MIN("t24"."title") AS "complete_nerdy_internet_movie"
FROM (SELECT "t19"."movie_id", "t19"."id5", "t19"."kind1", "t19"."movie_id0", "t19"."movie_id1", "t20"."movie_id" AS "movie_id2"
FROM (SELECT "t15"."movie_id", "t15"."id4", "t15"."id5", "t15"."kind1", "t15"."movie_id0", "t18"."movie_id" AS "movie_id1"
FROM (SELECT "t2"."movie_id", "t8"."id" AS "id3", "t11"."id" AS "id4", "t13"."id" AS "id5", "t13"."kind" AS "kind1", "t14"."movie_id" AS "movie_id0"
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
FROM keyword
WHERE "keyword" IN ('alienation', 'dignity', 'loner', 'nerd')) AS "t11"
CROSS JOIN 
(SELECT *
FROM kind_type
WHERE "kind" = 'movie') AS "t13"
INNER JOIN (SELECT "movie_id", "company_id", "company_type_id"
FROM movie_companies) AS "t14" ON "t2"."movie_id" = "t14"."movie_id" AND "t5"."id" = "t14"."company_id" AND "t6"."id" = "t14"."company_type_id") AS "t15"
INNER JOIN (SELECT "movie_id", "info_type_id"
FROM movie_info
WHERE "note" LIKE '%internet%' AND "info" LIKE 'USA:% 200%') AS "t18" ON "t15"."movie_id0" = "t18"."movie_id" AND "t15"."movie_id" = "t18"."movie_id" AND "t15"."id3" = "t18"."info_type_id") AS "t19"
INNER JOIN (SELECT "movie_id", "keyword_id"
FROM movie_keyword) AS "t20" ON "t19"."movie_id1" = "t20"."movie_id" AND "t19"."movie_id0" = "t20"."movie_id" AND "t19"."movie_id" = "t20"."movie_id" AND "t19"."id4" = "t20"."keyword_id") AS "t21"
INNER JOIN (SELECT "id", "title", "kind_id"
FROM title
WHERE "production_year" > 2000) AS "t24" ON "t21"."id5" = "t24"."kind_id" AND "t21"."movie_id1" = "t24"."id" AND "t21"."movie_id2" = "t24"."id" AND "t21"."movie_id0" = "t24"."id" AND "t21"."movie_id" = "t24"."id"
;
