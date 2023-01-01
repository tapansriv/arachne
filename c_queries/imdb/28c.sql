SELECT MIN("t31"."name") AS "movie_company", MIN("t31"."info2") AS "rating", MIN("t34"."title") AS "complete_euro_dark_movie"
FROM (SELECT "t29"."movie_id", "t29"."name", "t29"."id7", "t29"."movie_id0", "t29"."movie_id1", "t29"."movie_id2", "t29"."info2", "t30"."movie_id" AS "movie_id3"
FROM (SELECT "t26"."movie_id", "t26"."name", "t26"."id6", "t26"."id7", "t26"."movie_id0", "t26"."movie_id1", "t28"."movie_id" AS "movie_id2", "t28"."info" AS "info2"
FROM (SELECT "t22"."movie_id", "t22"."name", "t22"."id5", "t22"."id6", "t22"."id7", "t22"."movie_id0", "t25"."movie_id" AS "movie_id1"
FROM (SELECT "t5"."movie_id", "t8"."name", "t11"."id" AS "id4", "t13"."id" AS "id5", "t16"."id" AS "id6", "t18"."id" AS "id7", "t21"."movie_id" AS "movie_id0"
FROM (SELECT "t2"."movie_id"
FROM (SELECT "t"."movie_id", "t"."status_id"
FROM (SELECT "movie_id", "subject_id", "status_id"
FROM complete_cast) AS "t"
INNER JOIN (SELECT "id"
FROM comp_cast_type
WHERE "kind" = 'cast') AS "t1" ON "t"."subject_id" = "t1"."id") AS "t2"
INNER JOIN (SELECT "id"
FROM comp_cast_type
WHERE "kind" = 'complete') AS "t4" ON "t2"."status_id" = "t4"."id") AS "t5"
CROSS JOIN 
(SELECT "id", "name"
FROM company_name
WHERE "country_code" <> '[us]') AS "t8"
CROSS JOIN 
(SELECT "id"
FROM company_type) AS "t9"
CROSS JOIN 
(SELECT "id"
FROM info_type
WHERE "info" = 'countries') AS "t11"
CROSS JOIN 
(SELECT "id"
FROM info_type
WHERE "info" = 'rating') AS "t13"
CROSS JOIN 
(SELECT "id"
FROM keyword
WHERE "keyword" IN ('blood', 'murder', 'murder-in-title', 'violence')) AS "t16"
CROSS JOIN 
(SELECT "id"
FROM kind_type
WHERE "kind" IN ('episode', 'movie')) AS "t18"
INNER JOIN (SELECT "movie_id", "company_id", "company_type_id"
FROM movie_companies
WHERE "note" LIKE '%(200%)%' AND "note" NOT LIKE '%(USA)%') AS "t21" ON "t5"."movie_id" = "t21"."movie_id" AND "t9"."id" = "t21"."company_type_id" AND "t8"."id" = "t21"."company_id") AS "t22"
INNER JOIN (SELECT "movie_id", "info_type_id"
FROM movie_info
WHERE "info" IN ('American', 'Danish', 'Denmark', 'German', 'Germany', 'Norway', 'Norwegian', 'Sweden', 'Swedish', 'USA')) AS "t25" ON "t22"."movie_id0" = "t25"."movie_id" AND "t22"."movie_id" = "t25"."movie_id" AND "t22"."id4" = "t25"."info_type_id") AS "t26"
INNER JOIN (SELECT "movie_id", "info_type_id", "info"
FROM movie_info_idx
WHERE "info" < '8.5') AS "t28" ON "t26"."movie_id1" = "t28"."movie_id" AND "t26"."movie_id0" = "t28"."movie_id" AND "t26"."movie_id" = "t28"."movie_id" AND "t26"."id5" = "t28"."info_type_id") AS "t29"
INNER JOIN (SELECT "movie_id", "keyword_id"
FROM movie_keyword) AS "t30" ON "t29"."movie_id1" = "t30"."movie_id" AND "t29"."movie_id2" = "t30"."movie_id" AND "t29"."movie_id0" = "t30"."movie_id" AND "t29"."movie_id" = "t30"."movie_id" AND "t29"."id6" = "t30"."keyword_id") AS "t31"
INNER JOIN (SELECT "id", "title", "kind_id"
FROM title
WHERE "production_year" > 2005) AS "t34" ON "t31"."id7" = "t34"."kind_id" AND ("t31"."movie_id1" = "t34"."id" AND "t31"."movie_id3" = "t34"."id") AND ("t31"."movie_id2" = "t34"."id" AND ("t31"."movie_id0" = "t34"."id" AND "t31"."movie_id" = "t34"."id"))
;
