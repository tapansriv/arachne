



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
                          '80625','96884','27033','25164','15078','92924',
                          '88509','75565','40979','60641','74364',
                          '56457','67840','38034','42502','63144',
                          '57341','40923','22415','49448','53952',
                          '63610','53960','91451','36400','61073',
                          '21950','49070','16206','58351','11046',
                          '21520','45824','89145','57287','21672',
                          '10108','97987','70473','61979','79877',
                          '46225','78696','40671','40705','68805',
                          '12655','22304','14109','84829','58843',
                          '47631','45310','74839','81425','31159',
                          '95010','40809','61788','46117','79904',
                          '44172','72536','95650','82081','33290',
                          '52700','62406','76179','93647','69008',
                          '79862','72621','84745','21446','37915',
                          '34466','31088','34075','46410','61179',
                          '90657','31955','85665','99805','49114',
                          '37842','10799','28245','95713','15744',
                          '88363','56480','58584','41092','33796',
                          '55024','75738','63468','62042','70578',
                          '37139','65226','87897','34243','96469',
                          '92412','54669','51477','76088','83453',
                          '79107','83449','44742','51108','44179',
                          '64783','87296','10834','96983','35949',
                          '14275','25300','37812','69178','72875',
                          '26096','40800','66721','68226','66568',
                          '33677','83828','22570','10876','16678',
                          '77521','44702','90439','35034','46583',
                          '14413','51660','41547','84304','35409',
                          '50221','30462','46982','83286','34428',
                          '51782','83209','61032','30278','99610',
                          '28121','18251','78489','40819','39548',
                          '67325','13105','45557','55278','24565',
                          '73391','50526','68020','45075','41265',
                          '56931','95669','97852','72466','46731',
                          '44258','63926','72116','63534','22357',
                          '34074','79946','23922','19418','23660',
                          '39939','30312','82572','61407','28676',
                          '31187','16289','74784','86500','33587',
                          '54437','22333','61467','47780','75073',
                          '61630','41335','62377','68779','65364',
                          '59196','56349','26866','82651','10136',
                          '61000','72809','69760','37775','38585',
                          '94686','25926','21429','68057','31044',
                          '18370','21251','90566','29661','90973',
                          '75401','57347','84111','38188','88759',
                          '45149','66077','32552','39577','64701',
                          '11002','18998','32139','90268','77919',
                          '67666','17661','50630','49260','48513',
                          '11033','93790','37679','23359','70294',
                          '14272','40840','76348','62920','57509',
                          '86956','70118','90436','62324','12725',
                          '55028','89944','98837','47435','58635',
                          '79814','84769','14698','44579','31342',
                          '62766','90517','75486','29764','16792',
                          '34026','65766','92579','39762','57882',
                          '69952','90227','36670','96928','83370',
                          '31164','79717','82773','24574','28004',
                          '49006','90175','42941','23105','37232',
                          '83145','93582','23440','30954','11800',
                          '57880','50605','40713','64171','81896',
                          '98019','91788','48476','57378','97652',
                          '82543','47752','62416','93103','77397',
                          '38207','49442','48357','79265','54689',
                          '50926','98567','60175','67333','57199',
                          '32398','23486','16816','96844','83271',
                          '11590','89420','91309','98197','75789',
                          '29541','20386','18099','50735','45354',
                          '92469','53406','79545','47663','84878',
                          '37768','87161','63664','76085','25843',
                          '58200','73484','60520','57750','13135',
                          '12169','30723','90982','83122','12420',
                          '52829','38605','95007','83522','90387',
                          '69834','98534','94532','37824','49495',
                          '19670','53674','91040','49185','71630',
                          '31524','28370','79297','28563','68677',
                          '12594','77493','89604','77441','42196',
                          '50923','24600','23544','73358','38433',
                          '33922','95181','77929','32011','51054',
                          '83591','83168','96729','52291')
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
  and d_qoy = 2 and d_year = 2000
  and (substring(s_zip,1,2) = substring(V1.ca_zip,1,2))
 group by s_store_name
 order by s_store_name
 limit 100