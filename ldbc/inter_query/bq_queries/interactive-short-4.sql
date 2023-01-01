select COALESCE(m_ps_imagefile,'')||COALESCE(m_content,'') AS content, m_creationdate
from ldbc.message
where m_messageid = 687194767741;
