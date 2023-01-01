SELECT MIN("t25"."name") AS "first_company", MIN("t25"."name0") AS "second_company", MIN("t25"."info1") AS "first_rating", MIN("t25"."info2") AS "second_rating", MIN("t25"."title") AS "first_movie", MIN("t28"."title") AS "second_movie"
FROM (SELECT "t23"."name", "t23"."name0", "t23"."id4", "t23"."movie_id0", "t23"."info1", "t23"."movie_id2", "t23"."info2", "t23"."linked_movie_id", "t24"."title"
FROM (SELECT "t21"."name", "t21"."name0", "t21"."id3", "t21"."id4", "t21"."movie_id", "t21"."movie_id0", "t21"."movie_id1", "t21"."info1", "t21"."movie_id2", "t21"."info2", "t22"."movie_id" AS "movie_id3", "t22"."linked_movie_id"
FROM (SELECT "t18"."name", "t18"."name0", "t18"."id3", "t18"."id4", "t18"."id5", "t18"."movie_id", "t18"."movie_id0", "t18"."movie_id1", "t18"."info1", "t20"."movie_id" AS "movie_id2", "t20"."info" AS "info2"
FROM (SELECT "t16"."name", "t16"."name0", "t16"."id2", "t16"."id3", "t16"."id4", "t16"."id5", "t16"."movie_id", "t16"."movie_id0", "t17"."movie_id" AS "movie_id1", "t17"."info" AS "info1"
FROM (SELECT "t14"."name", "t14"."name0", "t14"."id1", "t14"."id2", "t14"."id3", "t14"."id4", "t14"."id5", "t14"."movie_id", "t15"."movie_id" AS "movie_id0"
FROM (SELECT "t1"."name", "t2"."id" AS "id0", "t2"."name" AS "name0", "t4"."id" AS "id1", "t6"."id" AS "id2", "t8"."id" AS "id3", "t10"."id" AS "id4", "t12"."id" AS "id5", "t13"."movie_id"
FROM (SELECT "id", "name"
FROM company_name
WHERE "country_code" = '[nl]') AS "t1"
CROSS JOIN 
(SELECT "id", "name"
FROM company_name) AS "t2"
CROSS JOIN 
(SELECT "id"
FROM info_type
WHERE "info" = 'rating') AS "t4"
CROSS JOIN 
(SELECT "id"
FROM info_type
WHERE "info" = 'rating') AS "t6"
CROSS JOIN 
(SELECT "id"
FROM kind_type
WHERE "kind" = 'tv series') AS "t8"
CROSS JOIN 
(SELECT "id"
FROM kind_type
WHERE "kind" = 'tv series') AS "t10"
CROSS JOIN 
(SELECT "id"
FROM link_type
WHERE "link" LIKE '%follow%') AS "t12"
INNER JOIN (SELECT "movie_id", "company_id"
FROM movie_companies) AS "t13" ON "t1"."id" = "t13"."company_id") AS "t14"
INNER JOIN (SELECT "movie_id", "company_id"
FROM movie_companies) AS "t15" ON "t14"."id0" = "t15"."company_id") AS "t16"
INNER JOIN (SELECT "movie_id", "info_type_id", "info"
FROM movie_info_idx) AS "t17" ON "t16"."id1" = "t17"."info_type_id" AND "t16"."movie_id" = "t17"."movie_id") AS "t18"
INNER JOIN (SELECT "movie_id", "info_type_id", "info"
FROM movie_info_idx
WHERE "info" < '3.0') AS "t20" ON "t18"."id2" = "t20"."info_type_id" AND "t18"."movie_id0" = "t20"."movie_id") AS "t21"
INNER JOIN (SELECT "movie_id", "linked_movie_id", "link_type_id"
FROM movie_link) AS "t22" ON "t21"."id5" = "t22"."link_type_id" AND "t21"."movie_id1" = "t22"."movie_id" AND "t21"."movie_id" = "t22"."movie_id" AND "t21"."movie_id2" = "t22"."linked_movie_id" AND "t21"."movie_id0" = "t22"."linked_movie_id") AS "t23"
INNER JOIN (SELECT "id", "title", "kind_id"
FROM title) AS "t24" ON "t23"."movie_id3" = "t24"."id" AND "t23"."movie_id1" = "t24"."id" AND "t23"."id3" = "t24"."kind_id" AND "t23"."movie_id" = "t24"."id") AS "t25"
INNER JOIN (SELECT "id", "title", "kind_id"
FROM title
WHERE "production_year" = 2007) AS "t28" ON "t25"."linked_movie_id" = "t28"."id" AND "t25"."movie_id2" = "t28"."id" AND "t25"."id4" = "t28"."kind_id" AND "t25"."movie_id0" = "t28"."id"
;
