-- fact procurement

drop table if exists dw.fact_procurement;


create table dw.fact_procurement as
SELECT 
    po.po_id,
    po.po_date,
    po.supplier_id,
    po.product_id,
    po.warehouse_id,
    po.carrier_id,
    po.ordered_qty,
    po.received_qty,
    po.unit_cost,
    po.incoterm,
    po.po_status,
    po.expected_arrival,
    po.freight_cost_usd,

 
    ordered_qty * unit_cost AS total_po_value,
    ROUND(received_qty::numeric / NULLIF(ordered_qty, 0) * 100, 2) AS receipt_rate_pct,
    
   
    NULLIF(actual_arrival, '')::date - po_date::date AS lead_time_actual,
    
    ROUND(freight_cost_usd::numeric / NULLIF(received_qty, 0), 2) AS freight_cost_per_unit,

    dd.date_key,
    ds.fillrate_pct,
    w.region

FROM raw_purchase_orders po 
LEFT JOIN dw.dim_date dd ON po.po_date::date = dd.full_date
LEFT JOIN dw.dim_supplier ds ON po.supplier_id = ds.supplier_id 
LEFT JOIN dw.dim_warehouse w ON po.warehouse_id = w.warehouse_id;

alter table dw.fact_procurement add primary key (po_id);
create index idx_fact_procurement_date_key on dw.fact_procurement(date_key);
create index idx_fact_procurement_supplier_id on dw.fact_procurement(supplier_id);
create index idx_fact_procurement_warehouse_id on dw.fact_procurement(warehouse_id);