-- dim_date
create schema if not exists dw;

drop table if exists dw.dim_date;


create table dw.dim_date as
with date_series as (
select generate_series('2023-01-01', '2024-12-31', '1 day'::interval)::date as d
)
select 

to_char(d, 'YYYYMMDD')::int as date_key,
d as full_date,
extract(year from d)::int as year,
extract(month from d)::int as month_num,
to_char(d, 'Mon') as month_short,
trim(to_char(d, 'Day')) as day_name,
extract(week from d )::int as week_of_year,
extract(quarter from d)::int as calendar_quarter,

case when extract(month from d) between 7 and 9 then 1
when extract(month from d) between 10 and 12 then 2
when extract(month from d) between 1 and 3 then 3
else 4 end as fiscal_quarter,

case when extract(month from d) between 7 and 9 then 'FQ1'
when extract(month from d) between 10 and 12 then 'FQ2'
when extract(month from d) between 1 and 3 then 'FQ3'
else 'FQ4' end as fiscal_quarter_label,

case when extract(isodow from d) in (6,7) then 1 else 0 end as is_weekend

from date_series;

alter table dw.dim_date add primary key (date_key); 
create index idx_dim_date_full_date on dw.dim_date(full_date);