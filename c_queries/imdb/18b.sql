SELECT MIN("t0"."info1") AS "movie_budget", MIN("t0"."info2") AS "movie_votes", MIN("t3"."title") AS "movie_title"
FROM (SELECT "movie_id", "movie_id0", "info1", "movie_id1", "info2"
FROM (VALUES (NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)) AS "t" ("id", "person_id", "movie_id", "person_role_id", "note", "nr_order", "role_id", "id0", "info", "id1", "info0", "id2", "movie_id0", "info_type_id", "info1", "note0", "id3", "movie_id1", "info_type_id0", "info2", "note1", "id4", "name", "imdb_index", "imdb_id", "gender", "name_pcode_cf", "name_pcode_nf", "surname_pcode", "md5sum")
WHERE 1 = 0) AS "t0"
INNER JOIN (SELECT "id", "title"
FROM title
WHERE "production_year" >= 2008 AND "production_year" <= 2014) AS "t3" ON "t0"."movie_id0" = "t3"."id" AND "t0"."movie_id1" = "t3"."id" AND "t0"."movie_id" = "t3"."id"
;
