SELECT MIN("t16"."name") AS "acress_pseudonym", MIN("t19"."title") AS "japanese_anime_movie"
FROM (SELECT "t13"."name", "t13"."movie_id", "t13"."movie_id0"
FROM (SELECT "t9"."name", "t9"."movie_id", "t9"."role_id", "t9"."movie_id0"
FROM (SELECT "t"."person_id", "t"."name", "t2"."person_id" AS "person_id0", "t2"."movie_id", "t2"."role_id", "t8"."movie_id" AS "movie_id0"
FROM (SELECT "person_id", "name"
FROM aka_name) AS "t"
INNER JOIN (SELECT "person_id", "movie_id", "role_id"
FROM cast_info
WHERE "note" = '(voice: English version)') AS "t2" ON "t"."person_id" = "t2"."person_id"
CROSS JOIN 
(SELECT "id"
FROM company_name
WHERE "country_code" = '[jp]') AS "t5"
INNER JOIN (SELECT "movie_id", "company_id"
FROM movie_companies
WHERE "note" LIKE '%(Japan)%' AND ("note" LIKE '%(2006)%' OR "note" LIKE '%(2007)%') AND "note" NOT LIKE '%(USA)%') AS "t8" ON "t5"."id" = "t8"."company_id" AND "t2"."movie_id" = "t8"."movie_id") AS "t9"
INNER JOIN (SELECT "id"
FROM name
WHERE "name" LIKE '%Yo%' AND "name" NOT LIKE '%Yu%') AS "t12" ON "t9"."person_id" = "t12"."id" AND "t9"."person_id0" = "t12"."id") AS "t13"
INNER JOIN (SELECT "id"
FROM role_type
WHERE "role" = 'actress') AS "t15" ON "t13"."role_id" = "t15"."id") AS "t16"
INNER JOIN (SELECT "id", "title"
FROM title
WHERE "production_year" >= 2006 AND "production_year" <= 2007 AND ("title" LIKE 'One Piece%' OR "title" LIKE 'Dragon Ball Z%')) AS "t19" ON "t16"."movie_id" = "t19"."id" AND "t16"."movie_id0" = "t19"."id"
;
