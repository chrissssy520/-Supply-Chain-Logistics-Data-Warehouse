-- dim products
drop table if exists dw.dim_products;

create table dw.dim_products as 
with cte as (
select
product_id,
sku,
product_name,
category,
unit_cost,
unit_price,
weight_kg,
lead_time_days,
reorder_qty,
round(((unit_price - unit_cost) / unit_price * 100)::numeric ,2)as  margin_pct



from raw_products
)

select 
product_id,
sku,
product_name,
category,
unit_cost,
unit_price,
weight_kg,
lead_time_days,
reorder_qty,
margin_pct,
case when margin_pct >= 40 then 'High'
when margin_pct >= 20 then 'Mid'
else 'Low' end as margin_tier
from cte;


alter table dw.dim_products add primary key (product_id);
create index idx_dim_product_category on dw.dim_products(category);
