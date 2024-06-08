



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
                          '78532','26118','98144','63926','57477','19112',
                          '25190','32618','68224','16050','98691',
                          '72278','74326','15944','85353','71015',
                          '40369','35248','15386','61153','24617',
                          '13478','63488','64365','36389','55099',
                          '96249','58685','72581','40072','39946',
                          '71367','64509','87844','66332','21935',
                          '46271','84904','88800','64119','20636',
                          '40364','68208','56076','12770','63149',
                          '32247','71353','96178','91356','71058',
                          '12377','41258','30754','86944','80708',
                          '11639','89434','94902','22433','71751',
                          '12184','14625','39460','12324','16696',
                          '35298','30393','13763','91691','83502',
                          '23786','98619','13523','17966','88071',
                          '17922','32818','11757','13041','82568',
                          '44613','37331','31050','28448','82940',
                          '75010','50715','68849','79715','30105',
                          '73632','63824','74780','38512','78393',
                          '58674','77960','46210','41209','46715',
                          '50852','49346','63145','67238','37256',
                          '32521','23594','17225','56553','33339',
                          '14291','59445','38845','87990','49612',
                          '53242','69396','15051','58844','23497',
                          '61718','37941','14066','71558','65173',
                          '53806','67436','20869','53095','84545',
                          '89782','94084','18115','33829','49522',
                          '43702','10060','54528','62465','26868',
                          '55023','87409','72303','87833','23712',
                          '50538','66104','58335','61455','22395',
                          '66331','52879','47405','60566','23058',
                          '16232','56761','38379','41256','64768',
                          '14277','40974','84698','63044','73752',
                          '28197','59794','49871','53767','78922',
                          '60608','90586','13246','13509','66820',
                          '42135','18957','32276','84190','20194',
                          '33498','66840','84700','71317','52802',
                          '17218','37520','89134','65361','59455',
                          '82544','64282','27455','53491','96075',
                          '64146','41596','71308','41850','38868',
                          '75098','59574','39928','32076','13113',
                          '98767','79727','44361','11554','44226',
                          '77331','26148','97532','22231','86516',
                          '58018','44878','26103','11528','24857',
                          '80189','24820','39174','73369','54131',
                          '89486','34649','73912','42623','49246',
                          '76446','43898','43671','12347','32897',
                          '45985','66600','39867','24200','19980',
                          '43660','36733','32407','22044','33261',
                          '88726','23029','65051','25947','71642',
                          '81702','42634','84628','19595','67171',
                          '70227','87448','87387','61426','38601',
                          '41044','47549','75051','42461','23284',
                          '90978','57751','72696','75300','43735',
                          '66147','60863','61258','96179','97396',
                          '74873','54171','62821','43366','18369',
                          '85049','50351','61515','24837','39567',
                          '33234','89993','12588','10775','76293',
                          '70922','73815','26715','40594','46940',
                          '38701','99517','36694','75588','77430',
                          '81310','26120','40111','73265','96238',
                          '30151','29861','87781','24299','57499',
                          '14300','28639','79983','15686','32925',
                          '68854','60900','99201','28566','91879',
                          '39100','62748','23255','37261','10103',
                          '39752','99779','61810','53517','75710',
                          '29770','33926','41773','23740','96519',
                          '12463','93472','71165','37435','30008',
                          '87005','54475','26138','22372','76863',
                          '92359','79068','39623','79079','43253',
                          '93450','60987','40839','78770','96924',
                          '78461','30645','10013','21728','11378',
                          '37192','76011','72816','11890','42902',
                          '70203','11969','63205','86687','96258',
                          '80334','40377','80335','61173','55622',
                          '56651','77251','84522','10409','45175',
                          '40058','55174','82753','49728','92642',
                          '27307','49275','90282','68041','10501',
                          '65276','78772','69551','65040','88789',
                          '43006','46418','13720','87681')
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
  and d_qoy = 1 and d_year = 2000
  and (substring(s_zip,1,2) = substring(V1.ca_zip,1,2))
 group by s_store_name
 order by s_store_name
 limit 100