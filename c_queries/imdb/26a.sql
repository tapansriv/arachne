SELECT MIN("t23"."name") AS "character_name", MIN("t23"."info0") AS "rating", MIN("t23"."name0") AS "playing_actor", MIN("t26"."title") AS "complete_hero_movie"
FROM (SELECT "t21"."movie_id", "t21"."name", "t21"."movie_id0", "t21"."id6", "t21"."movie_id1", "t21"."info0", "t21"."movie_id2", "t22"."name" AS "name0"
FROM (SELECT "t19"."movie_id", "t19"."name", "t19"."person_id", "t19"."movie_id0", "t19"."id6", "t19"."movie_id1", "t19"."info0", "t20"."movie_id" AS "movie_id2"
FROM (SELECT "t9"."movie_id", "t9"."name", "t9"."person_id", "t9"."movie_id0", "t14"."id" AS "id5", "t16"."id" AS "id6", "t18"."movie_id" AS "movie_id1", "t18"."info" AS "info0"
FROM (SELECT "t5"."movie_id", "t7"."name", "t8"."person_id", "t8"."movie_id" AS "movie_id0"
FROM (SELECT "t2"."movie_id"
FROM (SELECT "t"."movie_id", "t"."status_id"
FROM (SELECT "movie_id", "subject_id", "status_id"
FROM complete_cast) AS "t"
INNER JOIN (SELECT "id"
FROM comp_cast_type
WHERE "kind" = 'cast') AS "t1" ON "t"."subject_id" = "t1"."id") AS "t2"
INNER JOIN (SELECT "id"
FROM comp_cast_type
WHERE "kind" LIKE '%complete%') AS "t4" ON "t2"."status_id" = "t4"."id") AS "t5"
CROSS JOIN 
(SELECT "id", "name"
FROM char_name
WHERE "name" LIKE '%man%' OR "name" LIKE '%Man%') AS "t7"
INNER JOIN (SELECT "person_id", "movie_id", "person_role_id"
FROM cast_info) AS "t8" ON "t5"."movie_id" = "t8"."movie_id" AND "t7"."id" = "t8"."person_role_id") AS "t9"
CROSS JOIN 
(SELECT "id"
FROM info_type
WHERE "info" = 'rating') AS "t11"
CROSS JOIN 
(SELECT "id"
FROM keyword
WHERE "keyword" IN ('based-on-comic', 'claw', 'fight', 'laser', 'magnet', 'marvel-comics', 'superhero', 'tv-special', 'violence', 'web')) AS "t14"
CROSS JOIN 
(SELECT "id"
FROM kind_type
WHERE "kind" = 'movie') AS "t16"
INNER JOIN (SELECT "movie_id", "info_type_id", "info"
FROM movie_info_idx
WHERE "info" > '7.0') AS "t18" ON "t9"."movie_id0" = "t18"."movie_id" AND "t9"."movie_id" = "t18"."movie_id" AND "t11"."id" = "t18"."info_type_id") AS "t19"
INNER JOIN (SELECT "movie_id", "keyword_id"
FROM movie_keyword) AS "t20" ON "t19"."movie_id0" = "t20"."movie_id" AND "t19"."movie_id" = "t20"."movie_id" AND "t19"."movie_id1" = "t20"."movie_id" AND "t19"."id5" = "t20"."keyword_id") AS "t21"
INNER JOIN (SELECT "id", "name"
FROM name) AS "t22" ON "t21"."person_id" = "t22"."id") AS "t23"
INNER JOIN (SELECT "id", "title", "kind_id"
FROM title
WHERE "production_year" > 2000) AS "t26" ON "t23"."id6" = "t26"."kind_id" AND "t23"."movie_id2" = "t26"."id" AND "t23"."movie_id0" = "t26"."id" AND "t23"."movie_id" = "t26"."id" AND "t23"."movie_id1" = "t26"."id"
;
