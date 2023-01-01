SELECT MIN("t8"."link") AS "link_type", MIN("t8"."title") AS "first_movie", MIN("t9"."title") AS "second_movie"
FROM (SELECT "t6"."link", "t6"."linked_movie_id", "t7"."title"
FROM (SELECT "t4"."link", "t4"."movie_id", "t5"."movie_id" AS "movie_id0", "t5"."linked_movie_id"
FROM (SELECT "t2"."id" AS "id0", "t2"."link", "t3"."movie_id"
FROM (SELECT "id"
FROM keyword
WHERE "keyword" = 'character-name-in-title') AS "t1"
CROSS JOIN 
(SELECT *
FROM link_type) AS "t2"
INNER JOIN (SELECT "movie_id", "keyword_id"
FROM movie_keyword) AS "t3" ON "t1"."id" = "t3"."keyword_id") AS "t4"
INNER JOIN (SELECT "movie_id", "linked_movie_id", "link_type_id"
FROM movie_link) AS "t5" ON "t4"."id0" = "t5"."link_type_id") AS "t6"
INNER JOIN (SELECT "id", "title"
FROM title) AS "t7" ON "t6"."movie_id" = "t7"."id" AND "t6"."movie_id0" = "t7"."id") AS "t8"
INNER JOIN (SELECT "id", "title"
FROM title) AS "t9" ON "t8"."linked_movie_id" = "t9"."id"
;
