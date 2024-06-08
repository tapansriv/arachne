



select  s_store_name
      ,sum(ss_net_profit)
 from store_sales
     ,date_dim
     ,store,
     (select ca_zip
     from (
      SELECT substr(ca_zip,1,5) ca_zip
      FROM customer_address
      WHERE substr(ca_zip,1,5) IN (
                          '93220','94263','59054','73171','14316','58123',
                          '40053','57369','10643','62634','37731',
                          '18124','64022','37212','19944','64403',
                          '87340','55646','61959','65660','99674',
                          '44296','17148','17955','48734','47537',
                          '28062','53708','65938','37342','35446',
                          '56464','39150','25173','24928','31376',
                          '33164','43919','36715','99666','71777',
                          '83824','39617','77954','36154','90861',
                          '58783','54162','85958','86284','49144',
                          '39492','27777','91399','81637','22215',
                          '21498','15713','34870','20319','97126',
                          '71284','81074','38583','75297','96618',
                          '21192','24293','98132','53971','98808',
                          '37607','50957','66097','12637','86506',
                          '40177','49580','70086','23039','84798',
                          '19468','97968','70531','43205','85675',
                          '84161','87862','90067','19308','94258',
                          '57336','14248','28046','40739','81865',
                          '12271','30236','32356','43725','95804',
                          '49561','97289','25475','31909','46046',
                          '24638','49132','99254','54495','38051',
                          '19419','79010','31238','62723','23598',
                          '79396','79017','75283','69421','18060',
                          '20980','44096','18203','32478','32451',
                          '61297','92397','77912','74406','91135',
                          '37906','37553','87661','98060','78313',
                          '74583','30812','34061','86046','19084',
                          '60338','25793','21139','38014','64890',
                          '56232','71496','35885','29384','17941',
                          '39490','80998','17485','74726','73184',
                          '44632','22072','74451','37096','10805',
                          '16525','37942','76277','33607','56761',
                          '40562','88974','73501','85388','26256',
                          '56565','10529','86342','95502','70897',
                          '11600','84642','43713','44308','44326',
                          '85567','80618','33289','34088','56774',
                          '27687','81312','93091','18623','52471',
                          '76815','37430','80305','95636','16976',
                          '33876','93243','63580','27708','91746',
                          '99600','26310','19506','63564','55580',
                          '57443','83859','94995','15162','25599',
                          '75257','57233','48163','27072','30444',
                          '80050','41196','72418','99147','21883',
                          '43195','48496','39679','78004','93954',
                          '74271','34292','79055','88960','13133',
                          '36152','69289','37780','85391','76678',
                          '78165','79407','75296','66140','36579',
                          '26446','89634','76666','90549','71980',
                          '65275','67248','91182','31947','13033',
                          '34864','35004','56605','84204','52400',
                          '77723','69369','30535','62510','25434',
                          '83684','91027','75761','78548','69720',
                          '23707','52462','22454','21245','14125',
                          '41042','99350','68022','59880','93590',
                          '49300','81567','50441','10183','26362',
                          '57519','23255','65245','38537','45031',
                          '82804','35151','14249','25730','60886',
                          '51417','67495','88514','19700','10312',
                          '32730','13990','37601','66561','86423',
                          '98655','46722','42477','45516','55672',
                          '21344','20898','19913','56807','72569',
                          '70178','26698','67564','50135','70404',
                          '53261','80055','23594','37620','33314',
                          '61098','27412','93692','25811','40914',
                          '34489','14364','27418','97524','98950',
                          '65185','23288','61242','61757','40470',
                          '47597','38158','82622','19798','36813',
                          '13215','84366','35844','42715','90009',
                          '81828','61750','52909','33360','61495',
                          '85354','28308','43165','42893','57910',
                          '56185','48881','87871','51821','33766',
                          '55652','77041','31801','26649','97285',
                          '42230','78392','50046','88439','12081',
                          '70850','90482','69686','68375','74609',
                          '33729','78176','24474','86607','41222',
                          '80430','79464','57933','61187','92241',
                          '32210','87457','35942','60901','57418',
                          '64737','37476','83827','65136','96145',
                          '35212','57131','76675','35692')
     intersect
      select ca_zip
      from (SELECT substr(ca_zip,1,5) ca_zip,count(*) cnt
            FROM customer_address, customer
            WHERE ca_address_sk = c_current_addr_sk and
                  c_preferred_cust_flag='Y'
            group by ca_zip
            having count(*) > 10)A1)A2) V1
 where ss_store_sk = s_store_sk
  and ss_sold_date_sk = d_date_sk
  and d_qoy = 1 and d_year = 1998
  and (substr(s_zip,1,2) = substr(V1.ca_zip,1,2))
 group by s_store_name
 order by s_store_name
 limit 100