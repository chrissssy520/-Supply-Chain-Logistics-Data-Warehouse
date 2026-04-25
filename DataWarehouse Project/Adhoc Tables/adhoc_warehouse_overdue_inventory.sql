-- ad hoc warehouse overdue inventory

with inventory_ranked as (
    select
        warehouse_id,
        region,
        product_id,
        category,
        qty_on_hand,
        reorder_qty,
        snapshot_date,
        stock_coverage_flag,
      
        row_number() over(partition by warehouse_id, product_id order by snapshot_date DESC) as rn,
       
        count(case when stock_coverage_flag = 'Below Reorder' then 1 end) 
            over(partition by warehouse_id, product_id) as months_below_reorder
    from dw.fact_inventory
)
select 
    warehouse_id,
    region,
    product_id,
    category,
    months_below_reorder,
    qty_on_hand as latest_qty_on_hand,
    reorder_qty,
    snapshot_date as latest_snapshot_date
from inventory_ranked
where rn = 1 
  and months_below_reorder >= 2 
order by months_below_reorder desc;
