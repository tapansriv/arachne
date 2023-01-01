CREATE OR REPLACE EXTERNAL TABLE tpcds.call_center
OPTIONS (
          format = 'PARQUET',
          uris = ['gs://arachne-tpcds/call_center.parquet']
); 
CREATE OR REPLACE EXTERNAL TABLE tpcds.catalog_page
OPTIONS (
          format = 'PARQUET',
          uris = ['gs://arachne-tpcds/catalog_page.parquet']
); 
CREATE OR REPLACE EXTERNAL TABLE tpcds.catalog_returns
OPTIONS (
          format = 'PARQUET',
          uris = ['gs://arachne-tpcds/catalog_returns.parquet']
); 
CREATE OR REPLACE EXTERNAL TABLE tpcds.catalog_sales
OPTIONS (
          format = 'PARQUET',
          uris = ['gs://arachne-tpcds/catalog_sales.parquet']
); 
CREATE OR REPLACE EXTERNAL TABLE tpcds.customer
OPTIONS (
          format = 'PARQUET',
          uris = ['gs://arachne-tpcds/customer.parquet']
); 
CREATE OR REPLACE EXTERNAL TABLE tpcds.customer_address
OPTIONS (
          format = 'PARQUET',
          uris = ['gs://arachne-tpcds/customer_address.parquet']
); 
CREATE OR REPLACE EXTERNAL TABLE tpcds.customer_demographics
OPTIONS (
          format = 'PARQUET',
          uris = ['gs://arachne-tpcds/customer_demographics.parquet']
); 
CREATE OR REPLACE EXTERNAL TABLE tpcds.date_dim
OPTIONS (
          format = 'PARQUET',
          uris = ['gs://arachne-tpcds/date_dim.parquet']
); 
CREATE OR REPLACE EXTERNAL TABLE tpcds.household_demographics
OPTIONS (
          format = 'PARQUET',
          uris = ['gs://arachne-tpcds/household_demographics.parquet']
); 
CREATE OR REPLACE EXTERNAL TABLE tpcds.income_band
OPTIONS (
          format = 'PARQUET',
          uris = ['gs://arachne-tpcds/income_band.parquet']
); 
CREATE OR REPLACE EXTERNAL TABLE tpcds.inventory
OPTIONS (
          format = 'PARQUET',
          uris = ['gs://arachne-tpcds/inventory.parquet']
); 
CREATE OR REPLACE EXTERNAL TABLE tpcds.item
OPTIONS (
          format = 'PARQUET',
          uris = ['gs://arachne-tpcds/item.parquet']
); 
CREATE OR REPLACE EXTERNAL TABLE tpcds.promotion
OPTIONS (
          format = 'PARQUET',
          uris = ['gs://arachne-tpcds/promotion.parquet']
); 
CREATE OR REPLACE EXTERNAL TABLE tpcds.reason
OPTIONS (
          format = 'PARQUET',
          uris = ['gs://arachne-tpcds/reason.parquet']
); 
CREATE OR REPLACE EXTERNAL TABLE tpcds.ship_mode
OPTIONS (
          format = 'PARQUET',
          uris = ['gs://arachne-tpcds/ship_mode.parquet']
); 
CREATE OR REPLACE EXTERNAL TABLE tpcds.store
OPTIONS (
          format = 'PARQUET',
          uris = ['gs://arachne-tpcds/store.parquet']
); 
CREATE OR REPLACE EXTERNAL TABLE tpcds.store_returns
OPTIONS (
          format = 'PARQUET',
          uris = ['gs://arachne-tpcds/store_returns.parquet']
); 
CREATE OR REPLACE EXTERNAL TABLE tpcds.store_sales
OPTIONS (
          format = 'PARQUET',
          uris = ['gs://arachne-tpcds/store_sales.parquet']
); 
CREATE OR REPLACE EXTERNAL TABLE tpcds.time_dim
OPTIONS (
          format = 'PARQUET',
          uris = ['gs://arachne-tpcds/time_dim.parquet']
); 
CREATE OR REPLACE EXTERNAL TABLE tpcds.warehouse
OPTIONS (
          format = 'PARQUET',
          uris = ['gs://arachne-tpcds/warehouse.parquet']
); 
CREATE OR REPLACE EXTERNAL TABLE tpcds.web_page
OPTIONS (
          format = 'PARQUET',
          uris = ['gs://arachne-tpcds/web_page.parquet']
); 
CREATE OR REPLACE EXTERNAL TABLE tpcds.web_returns
OPTIONS (
          format = 'PARQUET',
          uris = ['gs://arachne-tpcds/web_returns.parquet']
); 
CREATE OR REPLACE EXTERNAL TABLE tpcds.web_sales
OPTIONS (
          format = 'PARQUET',
          uris = ['gs://arachne-tpcds/web_sales.parquet']
); 
CREATE OR REPLACE EXTERNAL TABLE tpcds.web_site
OPTIONS (
          format = 'PARQUET',
          uris = ['gs://arachne-tpcds/web_site.parquet']
); 
