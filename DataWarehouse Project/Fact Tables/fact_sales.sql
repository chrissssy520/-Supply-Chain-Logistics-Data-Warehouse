-- fact sales

drop table if exists dw.fact_sales;

create table dw.fact_sales as 
with fact_cte as (
select 
so.order_id, 
so.order_date, 
so.customer_id, 
so.product_id, 
so.warehouse_id, 
so.carrier_id, 
so.quantity, 
so.unit_price, 
so.discount_pct, 
so.status, 
so.payment_method, 
so.sales_channel, 
so.promised_delivery_date, 
so.actual_delivery_date,

dd.date_key,
dc.zone,
dc.segment,
dp.category,
dp.margin_tier,

so.quantity * so.unit_price as gross_revenue,
so.quantity * so.unit_price * so.discount_pct as discount_amount,
so.quantity * so.unit_price  - so.quantity * so.unit_price * so.discount_pct as net_revenue,
NULLIF(so.actual_delivery_date, '')::date  - so.promised_delivery_date::date as delivery_date_variance_days,

case when NULLIF(so.actual_delivery_date, '')::date  is null then null
when NULLIF(so.actual_delivery_date, '')::date  - so.promised_delivery_date::date > 0 then 1 
else 0 end as is_late_flag


from raw_sales_orders so
left join dw.dim_date dd on so.order_date::date = dd.full_date
left join dw.dim_customers dc on so.customer_id = dc.customer_id
left join dw.dim_products dp on so.product_id = dp.product_id
left join dw.dim_warehouse w on so.warehouse_id = w.warehouse_id

)
select
order_id, 
order_date, 
customer_id, 
product_id, 
warehouse_id, 
carrier_id, 
quantity, 
unit_price, 
discount_pct, 
status, 
payment_method, 
sales_channel, 
promised_delivery_date, 
actual_delivery_date,
date_key,
zone,
segment,
category,
margin_tier,
gross_revenue,
discount_amount,
net_revenue,
delivery_date_variance_days,
is_late_flag
from fact_cte;

alter table dw.fact_sales add primary key (order_id);
create index idx_face_sales_date_key on dw.fact_sales(date_key);
create index idx_face_sales_customer_id on dw.fact_sales(customer_id);
create index idx_face_sales_product_id on dw.fact_sales(product_id);