-- ad hoc Customer Return & Cancellation Rate

with cte_return_cancel_rate as (
select
fs.customer_id,
dc.customer_name,
dc.segment,
dc.zone,
count(*) as total_orders,

count(case when fs.status = 'Cancelled' then 1 else null end) 
as cancelled_orders,

count(case when fs.status = 'Returned' then 1 else null end) 
as returned_orders,

round(count(case when fs.status in ('Cancelled','Returned') then 1 else null end)::numeric
/ count(*) * 100 ,2) as bad_order_rate_pct,

round(sum(case when fs.status in ('Cancelled','Returned')
then fs.net_revenue else 0 end)::numeric ,2) as 	lost_revenue

from dw.fact_sales fs
left join dw.dim_customers dc on fs.customer_id = dc.customer_id 
group by 1,2,3,4
)
select
customer_id,
customer_name,
segment,
zone,
total_orders,
cancelled_orders,
returned_orders,
bad_order_rate_pct,
lost_revenue

from cte_return_cancel_rate
where bad_order_rate_pct > 20
order by bad_order_rate_pct desc;
