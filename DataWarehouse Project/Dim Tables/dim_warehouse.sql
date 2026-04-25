-- dim warehouse 

drop table if exists dw.dim_warehouse;

create table dw.dim_warehouse as 
select
rw.warehouse_id,
rw.warehouse_code,
rw.city,
rw.country,
rw.region,
rw.capacity_sqm,
count(distinct ri.snapshot_id) as total_snapshot,
sum(ri.qty_on_hand) as total_qty_on_hand,
round(avg(ri.qty_on_hand),2) as avg_qty_on_hand,
round(avg((ri.qty_on_hand * ri.unit_cost))::numeric ,2) as avg_inventory_value
from raw_warehouses rw
left join raw_inventory ri on rw.warehouse_id = ri.warehouse_id 
group by 1,2,3,4,5,6;

alter table dw.dim_warehouse add primary key (warehouse_id);
create index idx_dim_warehouse_country on dw.dim_warehouse(country);
create index idx_dim_warehouse_region on dw.dim_warehouse(region);
