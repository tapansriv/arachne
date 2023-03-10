/*
 * m_ps_ denotes field specific to posts
 * m_c_  denotes field specific to comments
 * other m_ fields are common to posts and messages
 * Note: to distinguish between "post" and "comment" records:
 *   - m_c_replyof IS NULL for all "post" records
 *   - m_c_replyof IS NOT NULL for all "comment" records
 */

drop table if exists post;
create table post (
    -- m_creationdate timestamp without time zone not null,
    m_creationdate bigint not null,
    m_deletiondate bigint not null,
    m_explicitlyDeleted boolean not null,
    m_messageid bigint not null,
    m_ps_imagefile varchar,
    m_locationip varchar not null,
    m_browserused varchar not null,
    m_ps_language varchar,
    m_content text,
    m_length int not null,
    m_creatorid bigint,
    m_ps_forumid bigint,
    m_locationid bigint
);

drop table if exists comment;
create table comment (
    -- m_creationdate timestamp without time zone not null,
    m_creationdate bigint not null,
    m_deletiondate bigint not null,
    m_explicitlyDeleted boolean not null,
    m_messageid bigint not null,
    m_locationip varchar not null,
    m_browserused varchar not null,
    m_content text not null,
    m_length int not null,
    m_creatorid bigint,
    m_locationid int, -- int in parquet
    m_c_parentpostid bigint,
    m_c_parentcommentid bigint
);

drop table if exists message;
create table message (
    m_creationdate bigint not null,
    m_messageid bigint not null,
    m_rootpostid bigint not null,
    m_rootpostlanguage varchar,
    m_ps_imagefile varchar,
    m_locationip varchar not null,
    m_browserused varchar not null,
    m_content text,
    m_length int not null,
    m_creatorid bigint,
    m_forumid bigint,
    m_locationid int, -- int in parquet
    m_c_replyof bigint
);

-- drop view if exists message;
-- create view message as select m_creationdate, m_messageid, m_ps_imagefile, m_locationip, m_browserused, m_content, 
--   m_length, m_creatorid, m_ps_forumid, m_locationid, null as m_c_replyof from post 
--   union all select m_creationdate, m_messageid, null as m_ps_imagefile, m_locationip, m_browserused, m_content, 
--   m_length, m_creatorid, null as m_ps_forumid, m_locationid, coalesce(m_c_parentpostid, m_c_parentcommentid) m_c_replyof from comment;

drop table if exists forum;
create table forum (
--   f_creationdate timestamp without time zone not null,
--   f_deletiondate timestamp without time zone not null,
   f_creationdate bigint not null,
   f_deletiondate bigint not null,
   f_explicitlyDeleted boolean not null,
   f_forumid bigint not null,
   f_title varchar not null,
   f_moderatorid bigint
);

drop table if exists forum_person;
create table forum_person (
-- fp_creationdate timestamp without time zone not null,
-- fp_deletiondate timestamp without time zone not null,
   fp_creationdate bigint not null,
   fp_deletiondate bigint not null,
   fp_explicitlyDeleted boolean not null,
   fp_forumid bigint not null,
   fp_personid bigint not null
);

drop table if exists forum_tag;
create table forum_tag (
   -- ft_creationdate timestamp without time zone not null,
   -- ft_deletiondate timestamp without time zone not null,
   ft_creationdate bigint not null,
   ft_deletiondate bigint not null,
   ft_forumid bigint not null,
   ft_tagid int not null
);

drop table if exists person;
create table person (
--   p_creationdate timestamp without time zone not null,
--   p_deletiondate timestamp without time zone not null,
   p_creationdate bigint not null,
   p_deletiondate bigint not null,
   p_explicitlyDeleted boolean not null,
   p_personid bigint not null,
   p_firstname varchar not null,
   p_lastname varchar not null,
   p_gender varchar not null,
   p_birthday bigint not null,
   p_locationip varchar not null,
   p_browserused varchar not null,
   p_placeid int not null,
   p_language varchar not null,
   p_email varchar not null
);

drop table if exists person_tag;
create table person_tag (
   pt_creationdate bigint not null,
   pt_deletiondate bigint not null,
   pt_personid bigint not null,
   pt_tagid int not null
);

drop table if exists knows;
create table knows (
--   k_creationdate timestamp without time zone not null,
--   k_deletiondate timestamp without time zone not null,
   k_creationdate bigint not null,
   k_deletiondate bigint not null,
   k_explicitlyDeleted boolean not null,
   k_person1id bigint not null,
   k_person2id bigint not null
);

drop table if exists likes;
create table likes (
   l_creationdate bigint not null,
   l_deletiondate bigint not null,
   l_explicitlyDeleted boolean not null,
   l_personid bigint not null,
   l_messageid bigint not null
);

drop table if exists person_university;
create table person_university (
   pu_creationdate bigint not null,
   pu_deletiondate bigint not null,
   pu_personid bigint not null,
   pu_organisationid bigint not null,
   pu_classyear int not null
);

drop table if exists person_company;
create table person_company (
   -- pc_creationdate timestamp without time zone not null,
--   pc_deletiondate timestamp without time zone not null,
   pc_creationdate bigint not null,
   pc_deletiondate bigint not null,
   pc_personid bigint not null,
   pc_organisationid bigint not null,
   pc_workfrom int not null
);


drop table if exists message_tag;
create table message_tag (
   mt_creationdate bigint not null,
   mt_deletiondate bigint not null,
   mt_messageid bigint not null,
   mt_tagid int not null
);

-- static 
drop table if exists tagclass;
create table tagclass (
   tc_tagclassid int not null,
   tc_name varchar not null,
   tc_url varchar not null,
   tc_subclassoftagclassid int
);

drop table if exists organisation;
create table organisation (
   o_organisationid int not null,
   o_type varchar not null,
   o_name varchar not null,
   o_url varchar not null,
   o_placeid int
);

drop table if exists place;
create table place (
   pl_placeid int not null,
   pl_name varchar not null,
   pl_url varchar not null,
   pl_type varchar not null,
   pl_containerplaceid int
);

drop table if exists tag;
create table tag (
   t_tagid int not null,
   t_name varchar not null,
   t_url varchar not null,
   t_tagclassid int not null
);
