create table web_returns(
	wr_returned_date_sk integer,
	wr_returned_time_sk integer,
	wr_item_sk integer not null,
	wr_refunded_customer_sk integer,
	wr_refunded_cdemo_sk integer,
	wr_refunded_hdemo_sk integer,
	wr_refunded_addr_sk integer,
	wr_returning_customer_sk integer,
	wr_returning_cdemo_sk integer,
	wr_returning_hdemo_sk integer,
	wr_returning_addr_sk integer,
	wr_web_page_sk integer,
	wr_reason_sk integer,
	wr_order_number integer not null,
	wr_return_quantity integer,
	wr_return_amt double precision,
	wr_return_tax double precision,
	wr_return_amt_inc_tax double precision,
	wr_fee double precision,
	wr_return_ship_cost double precision,
	wr_refunded_cash double precision,
	wr_reversed_charge double precision,
	wr_account_credit double precision,
	wr_net_loss double precision
);
