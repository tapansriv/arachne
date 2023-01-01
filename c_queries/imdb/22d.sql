SELECT MIN("t22"."name") AS "movie_company", MIN("t22"."info2") AS "rating", MIN("t25"."title") AS "western_violent_movie"
FROM (SELECT "t20"."name", "t20"."id4", "t20"."movie_id", "t20"."movie_id0", "t20"."movie_id1", "t20"."info2", "t21"."movie_id" AS "movie_id2"
FROM (SELECT "t17"."name", "t17"."id3", "t17"."id4", "t17"."movie_id", "t17"."movie_id0", "t19"."movie_id" AS "movie_id1", "t19"."info" AS "info2"
FROM (SELECT "t13"."name", "t13"."id2", "t13"."id3", "t13"."id4", "t13"."movie_id", "t16"."movie_id" AS "movie_id0"
FROM (SELECT "t1"."name", "t4"."id" AS "id1", "t6"."id" AS "id2", "t9"."id" AS "id3", "t11"."id" AS "id4", "t12"."movie_id"
FROM (SELECT "id", "name"
FROM company_name
WHERE "country_code" <> '[us]') AS "t1"
CROSS JOIN 
(SELECT "id"
FROM company_type) AS "t2"
CROSS JOIN 
(SELECT "id"
FROM info_type
WHERE "info" = 'countries') AS "t4"
CROSS JOIN 
(SELECT "id"
FROM info_type
WHERE "info" = 'rating') AS "t6"
CROSS JOIN 
(SELECT "id"
FROM keyword
WHERE "keyword" IN ('blood', 'murder', 'murder-in-title', 'violence')) AS "t9"
CROSS JOIN 
(SELECT "id"
FROM kind_type
WHERE "kind" IN ('episode', 'movie')) AS "t11"
INNER JOIN (SELECT "movie_id", "company_id", "company_type_id"
FROM movie_companies) AS "t12" ON "t2"."id" = "t12"."company_type_id" AND "t1"."id" = "t12"."company_id") AS "t13"
INNER JOIN (SELECT "movie_id", "info_type_id"
FROM movie_info
WHERE "info" IN ('American', 'Danish', 'Denmark', 'German', 'Germany', 'Norway', 'Norwegian', 'Sweden', 'Swedish', 'USA')) AS "t16" ON "t13"."movie_id" = "t16"."movie_id" AND "t13"."id1" = "t16"."info_type_id") AS "t17"
INNER JOIN (SELECT "movie_id", "info_type_id", "info"
FROM movie_info_idx
WHERE "info" < '8.5') AS "t19" ON "t17"."movie_id0" = "t19"."movie_id" AND "t17"."movie_id" = "t19"."movie_id" AND "t17"."id2" = "t19"."info_type_id") AS "t20"
INNER JOIN (SELECT "movie_id", "keyword_id"
FROM movie_keyword) AS "t21" ON "t20"."movie_id0" = "t21"."movie_id" AND "t20"."movie_id1" = "t21"."movie_id" AND "t20"."movie_id" = "t21"."movie_id" AND "t20"."id3" = "t21"."keyword_id") AS "t22"
INNER JOIN (SELECT "id", "title", "kind_id"
FROM title
WHERE "production_year" > 2005) AS "t25" ON "t22"."id4" = "t25"."kind_id" AND "t22"."movie_id0" = "t25"."id" AND "t22"."movie_id2" = "t25"."id" AND "t22"."movie_id1" = "t25"."id" AND "t22"."movie_id" = "t25"."id"
;
