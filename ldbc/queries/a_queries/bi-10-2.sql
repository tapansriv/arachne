-- if a friend is reachable from startPerson using hopCount 2, 3 and 4, its distance from startPerson is 2
CREATE TABLE friends_shortest AS
    SELECT startPerson, min(hopCount) AS hopCount, friend
      FROM friends
     GROUP BY startPerson, friend;

