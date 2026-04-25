--  Freight Cost by Carrier and Incoterm

with freight_cost as (
select 
fp.carrier_id,
rc.carrier_name,
rc.service_type,
fp.incoterm,
count(distinct fp.po_id) as total_pos,
round(sum(fp.freight_cost_usd)::numeric ,2) as total_freight_cost_usd,
round(avg(fp.freight_cost_usd)::numeric ,2) as avg_freight_cost_usd,

round(avg(fp.freight_cost_per_unit)::numeric ,2) as avg_freight_cost_per_unit



from dw.fact_procurement fp
left join raw_carriers rc on fp.carrier_id = rc.carrier_id 
group by 
fp.carrier_id,
rc.carrier_name,
rc.service_type,
fp.incoterm

)

select 
carrier_id,
carrier_name,
service_type,
incoterm,
total_pos,
total_freight_cost_usd,
avg_freight_cost_per_unit,
round(total_freight_cost_usd / sum(total_freight_cost_usd) over()::numeric
* 100 ,2) as pct_of_total_freight


from freight_cost
order by total_freight_cost_usd desc;