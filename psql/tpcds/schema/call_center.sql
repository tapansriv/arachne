create table call_center(
	cc_call_center_sk integer not null,
	cc_call_center_id varchar(16) not null,
	cc_rec_start_date date, 
    cc_rec_end_date date, 
    cc_closed_date_sk integer,
	cc_open_date_sk integer,
	cc_name varchar(50),
	cc_class varchar(50),
	cc_employees integer,
	cc_sq_ft integer,
	cc_hours varchar(20),
	cc_manager varchar(40),
	cc_mkt_id integer,
	cc_mkt_class varchar(50),
	cc_mkt_desc varchar(100),
	cc_market_manager varchar(40),
	cc_division integer,
	cc_division_name varchar(50),
	cc_company integer,
	cc_company_name varchar(50),
	cc_street_number varchar(10),
	cc_street_name varchar(60),
	cc_street_type varchar(15),
	cc_suite_number varchar(10),
	cc_city varchar(60),
	cc_county varchar(30),
	cc_state varchar(2),
	cc_zip varchar(10),
	cc_country varchar(20),
	cc_gmt_offset double precision,
	cc_tax_percentage double precision,
    dummy int,
    PRIMARY KEY (cc_call_center_sk)
);
