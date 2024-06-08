



select  s_store_name
      ,sum(ss_net_profit)
 from store_sales
     ,date_dim
     ,store,
     (select ca_zip
     from (
      SELECT substring(ca_zip,1,5) ca_zip
      FROM customer_address
      WHERE substring(ca_zip,1,5) IN (
                          '20459','81125','62421','30373','74224','37096',
                          '91007','91499','98030','11530','42566',
                          '88923','12980','56470','34546','46839',
                          '14995','39276','51074','34522','95026',
                          '79565','67369','91638','65635','29447',
                          '52773','51164','24444','96437','55309',
                          '42999','50275','28499','50389','76179',
                          '96143','12366','81781','47843','69433',
                          '99583','69055','99070','70435','56000',
                          '62808','92771','59886','56044','79662',
                          '10719','19857','90222','36599','45664',
                          '80443','57306','25392','69610','36965',
                          '11982','44459','53077','70855','62246',
                          '91405','57413','72150','63181','14529',
                          '72955','40724','54034','58031','90441',
                          '40535','47877','79806','77567','25665',
                          '21740','53172','71976','55126','43909',
                          '12089','94028','25868','42812','85782',
                          '10477','20671','97581','70137','25295',
                          '60628','66291','42030','40256','60082',
                          '49981','28559','75345','14242','73053',
                          '56369','89792','85450','66420','85411',
                          '98133','96586','71416','24777','82150',
                          '20273','85607','77018','53226','39878',
                          '67368','94195','22191','18744','65638',
                          '88171','85852','79229','73024','99449',
                          '75372','43447','82007','99880','99728',
                          '44942','84229','56627','99299','35267',
                          '93111','42231','36133','88584','65558',
                          '95582','46152','87697','34738','55933',
                          '86577','41700','61819','97738','28983',
                          '23579','70616','55746','34210','96255',
                          '85671','45919','56073','59393','61079',
                          '66655','38923','28374','28812','37653',
                          '63688','42694','86811','35800','45882',
                          '95412','65162','28101','75015','18384',
                          '97051','28484','46608','97164','14934',
                          '84536','71477','39164','51557','25276',
                          '27646','72519','55711','62932','28720',
                          '30430','27096','33365','12868','49101',
                          '38548','49592','51611','52387','79502',
                          '77626','17322','54252','50015','22498',
                          '26538','68594','28369','27107','15132',
                          '72350','28324','66136','59261','62429',
                          '24093','58844','56080','49661','14568',
                          '69387','39802','87422','73659','50975',
                          '56592','39137','28399','76663','23059',
                          '27782','61008','89408','33775','71916',
                          '17598','62963','97842','75428','75487',
                          '96776','33710','79921','79344','70505',
                          '48924','66677','82313','35385','52789',
                          '43013','66349','50421','36590','85707',
                          '58385','94641','63088','30207','36654',
                          '36727','16473','52394','99309','56555',
                          '13534','73591','98498','12200','85135',
                          '87564','52964','75621','83802','96545',
                          '90041','63145','20116','65360','85830',
                          '21615','69102','83655','64571','37321',
                          '41738','86188','24728','21996','62098',
                          '69886','29495','62254','22722','68990',
                          '37107','90963','20950','51982','32851',
                          '16697','81595','74029','30219','41360',
                          '67638','11890','73058','47716','70132',
                          '56743','29398','74380','54630','22792',
                          '74125','30358','86203','39035','55194',
                          '55725','80273','46272','37116','51341',
                          '29386','18130','65943','81225','73507',
                          '78489','93605','59581','11171','80823',
                          '55790','40231','61417','87665','51778',
                          '54960','46633','10077','15515','58388',
                          '44790','41287','20610','60160','84124',
                          '91317','39305','35271','70168','93152',
                          '66791','85846','29132','56275','23874',
                          '74863','41487','25360','26670','41754',
                          '30408','47886','92575','33401','28856',
                          '44258','77036','72340','55400','71021',
                          '77945','21030','58896','86903','53577',
                          '69744','70478','55718','23265','54350',
                          '57061','64812','16373','31171','90505',
                          '25220','35152','84761','63115')
     intersect
      select ca_zip
      from (SELECT substring(ca_zip,1,5) ca_zip,count(*) cnt
            FROM customer_address, customer
            WHERE ca_address_sk = c_current_addr_sk and
                  c_preferred_cust_flag='Y'
            group by ca_zip
            having count(*) > 10)A1)A2) V1
 where ss_store_sk = s_store_sk
  and ss_sold_date_sk = d_date_sk
  and d_qoy = 1 and d_year = 2002
  and (substring(s_zip,1,2) = substring(V1.ca_zip,1,2))
 group by s_store_name
 order by s_store_name
 limit 100