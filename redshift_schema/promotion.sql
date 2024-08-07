create table promotion(
	p_promo_sk integer not null,
	p_promo_id varchar(16) not null,
	p_start_date_sk integer,
	p_end_date_sk integer,
	p_item_sk integer, 
	-- p_cost double precision, --sf1000
	p_cost bigint, --sf2000
	p_response_target integer,
	p_promo_name varchar(50),
	p_channel_dmail varchar(1),
	p_channel_email varchar(1),
	p_channel_catalog varchar(1),
	p_channel_tv varchar(1),
	p_channel_radio varchar(1),
	p_channel_press varchar(1),
	p_channel_event varchar(1),
	p_channel_demo varchar(1),
	p_channel_details varchar(100),
	p_purpose varchar(15),
	p_discount_active varchar(1)
);
