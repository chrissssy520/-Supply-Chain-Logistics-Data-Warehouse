-- fact inventory

drop table if exists dw.fact_invetory;

create table dw.fact_inventory as 
select
ri.snapshot_id,
ri.snapshot_date,
ri.warehouse_id,
ri.product_id,
ri.qty_on_hand,
ri.qty_reserved,
ri.qty_in_transit,
ri.unit_cost,
ri.last_recount_date,

ri.qty_on_hand::numeric - ri.qty_reserved as available_qty,
ri.qty_on_hand::numeric * ri.unit_cost  as inventory_value,
dp.reorder_qty::numeric - ri.qty_on_hand as reorder_gap,
case when ri.qty_on_hand::numeric < dp.reorder_qty then 'Below Reorder' 
else 'Adequate' end as stock_coverage_flag,

dd.date_key,
dp.category,
dp.reorder_qty,
w.region


from raw_inventory ri 
left join dw.dim_date dd on ri.snapshot_date::date = dd.full_date
left join dw.dim_products dp on ri.product_id = dp.product_id
left join dw.dim_warehouse w on ri.warehouse_id = w.warehouse_id;




alter table dw.fact_inventory add primary key (snapshot_id);
create index idx_fact_inventory_date_key on dw.fact_inventory(date_key);
create index idx_fact_inventory_product_id on dw.fact_inventory(product_id);
create index idx_fact_inventory_warehouse_id on dw.fact_inventory(warehouse_id);