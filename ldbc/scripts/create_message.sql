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
