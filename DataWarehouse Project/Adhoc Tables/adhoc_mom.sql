-- Month-over-Month Revenue Trend with Running Total

with cte_mom_trend as (
select 
dd.year,
dd.month_num,
dd.month_short,

round(sum(case when fs.status not in ('Cancelled','Returned') 
then fs.net_revenue else 0 end)::numeric ,2) as total_net_revenue

from dw.dim_date dd
join dw.fact_sales fs on dd.full_date = fs.order_date::date
group by 1,2,3
),
    
mom_cte1 as (
select
year,
month_num,
month_short,
total_net_revenue,

lag(total_net_revenue) over(partition by year order by month_num) as previous_month_revenue,
total_net_revenue - lag(total_net_revenue) over(partition by year order by month_num) as mom_change,


sum(total_net_revenue) over(partition by year order by month_num asc) as running_total
from cte_mom_trend

)
select
year,
month_num,
month_short,
total_net_revenue,
previous_month_revenue,
mom_change,
round(mom_change /  nullif(previous_month_revenue,0) * 100 ,2) as mom_change_pct,
running_total

from mom_cte1

order by year, month_num asc;
