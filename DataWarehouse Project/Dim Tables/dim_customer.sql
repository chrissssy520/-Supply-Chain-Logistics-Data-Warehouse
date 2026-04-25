-- dim customer

drop table if exists dw.dim_customers;

create table dw.dim_customers as 
select
customer_id,
customer_name,
segment,
region,
country,
email,
status,
case when region = 'NCR' or region = 'Region III' then 'Luzon North'
	 when region = 'Region IV-A' then 'Luzon South'
	 when region = 'Region VII' or region = 'Metro Cebu' then 'Visayas'
	 when region = 'Region XI' or region = 'Mindanao' then 'Mindanao'
	 else 'Other' end as zone
 
from raw_customers;

alter table dw.dim_customers add primary key (customer_id);
create index idx_dim_customers_segment 
on dw.dim_customers(segment,zone);