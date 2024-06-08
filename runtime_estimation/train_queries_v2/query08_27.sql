



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
                          '30388','51248','62375','32805','24926','72696',
                          '11482','69785','98368','18219','31441',
                          '52290','82108','27177','75442','91014',
                          '99946','36441','82518','26018','75673',
                          '66130','10069','23786','44084','22978',
                          '98233','99371','47545','78180','23886',
                          '59891','37081','16672','41352','62115',
                          '17043','58577','40112','61783','20293',
                          '85456','77341','86725','64838','34912',
                          '73848','67623','78314','29562','64074',
                          '86798','82429','23997','19687','57249',
                          '95889','84223','53710','45911','17894',
                          '55860','52744','59175','82812','35983',
                          '56294','83953','99944','23884','82574',
                          '49287','46067','29638','88075','91021',
                          '41881','84909','71469','28564','70066',
                          '82321','53542','23918','30157','45245',
                          '15883','22559','37013','55021','71150',
                          '46857','59791','67710','90265','87203',
                          '88541','27740','70939','32238','19935',
                          '45636','23499','25540','50610','92864',
                          '13390','90976','16068','86905','29257',
                          '48062','47022','24290','65756','21457',
                          '51311','60303','75747','12887','60490',
                          '38829','18484','83887','53226','91415',
                          '56332','65904','44217','81783','74056',
                          '73086','95240','69825','55128','59296',
                          '56599','85430','12642','14893','56300',
                          '19531','19035','74598','60951','73092',
                          '38057','76818','68222','67829','82149',
                          '69842','81908','31169','61570','16654',
                          '80019','18093','83804','33117','85204',
                          '81716','12040','10770','78103','84839',
                          '48972','83968','72931','56405','20176',
                          '64637','53728','21388','10626','76745',
                          '17375','27453','92508','33397','15420',
                          '22001','22685','16339','62083','51372',
                          '75050','54755','69759','33014','65930',
                          '19086','17904','59503','49931','29548',
                          '37091','56244','29427','83920','66865',
                          '19641','14668','12930','33575','17662',
                          '48051','46168','61038','75018','68980',
                          '84419','80720','21320','23882','29222',
                          '39310','29200','41246','27087','15290',
                          '78350','61221','80955','27302','44363',
                          '66127','15190','61551','92428','43825',
                          '23242','48382','76597','82706','27184',
                          '58731','56486','98033','29344','26862',
                          '69654','27558','81506','14247','61788',
                          '43603','41857','26532','81038','55717',
                          '31627','64037','77130','35839','54256',
                          '76581','95351','81139','40035','58313',
                          '40101','39160','24336','41378','28356',
                          '82629','67609','22373','14666','12970',
                          '98888','28075','66093','55571','19306',
                          '36977','46373','14620','22914','42726',
                          '97846','17938','36614','70807','40472',
                          '61363','72326','45549','22048','10709',
                          '38288','62204','49244','40915','11120',
                          '91500','59505','85493','57367','40780',
                          '38415','16834','42309','39430','81832',
                          '64409','95591','42768','59770','26124',
                          '28834','17077','63763','64337','11309',
                          '80080','10416','97014','46178','15664',
                          '78570','21078','36679','22021','11046',
                          '15207','71287','54572','90802','89590',
                          '15505','16634','47418','81143','45178',
                          '33675','48028','33291','48948','94905',
                          '88544','84226','56362','25150','22221',
                          '62772','75040','96571','67634','28033',
                          '12764','86689','82282','19756','87946',
                          '18558','68130','57351','79608','92150',
                          '49417','38508','39185','10675','99593',
                          '48567','57499','18147','85798','30706',
                          '10814','32240','60996','30365','90524',
                          '25926','53142','52508','53656','19440',
                          '29752','51870','36236','52777','78748',
                          '64719','72923','36116','32831','63233',
                          '32336','40229','56473','62856','67909',
                          '85130','15837','91306','26129')
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