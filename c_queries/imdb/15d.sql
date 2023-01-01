SELECT MIN("t14"."title") AS "aka_title", MIN("t17"."title") AS "internet_movie_title"
FROM (SELECT "t12"."movie_id", "t12"."title", "t12"."movie_id0", "t12"."movie_id1", "t13"."movie_id" AS "movie_id2"
FROM (SELECT "t8"."movie_id", "t8"."title", "t8"."id3", "t8"."movie_id0", "t11"."movie_id" AS "movie_id1"
FROM (SELECT "t"."movie_id", "t"."title", "t5"."id" AS "id2", "t6"."id" AS "id3", "t7"."movie_id" AS "movie_id0"
FROM (SELECT "movie_id", "title"
FROM aka_title) AS "t"
CROSS JOIN 
(SELECT "id"
FROM company_name
WHERE "country_code" = '[us]') AS "t2"
CROSS JOIN 
(SELECT "id"
FROM company_type) AS "t3"
CROSS JOIN 
(SELECT "id"
FROM info_type
WHERE "info" = 'release dates') AS "t5"
CROSS JOIN 
(SELECT "id"
FROM keyword) AS "t6"
INNER JOIN (SELECT "movie_id", "company_id", "company_type_id"
FROM movie_companies) AS "t7" ON "t"."movie_id" = "t7"."movie_id" AND "t2"."id" = "t7"."company_id" AND "t3"."id" = "t7"."company_type_id") AS "t8"
INNER JOIN (SELECT "movie_id", "info_type_id"
FROM movie_info
WHERE "note" LIKE '%internet%') AS "t11" ON "t8"."movie_id0" = "t11"."movie_id" AND "t8"."movie_id" = "t11"."movie_id" AND "t8"."id2" = "t11"."info_type_id") AS "t12"
INNER JOIN (SELECT "movie_id", "keyword_id"
FROM movie_keyword) AS "t13" ON "t12"."movie_id1" = "t13"."movie_id" AND "t12"."movie_id0" = "t13"."movie_id" AND "t12"."movie_id" = "t13"."movie_id" AND "t12"."id3" = "t13"."keyword_id") AS "t14"
INNER JOIN (SELECT "id", "title"
FROM title
WHERE "production_year" > 1990) AS "t17" ON "t14"."movie_id" = "t17"."id" AND "t14"."movie_id1" = "t17"."id" AND "t14"."movie_id2" = "t17"."id" AND "t14"."movie_id0" = "t17"."id"
;
