#!/bin/bash
tables=("organisation" "place" "tag" "tagclass" "comment" "message_tag" "forum" "forum_person" "forum_tag" "person" "person_tag" "knows" "likes" "person_university" "person_company" "post")

tables=("message")

for tbl in ${tables[@]}
do
    qry="SELECT COUNT(*) FROM $tbl;"
    echo $qry
    echo $qry  | cockroach sql --insecure --host=localhost:26257
done


