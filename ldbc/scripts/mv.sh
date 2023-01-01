sf=$1

cd out-sf"$sf"
cd graphs/parquet/raw/composite-merged-fk

cd static

mv Organisation organisation
mv Place place
mv Tag tag
mv TagClass tagclass

cd ../dynamic

mv Comment comment
mv Forum forum 
mv Forum_hasMember_Person forum_person
mv Forum_hasTag_Tag forum_tag
mv Person person
mv Person_hasInterest_Tag person_tag
mv Person_knows_Person knows
mv Person_studyAt_University person_university 
mv Person_workAt_Company person_company
mv Post post
