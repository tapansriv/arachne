SELECT MIN("t7"."note") AS "production_note", MIN("t8"."title") AS "movie_title", MIN("t8"."production_year") AS "movie_year"
FROM (SELECT "t5"."movie_id", "t5"."note", "t6"."movie_id" AS "movie_id0"
FROM (SELECT "t2"."id" AS "id0", "t4"."movie_id", "t4"."note"
FROM (SELECT "id"
FROM company_type
WHERE "kind" = 'production companies') AS "t0"
CROSS JOIN 
(SELECT "id"
FROM info_type
WHERE "info" = 'top 250 rank') AS "t2"
INNER JOIN (SELECT "movie_id", "company_type_id", "note"
FROM movie_companies
WHERE ("note" LIKE '%(co-production)%' OR "note" LIKE '%(presents)%') AND "note" NOT LIKE '%(as Metro-Goldwyn-Mayer Pictures)%') AS "t4" ON "t0"."id" = "t4"."company_type_id") AS "t5"
INNER JOIN (SELECT "movie_id", "info_type_id"
FROM movie_info_idx) AS "t6" ON "t5"."movie_id" = "t6"."movie_id" AND "t5"."id0" = "t6"."info_type_id") AS "t7"
INNER JOIN (SELECT "id", "title", "production_year"
FROM title) AS "t8" ON "t7"."movie_id" = "t8"."id" AND "t7"."movie_id0" = "t8"."id"
;
