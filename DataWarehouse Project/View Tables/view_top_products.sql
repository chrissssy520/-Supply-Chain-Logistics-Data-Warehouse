-- view top products

drop view if exists dw.vw_top_products;

create view dw.vw_top_products as 
with cteview2 as (
select 
fs.product_id,
dp.sku,
dp.product_name,
fs.category,
fs.margin_tier,

count(distinct fs.order_id) as total_orders,

sum(case when fs.status not in('Cancelled','Returned')  then fs.quantity 
else 0 end) as total_quantity_sold,

sum(case when fs.status not in('Cancelled','Returned')  then fs.gross_revenue 
else 0 end) as total_gross_revenue,

sum(case when fs.status not in('Cancelled','Returned')  then fs.net_revenue
else 0 end) as total_net_revenue,

round(avg(fs.unit_price)::numeric ,2) as avg_unit_price,
round(avg(dp.margin_pct),2) as avg_margin_pct,

rank() over(order by
sum(case when fs.status not in('Cancelled','Returned')  then fs.net_revenue
else 0 end) desc) as revenue_rank,

rank() over(order by
sum(case when fs.status not in('Cancelled','Returned')  then fs.quantity 
else 0 end) desc)
 as quantity_rank


from dw.fact_sales fs
left join dw.dim_products dp on fs.product_id = dp.product_id 

group by 1,2,3,4,5

)

select 
product_id,
sku,
product_name,
category,
margin_tier,
total_orders,
total_quantity_sold,
total_gross_revenue,
total_net_revenue,
avg_unit_price,
avg_margin_pct,
revenue_rank,
quantity_rank


from cteview2

order by revenue_rank asc;
