-- 1) Базовые количества
select 'mock_data' as table_name, count(*)::bigint as rows_cnt from public.mock_data
union all
select 'dim_date', count(*)::bigint from public.dim_date
union all
select 'dim_customer', count(*)::bigint from public.dim_customer
union all
select 'dim_seller', count(*)::bigint from public.dim_seller
union all
select 'dim_store', count(*)::bigint from public.dim_store
union all
select 'dim_supplier', count(*)::bigint from public.dim_supplier
union all
select 'dim_product', count(*)::bigint from public.dim_product
union all
select 'fact_sales', count(*)::bigint from public.fact_sales
order by table_name;

-- 2) Потери при загрузке facts
select
  (select count(*) from public.mock_data) as mock_data_cnt,
  (select count(*) from public.fact_sales) as fact_sales_cnt,
  (select count(*) from public.mock_data) - (select count(*) from public.fact_sales) as diff;

-- 3) Несопоставившиеся даты (ожидается 0)
select count(*) as not_matched_date
from public.mock_data m
left join public.dim_date dd
  on dd.sale_date = to_date(nullif(m.sale_date,''), 'MM/DD/YYYY')
where dd.date_id is null;

-- 4) Несопоставившиеся магазины (ожидается 0)
select count(*) as not_matched_store
from public.mock_data m
left join public.dim_store ds
  on ds.store_name = nullif(m.store_name,'')
 and ds.store_location = nullif(m.store_location,'')
 and ds.store_city = nullif(m.store_city,'')
 and ds.store_state is not distinct from nullif(m.store_state,'')
 and ds.store_country = nullif(m.store_country,'')
where ds.store_id is null;

-- 5) Проверка ссылочной целостности факта на измерения (ожидается 0 в каждой строке)
select
  sum(case when d.date_id is null then 1 else 0 end) as bad_date_fk,
  sum(case when c.customer_id is null then 1 else 0 end) as bad_customer_fk,
  sum(case when s.seller_id is null then 1 else 0 end) as bad_seller_fk,
  sum(case when p.product_id is null then 1 else 0 end) as bad_product_fk,
  sum(case when st.store_id is null then 1 else 0 end) as bad_store_fk
from public.fact_sales f
left join public.dim_date d on d.date_id = f.date_id
left join public.dim_customer c on c.customer_id = f.customer_id
left join public.dim_seller s on s.seller_id = f.seller_id
left join public.dim_product p on p.product_id = f.product_id
left join public.dim_store st on st.store_id = f.store_id;
