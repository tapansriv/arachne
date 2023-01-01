select p_personid,p_firstname, p_lastname, o_name, pc_workfrom
from ldbc.person, ldbc.person_company, ldbc.organisation, ldbc.place,
 ( select k_person2id
   from ldbc.knows
   where
   k_person1id = 21990232556256
   union all
   select k2.k_person2id
   from ldbc.knows k1, ldbc.knows k2
   where
   k1.k_person1id = 21990232556256 and k1.k_person2id = k2.k_person1id and k2.k_person2id <> 21990232556256
 ) f
where
    p_personid = f.k_person2id and
    p_personid = pc_personid and
    pc_organisationid = o_organisationid and
    pc_workfrom < 2012 and -- :workFromYear
    o_placeid = pl_placeid and
    pl_name = 'United_States' -- :countryName
order by pc_workfrom, p_personid, o_name desc
limit 10
;
