SELECT MIN("t16"."name") AS "movie_company", MIN("t16"."info2") AS "rating", MIN("t19"."title") AS "mainstream_movie"
FROM (SELECT "t13"."name", "t13"."movie_id", "t13"."movie_id0", "t15"."movie_id" AS "movie_id1", "t15"."info" AS "info2"
FROM (SELECT "t9"."name", "t9"."id2", "t9"."movie_id", "t12"."movie_id" AS "movie_id0"
FROM (SELECT "t1"."name", "t5"."id" AS "id1", "t7"."id" AS "id2", "t8"."movie_id"
FROM (SELECT "id", "name"
FROM company_name
WHERE "country_code" = '[us]') AS "t1"
CROSS JOIN 
(SELECT "id"
FROM company_type
WHERE "kind" = 'production companies') AS "t3"
CROSS JOIN 
(SELECT "id"
FROM info_type
WHERE "info" = 'genres') AS "t5"
CROSS JOIN 
(SELECT "id"
FROM info_type
WHERE "info" = 'rating') AS "t7"
INNER JOIN (SELECT "movie_id", "company_id", "company_type_id"
FROM movie_companies) AS "t8" ON "t3"."id" = "t8"."company_type_id" AND "t1"."id" = "t8"."company_id") AS "t9"
INNER JOIN (SELECT "movie_id", "info_type_id"
FROM movie_info
WHERE "info" IN ('Drama', 'Family', 'Horror', 'Western')) AS "t12" ON "t9"."id1" = "t12"."info_type_id" AND "t9"."movie_id" = "t12"."movie_id") AS "t13"
INNER JOIN (SELECT "movie_id", "info_type_id", "info"
FROM movie_info_idx
WHERE "info" > '7.0') AS "t15" ON "t13"."id2" = "t15"."info_type_id" AND "t13"."movie_id" = "t15"."movie_id" AND "t13"."movie_id0" = "t15"."movie_id") AS "t16"
INNER JOIN (SELECT "id", "title"
FROM title
WHERE "production_year" >= 2000 AND "production_year" <= 2010) AS "t19" ON "t16"."movie_id0" = "t19"."id" AND "t16"."movie_id1" = "t19"."id" AND "t16"."movie_id" = "t19"."id"
;
