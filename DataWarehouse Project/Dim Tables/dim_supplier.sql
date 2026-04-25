-- dim supplier

drop table if exists dw.dim_supplier;

create table dw.dim_supplier as
select
rs.supplier_id,
rs.supplier_name,
rs.country,
rs.city,
rs.status,
count(distinct po.po_id) as total_pos,
sum(po.ordered_qty) as total_ordered_qty,
sum(po.received_qty) as total_received_qty,
round(coalesce(sum(po.received_qty) / nullif(sum(po.ordered_qty),0) ,0) * 100 ,2) as fillrate_pct
from raw_suppliers rs
left join raw_purchase_orders po on rs.supplier_id = po.supplier_id
group by 1,2,3,4,5;

alter table dw.dim_supplier add primary key (supplier_id);
create index idx_dim_supplier_country_status on dw.dim_supplier(country,status);