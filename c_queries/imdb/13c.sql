SELECT MIN("t15"."name") AS "producing_company", MIN("t15"."info2") AS "rating", MIN("t17"."title") AS "movie_about_winning"
FROM (SELECT "t13"."name", "t13"."id3", "t13"."movie_id", "t13"."movie_id0", "t14"."movie_id" AS "movie_id1", "t14"."info" AS "info2"
FROM (SELECT "t11"."name", "t11"."id1", "t11"."id3", "t11"."movie_id", "t12"."movie_id" AS "movie_id0"
FROM (SELECT "t1"."name", "t5"."id" AS "id1", "t7"."id" AS "id2", "t9"."id" AS "id3", "t10"."movie_id"
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
WHERE "info" = 'rating') AS "t5"
CROSS JOIN 
(SELECT "id"
FROM info_type
WHERE "info" = 'release dates') AS "t7"
CROSS JOIN 
(SELECT "id"
FROM kind_type
WHERE "kind" = 'movie') AS "t9"
INNER JOIN (SELECT "movie_id", "company_id", "company_type_id"
FROM movie_companies) AS "t10" ON "t1"."id" = "t10"."company_id" AND "t3"."id" = "t10"."company_type_id") AS "t11"
INNER JOIN (SELECT "movie_id", "info_type_id"
FROM movie_info) AS "t12" ON "t11"."id2" = "t12"."info_type_id" AND "t11"."movie_id" = "t12"."movie_id") AS "t13"
INNER JOIN (SELECT "movie_id", "info_type_id", "info"
FROM movie_info_idx) AS "t14" ON "t13"."id1" = "t14"."info_type_id" AND "t13"."movie_id0" = "t14"."movie_id" AND "t13"."movie_id" = "t14"."movie_id") AS "t15"
INNER JOIN (SELECT "id", "title", "kind_id"
FROM title
WHERE "title" <> '' AND ("title" LIKE 'Champion%' OR "title" LIKE 'Loser%')) AS "t17" ON "t15"."movie_id0" = "t17"."id" AND "t15"."id3" = "t17"."kind_id" AND "t15"."movie_id" = "t17"."id" AND "t15"."movie_id1" = "t17"."id"
;
