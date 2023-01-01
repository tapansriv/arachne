SELECT MIN("t0"."name") AS "company_name", MIN("t0"."link") AS "link_type", MIN("t3"."title") AS "western_follow_up"
FROM (SELECT "name", "link", "movie_id", "movie_id0", "movie_id1", "movie_id2"
FROM (VALUES (NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)) AS "t" ("id", "name", "country_code", "imdb_id", "name_pcode_nf", "name_pcode_sf", "md5sum", "id0", "kind", "id1", "keyword", "phonetic_code", "id2", "link", "id3", "movie_id", "company_id", "company_type_id", "note", "id4", "movie_id0", "info_type_id", "info", "note0", "id5", "movie_id1", "keyword_id", "id6", "movie_id2", "linked_movie_id", "link_type_id")
WHERE 1 = 0) AS "t0"
INNER JOIN (SELECT "id", "title"
FROM title
WHERE "production_year" >= 1950 AND "production_year" <= 2000) AS "t3" ON "t0"."movie_id2" = "t3"."id" AND "t0"."movie_id1" = "t3"."id" AND "t0"."movie_id" = "t3"."id" AND "t0"."movie_id0" = "t3"."id"
;
