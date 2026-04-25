-- view sales summary

drop view if exists dw.vw_sales_summary;

create view dw.vw_sales_summary as 
with cteview as (
select 
dd.year,
dd.month_num,
dd.month_short,
fs.zone,
fs.segment,
fs.sales_channel,
count(*) as total_order,
sum(fs.quantity) as total_quantity,
sum(fs.gross_revenue) as total_gross_revenue,
sum(fs.discount_amount) as total_discount_amount,
sum(fs.net_revenue) as total_net_revenue,

round(sum(case when fs.status != 'Cancelled' then fs.net_revenue else 0 end)::numeric
/ nullif(sum(case when fs.status != 'Cancelled' then 1 else 0 end),0)::numeric ,2) as avg_order_value,

sum(case when fs.status = 'Cancelled' then 1 else 0 end)::numeric as cancelled_orders,

round(sum(case when fs.status = 'Cancelled' then 1 else 0 end)::numeric / count(*) * 100 ,2) 
as cancelled_rate_pct

from dw.fact_sales fs 
left join dw.dim_date dd on fs.order_date::date = dd.full_date
group by 1,2,3,4,5,6

)

select 
year,
month_num,
month_short,
zone,
segment,
sales_channel,
total_order,
total_quantity,
total_gross_revenue,
total_discount_amount,
total_net_revenue,
avg_order_value,
cancelled_orders,
cancelled_rate_pct

from cteview
order by year,month_num,zone,segment;