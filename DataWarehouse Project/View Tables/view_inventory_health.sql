-- view inventory health

drop view if exists dw.vw_inventory_health;

create view dw.vw_inventory_health as 

with latest_snapshot as (
select
*,
row_number() over(partition by warehouse_id,product_id
	order by snapshot_date desc ) as rn
	from dw.fact_inventory 

)
select
ls.warehouse_id,
    ls.region,
    ls.product_id,
    ls.category,
    ls.snapshot_date,
    ls.qty_on_hand,
    ls.qty_reserved,
    ls.available_qty,
    ls.reorder_qty,
    ls.reorder_gap,
    ls.stock_coverage_flag,
    ls.inventory_value,
w.avg_inventory_value,
round(ls.qty_on_hand::numeric / nullif(w.capacity_sqm, 0) * 100,2) as utilization_pct


from latest_snapshot ls
left join dw.dim_warehouse w on ls.warehouse_id = w.warehouse_id

where rn = 1

order by stock_coverage_flag asc, reorder_gap desc;