SELECT MIN("t12"."title") AS "american_movie"
FROM (SELECT "t5"."movie_id", "t8"."movie_id" AS "movie_id0"
FROM (SELECT "t1"."id" AS "id0", "t4"."movie_id"
FROM (SELECT "id"
FROM company_type
WHERE "kind" = 'production companies') AS "t0"
CROSS JOIN 
(SELECT "id"
FROM info_type) AS "t1"
INNER JOIN (SELECT "movie_id", "company_type_id"
FROM movie_companies
WHERE "note" LIKE '%(USA)%' AND "note" NOT LIKE '%(TV)%') AS "t4" ON "t0"."id" = "t4"."company_type_id") AS "t5"
INNER JOIN (SELECT "movie_id", "info_type_id"
FROM movie_info
WHERE "info" IN ('American', 'Denish', 'Denmark', 'German', 'Germany', 'Norway', 'Norwegian', 'Sweden', 'Swedish', 'USA')) AS "t8" ON "t5"."movie_id" = "t8"."movie_id" AND "t5"."id0" = "t8"."info_type_id") AS "t9"
INNER JOIN (SELECT "id", "title"
FROM title
WHERE "production_year" > 1990) AS "t12" ON "t9"."movie_id0" = "t12"."id" AND "t9"."movie_id" = "t12"."id"
;
