SELECT MIN("t24"."name") AS "movie_company", MIN("t24"."info2") AS "rating", MIN("t27"."title") AS "western_violent_movie"
FROM (SELECT "t22"."name", "t22"."id4", "t22"."movie_id", "t22"."movie_id0", "t22"."movie_id1", "t22"."info2", "t23"."movie_id" AS "movie_id2"
FROM (SELECT "t19"."name", "t19"."id3", "t19"."id4", "t19"."movie_id", "t19"."movie_id0", "t21"."movie_id" AS "movie_id1", "t21"."info" AS "info2"
FROM (SELECT "t15"."name", "t15"."id2", "t15"."id3", "t15"."id4", "t15"."movie_id", "t18"."movie_id" AS "movie_id0"
FROM (SELECT "t1"."name", "t4"."id" AS "id1", "t6"."id" AS "id2", "t9"."id" AS "id3", "t11"."id" AS "id4", "t14"."movie_id"
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
FROM movie_companies
WHERE "note" LIKE '%(200%)%' AND "note" NOT LIKE '%(USA)%') AS "t14" ON "t2"."id" = "t14"."company_type_id" AND "t1"."id" = "t14"."company_id") AS "t15"
INNER JOIN (SELECT "movie_id", "info_type_id"
FROM movie_info
WHERE "info" IN ('American', 'German', 'Germany', 'USA')) AS "t18" ON "t15"."movie_id" = "t18"."movie_id" AND "t15"."id1" = "t18"."info_type_id") AS "t19"
INNER JOIN (SELECT "movie_id", "info_type_id", "info"
FROM movie_info_idx
WHERE "info" < '7.0') AS "t21" ON "t19"."movie_id0" = "t21"."movie_id" AND "t19"."movie_id" = "t21"."movie_id" AND "t19"."id2" = "t21"."info_type_id") AS "t22"
INNER JOIN (SELECT "movie_id", "keyword_id"
FROM movie_keyword) AS "t23" ON "t22"."movie_id0" = "t23"."movie_id" AND "t22"."movie_id1" = "t23"."movie_id" AND "t22"."movie_id" = "t23"."movie_id" AND "t22"."id3" = "t23"."keyword_id") AS "t24"
INNER JOIN (SELECT "id", "title", "kind_id"
FROM title
WHERE "production_year" > 2008) AS "t27" ON "t24"."id4" = "t27"."kind_id" AND "t24"."movie_id0" = "t27"."id" AND "t24"."movie_id2" = "t27"."id" AND "t24"."movie_id1" = "t27"."id" AND "t24"."movie_id" = "t27"."id"
;
