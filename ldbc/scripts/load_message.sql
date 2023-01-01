-- LOAD VALUES INTO MESSAGE WITH RECURSIVE INFO TO GET FORUM FOR COMMENTS
-- Copy posts into comments
INSERT INTO message
SELECT 
	m_creationdate, 
	m_messageid as m_messageid, 
    m_messageid as m_rootpostid,
    m_ps_language as m_rootpostlanguage,
    m_ps_imagefile, 
    m_locationip, 
    m_browserused, 
    m_content, 
    m_length, 
    m_creatorid, 
    m_ps_forumid as m_forumid, 
    m_locationid, 
    null as m_c_replyof 
FROM post;

-- Comments attaching to existing Message trees
INSERT INTO message
    WITH RECURSIVE message_cte(messageid, rootpostid, rootpostlanguage, forumid, parentmessageid) AS (
        -- first half of the union: Comments attaching directly to the existing tree
        SELECT
            comment.m_messageid AS messageid,
            message.m_rootpostid AS rootpostid,
            message.m_rootpostlanguage AS rootpostlanguage,
            message.m_forumid AS forumid,
            coalesce(comment.m_c_parentpostid, comment.m_c_parentcommentid) AS parentmessageid
        FROM comment
        JOIN message
          ON message.m_messageid = coalesce(comment.m_c_parentpostid, comment.m_c_parentcommentid)
        UNION ALL
        -- second half of the union: Comments attaching newly inserted Comments
        SELECT
            comment.m_messageid AS messageid,
            message_cte.rootpostid AS rootpostid,
            message_cte.rootpostlanguage AS rootpostlanguage,
            message_cte.forumid AS forumid,
            Comment.m_c_parentcommentid AS parentmessageid
        FROM comment
        JOIN message_cte
          ON comment.m_c_parentcommentid = message_cte.messageid
    )
    SELECT
        comment.m_creationdate AS m_creationdate,
        comment.m_messageid AS m_messageid,
        message_cte.rootpostid AS m_rootpostid,
        message_cte.rootpostlanguage AS m_rootpostlanguage,
        NULL::varchar(40) AS m_ps_imagefile,
        comment.m_locationip AS m_locationip,
        comment.m_browserused AS m_browserused,
        comment.m_content AS m_content,
        comment.m_length AS m_length,
        comment.m_creatorid AS m_creatorid,
        message_cte.forumid AS m_forumid,
        comment.m_locationid AS m_locationid,
        coalesce(comment.m_c_parentpostid, comment.m_c_parentcommentid) AS m_c_replyof
        -- comment.m_ParentPostId,
        -- comment.ParentcommentId,
        -- 'comment' AS type
    FROM message_cte
    JOIN comment
      ON message_cte.MessageId = comment.m_messageid
;
