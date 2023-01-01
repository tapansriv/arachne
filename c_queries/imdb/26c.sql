SELECT MIN("t22"."name") AS "character_name", MIN("t22"."info0") AS "rating", MIN("t25"."title") AS "complete_hero_movie"
FROM (SELECT "t20"."movie_id", "t20"."name", "t20"."movie_id0", "t20"."id6", "t20"."movie_id1", "t20"."info0", "t20"."movie_id2"
FROM (SELECT "t18"."movie_id", "t18"."name", "t18"."person_id", "t18"."movie_id0", "t18"."id6", "t18"."movie_id1", "t18"."info0", "t19"."movie_id" AS "movie_id2"
FROM (SELECT "t9"."movie_id", "t9"."name", "t9"."person_id", "t9"."movie_id0", "t14"."id" AS "id5", "t16"."id" AS "id6", "t17"."movie_id" AS "movie_id1", "t17"."info" AS "info0"
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
FROM movie_info_idx) AS "t17" ON "t9"."movie_id0" = "t17"."movie_id" AND "t9"."movie_id" = "t17"."movie_id" AND "t11"."id" = "t17"."info_type_id") AS "t18"
INNER JOIN (SELECT "movie_id", "keyword_id"
FROM movie_keyword) AS "t19" ON "t18"."movie_id0" = "t19"."movie_id" AND "t18"."movie_id" = "t19"."movie_id" AND "t18"."movie_id1" = "t19"."movie_id" AND "t18"."id5" = "t19"."keyword_id") AS "t20"
INNER JOIN (SELECT "id"
FROM name) AS "t21" ON "t20"."person_id" = "t21"."id") AS "t22"
INNER JOIN (SELECT "id", "title", "kind_id"
FROM title
WHERE "production_year" > 2000) AS "t25" ON "t22"."id6" = "t25"."kind_id" AND "t22"."movie_id2" = "t25"."id" AND "t22"."movie_id0" = "t25"."id" AND "t22"."movie_id" = "t25"."id" AND "t22"."movie_id1" = "t25"."id"
;
