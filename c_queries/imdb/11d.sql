SELECT MIN("t13"."name") AS "from_company", MIN("t13"."note") AS "production_note", MIN("t16"."title") AS "movie_based_on_book"
FROM (SELECT "t11"."name", "t11"."movie_id", "t11"."note", "t11"."movie_id0", "t12"."movie_id" AS "movie_id1"
FROM (SELECT "t9"."name", "t9"."id2", "t9"."movie_id", "t9"."note", "t10"."movie_id" AS "movie_id0"
FROM (SELECT "t1"."name", "t6"."id" AS "id1", "t7"."id" AS "id2", "t8"."movie_id", "t8"."note"
FROM (SELECT "id", "name"
FROM company_name
WHERE "country_code" <> '[pl]') AS "t1"
CROSS JOIN 
(SELECT "id"
FROM company_type
WHERE "kind" <> 'production companies') AS "t3"
CROSS JOIN 
(SELECT "id"
FROM keyword
WHERE "keyword" IN ('based-on-novel', 'revenge', 'sequel')) AS "t6"
CROSS JOIN 
(SELECT "id"
FROM link_type) AS "t7"
INNER JOIN (SELECT "movie_id", "company_id", "company_type_id", "note"
FROM movie_companies) AS "t8" ON "t3"."id" = "t8"."company_type_id" AND "t1"."id" = "t8"."company_id") AS "t9"
INNER JOIN (SELECT "movie_id", "keyword_id"
FROM movie_keyword) AS "t10" ON "t9"."id1" = "t10"."keyword_id" AND "t9"."movie_id" = "t10"."movie_id") AS "t11"
INNER JOIN (SELECT "movie_id", "link_type_id"
FROM movie_link) AS "t12" ON "t11"."id2" = "t12"."link_type_id" AND "t11"."movie_id0" = "t12"."movie_id" AND "t11"."movie_id" = "t12"."movie_id") AS "t13"
INNER JOIN (SELECT "id", "title"
FROM title
WHERE "production_year" > 1950) AS "t16" ON "t13"."movie_id1" = "t16"."id" AND "t13"."movie_id0" = "t16"."id" AND "t13"."movie_id" = "t16"."id"
;
