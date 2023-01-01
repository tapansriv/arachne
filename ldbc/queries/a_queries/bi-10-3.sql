CREATE TABLE friend_list AS
    SELECT DISTINCT f.friend AS friendid
      FROM friends_shortest f
         , person tf -- the friend's preson record
         , place ci -- city
         , place co -- country
     WHERE 1=1
        -- join
       AND f.friend = tf.p_personid
       AND tf.p_placeid = ci.pl_placeid
       AND ci.pl_containerplaceid = co.pl_placeid
        -- filter
       AND f.hopCount BETWEEN 3 AND 5
       AND co.pl_name = 'Taiwan';
