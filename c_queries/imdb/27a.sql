SELECT MIN("t0"."name") AS "producing_company", MIN("t0"."link") AS "link_type", MIN("t3"."title") AS "complete_western_sequel"
FROM (SELECT "movie_id", "name", "link", "movie_id0", "movie_id1", "movie_id2", "movie_id3"
FROM (VALUES (NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)) AS "t" ("id", "movie_id", "subject_id", "status_id", "id0", "kind", "id1", "kind0", "id2", "name", "country_code", "imdb_id", "name_pcode_nf", "name_pcode_sf", "md5sum", "id3", "kind1", "id4", "keyword", "phonetic_code", "id5", "link", "id6", "movie_id0", "company_id", "company_type_id", "note", "id7", "movie_id1", "info_type_id", "info", "note0", "id8", "movie_id2", "keyword_id", "id9", "movie_id3", "linked_movie_id", "link_type_id")
WHERE 1 = 0) AS "t0"
INNER JOIN (SELECT "id", "title"
FROM title
WHERE "production_year" >= 1950 AND "production_year" <= 2000) AS "t3" ON "t0"."movie_id3" = "t3"."id" AND "t0"."movie_id2" = "t3"."id" AND "t0"."movie_id0" = "t3"."id" AND "t0"."movie_id1" = "t3"."id" AND "t0"."movie_id" = "t3"."id"
;
