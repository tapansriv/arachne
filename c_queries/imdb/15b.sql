SELECT MIN("t16"."info0") AS "release_date", MIN("t19"."title") AS "youtube_movie"
FROM (SELECT "t14"."movie_id", "t14"."movie_id0", "t14"."movie_id1", "t14"."info0", "t15"."movie_id" AS "movie_id2"
FROM (SELECT "t10"."movie_id", "t10"."id3", "t10"."movie_id0", "t13"."movie_id" AS "movie_id1", "t13"."info" AS "info0"
FROM (SELECT "t"."movie_id", "t5"."id" AS "id2", "t6"."id" AS "id3", "t9"."movie_id" AS "movie_id0"
FROM (SELECT "movie_id"
FROM aka_title) AS "t"
CROSS JOIN 
(SELECT "id"
FROM company_name
WHERE "country_code" = '[us]' AND "name" = 'YouTube') AS "t2"
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
FROM movie_companies
WHERE "note" LIKE '%(200%)%' AND "note" LIKE '%(worldwide)%') AS "t9" ON "t"."movie_id" = "t9"."movie_id" AND "t2"."id" = "t9"."company_id" AND "t3"."id" = "t9"."company_type_id") AS "t10"
INNER JOIN (SELECT "movie_id", "info_type_id", "info"
FROM movie_info
WHERE "note" LIKE '%internet%' AND "info" LIKE 'USA:% 200%') AS "t13" ON "t10"."movie_id0" = "t13"."movie_id" AND "t10"."movie_id" = "t13"."movie_id" AND "t10"."id2" = "t13"."info_type_id") AS "t14"
INNER JOIN (SELECT "movie_id", "keyword_id"
FROM movie_keyword) AS "t15" ON "t14"."movie_id1" = "t15"."movie_id" AND "t14"."movie_id0" = "t15"."movie_id" AND "t14"."movie_id" = "t15"."movie_id" AND "t14"."id3" = "t15"."keyword_id") AS "t16"
INNER JOIN (SELECT "id", "title"
FROM title
WHERE "production_year" >= 2005 AND "production_year" <= 2010) AS "t19" ON "t16"."movie_id" = "t19"."id" AND "t16"."movie_id1" = "t19"."id" AND "t16"."movie_id2" = "t19"."id" AND "t16"."movie_id0" = "t19"."id"
;
