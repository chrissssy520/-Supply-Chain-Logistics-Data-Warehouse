-- view supplier performance

drop view if exists dw.vw_supplier_performance;
create view dw.vw_supplier_performance as
with cteview1 as (
select
ds.supplier_id,
ds.supplier_name,
ds.country,
count(distinct fp.po_id) as total_pos,
sum(fp.ordered_qty) as total_order_qty,
sum(fp.received_qty) as total_received_qty,
round(sum(fp.received_qty)::numeric / nullif(sum(fp.ordered_qty),0) * 100 ,2) as fill_rate_pct,
round(avg(fp.lead_time_actual) ,1) as avg_lead_time_days,
sum(fp.freight_cost_usd) as total_freight_cost,
round(avg(fp.freight_cost_per_unit) ,2) as avg_freight_cost_per_unit,
round(
    sum(case when (fp.po_status = 'Received' or fp.po_status = 'Partially Received') and fp.lead_time_actual <= 0 then 1 else 0 end)::numeric
    / nullif(sum(case when fp.po_status = 'Received' or fp.po_status = 'Partially Received' then 1 else 0 end), 0)
    * 100, 2
) as on_time_delivery_rate_pct
from __dw.fact_procurement__ fp
left join dw.dim_supplier ds on fp.supplier_id = ds.supplier_id
group by 1,2,3
)
select
supplier_id,
supplier_name,
country,
total_pos,
total_order_qty,
total_received_qty,
total_freight_cost,
fill_rate_pct,
avg_lead_time_days,
avg_freight_cost_per_unit,
on_time_delivery_rate_pct
from cteview1
order by fill_rate_pct desc;