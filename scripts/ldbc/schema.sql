drop table if exists message;
drop table if exists forum;
drop table if exists forum_person;
drop table if exists forum_tag;
drop table if exists person;
drop table if exists person_tag;
drop table if exists knows;
drop table if exists likes;
drop table if exists person_university;
drop table if exists person_company;
drop table if exists message_tag;
drop table if exists tagclass;
drop table if exists organisation;
drop table if exists place;
drop table if exists "tag";

create table message (
    m_creationdate timestamp without time zone not null,
    m_messageid bigint not null,
    m_ps_imagefile varchar,
    m_locationip varchar not null,
    m_browserused varchar not null,
    m_content varchar(2500),
    m_length bigint not null,
    m_creatorid bigint,
    m_ps_forumid bigint,
    m_locationid bigint,
    m_c_replyof bigint
);

create table forum (
   f_creationdate timestamp without time zone not null,
--   f_deletiondate timestamp without time zone not null,
   f_forumid bigint not null,
   f_title varchar not null,
   f_moderatorid bigint
);

create table forum_person (
   fp_creationdate timestamp without time zone not null,
-- fp_deletiondate timestamp without time zone not null,
   fp_forumid bigint not null,
   fp_personid bigint not null
);

create table forum_tag (
   ft_creationdate timestamp without time zone not null,
--   ft_deletiondate timestamp without time zone not null,
   ft_forumid bigint not null,
   ft_tagid bigint not null
);

create table organisation (
   o_organisationid bigint not null,
   o_type varchar not null,
   o_name varchar not null,
   o_url varchar not null,
   o_placeid bigint
);


create table person (
   p_creationdate timestamp without time zone not null,
--   p_deletiondate timestamp without time zone not null,
   p_personid bigint not null,
   p_firstname varchar not null,
   p_lastname varchar not null,
   p_gender varchar not null,
   p_birthday varchar not null,
   p_locationip varchar not null,
   p_browserused varchar not null,
   p_placeid bigint,
   p_language varchar,
   p_email varchar(350)
);

create table person_tag (
   pt_creationdate timestamp without time zone not null,
--   pt_deletiondate timestamp without time zone not null,
   pt_personid bigint not null,
   pt_tagid bigint not null
);

create table knows (
   k_creationdate timestamp without time zone not null,
--   k_deletiondate timestamp without time zone not null,
   k_person1id bigint not null,
   k_person2id bigint not null
);

create table likes (
   l_creationdate timestamp without time zone not null,
--   l_deletiondate timestamp without time zone not null,
   l_personid bigint not null,
   l_messageid bigint not null
);

create table person_university (
   pu_creationdate timestamp without time zone not null,
--   pu_deletiondate timestamp without time zone not null,
   pu_personid bigint not null,
   pu_organisationid bigint not null,
   pu_classyear bigint not null
);

create table person_company (
   pc_creationdate timestamp without time zone not null,
--   pc_deletiondate timestamp without time zone not null,
   pc_personid bigint not null,
   pc_organisationid bigint not null,
   pc_workfrom bigint not null
);

create table place (
   pl_placeid bigint not null,
   pl_name varchar not null,
   pl_url varchar not null,
   pl_type varchar not null,
   pl_containerplaceid bigint
);

create table message_tag (
   mt_creationdate timestamp without time zone not null,
--   mt_deletiondate timestamp without time zone not null,
   mt_messageid bigint not null,
   mt_tagid bigint not null
);

create table tagclass (
   tc_tagclassid bigint not null,
   tc_name varchar not null,
   tc_url varchar not null,
   tc_subclassoftagclassid bigint
);

create table "tag" (
   t_tagid bigint not null,
   t_name varchar not null,
   t_url varchar not null,
   t_tagclassid bigint not null
);
