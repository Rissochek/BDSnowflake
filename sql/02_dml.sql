-- 1) dim_date
insert into public.dim_date (sale_date, year, month, day, quarter)
select
  d.sale_date,
  extract(year from d.sale_date)::smallint,
  extract(month from d.sale_date)::smallint,
  extract(day from d.sale_date)::smallint,
  extract(quarter from d.sale_date)::smallint
from (
  select distinct to_date(nullif(sale_date,''), 'MM/DD/YYYY') as sale_date
  from public.mock_data
  where nullif(sale_date,'') is not null
) d
where d.sale_date is not null
on conflict (sale_date) do nothing;

-- 2) dim_customer
insert into public.dim_customer (
  customer_id,
  customer_first_name, customer_last_name, customer_age, customer_email,
  customer_country, customer_postal_code,
  customer_pet_type, customer_pet_name, customer_pet_breed
)
select distinct
  m.sale_customer_id as customer_id,
  nullif(m.customer_first_name,''),
  nullif(m.customer_last_name,''),
  m.customer_age,
  nullif(m.customer_email,''),
  nullif(m.customer_country,''),
  nullif(m.customer_postal_code,''),
  nullif(m.customer_pet_type,''),
  nullif(m.customer_pet_name,''),
  nullif(m.customer_pet_breed,'')
from public.mock_data m
where m.sale_customer_id is not null
on conflict (customer_id) do nothing;

-- 3) dim_seller
insert into public.dim_seller (
  seller_id,
  seller_first_name, seller_last_name, seller_email,
  seller_country, seller_postal_code
)
select distinct
  m.sale_seller_id as seller_id,
  nullif(m.seller_first_name,''),
  nullif(m.seller_last_name,''),
  nullif(m.seller_email,''),
  nullif(m.seller_country,''),
  nullif(m.seller_postal_code,'')
from public.mock_data m
where m.sale_seller_id is not null
on conflict (seller_id) do nothing;

-- 4) dim_store
insert into public.dim_store (
  store_name, store_location, store_city, store_state, store_country, store_phone, store_email
)
select distinct
  nullif(m.store_name,''),
  nullif(m.store_location,''),
  nullif(m.store_city,''),
  nullif(m.store_state,''),
  nullif(m.store_country,''),
  nullif(m.store_phone,''),
  nullif(m.store_email,'')
from public.mock_data m
on conflict (store_name, store_location, store_city, store_state, store_country) do nothing;

-- 5) dim_supplier 
insert into public.dim_supplier (
  supplier_name, supplier_contact, supplier_email, supplier_phone,
  supplier_address, supplier_city, supplier_country
)
select distinct
  nullif(m.supplier_name,''),
  nullif(m.supplier_contact,''),
  nullif(m.supplier_email,''),
  nullif(m.supplier_phone,''),
  nullif(m.supplier_address,''),
  nullif(m.supplier_city,''),
  nullif(m.supplier_country,'')
from public.mock_data m
on conflict (supplier_name, supplier_email, supplier_phone) do nothing;

-- 6) dim_product
insert into public.dim_product (
  product_id,
  product_name, product_category,
  product_brand, product_material,
  product_color, product_size,
  product_weight, product_description,
  product_rating, product_reviews,
  product_release_date, product_expiry_date,
  pet_category,
  supplier_id
)
select distinct
  m.sale_product_id as product_id,
  nullif(m.product_name,''),
  nullif(m.product_category,''),
  nullif(m.product_brand,''),
  nullif(m.product_material,''),
  nullif(m.product_color,''),
  nullif(m.product_size,''),
  m.product_weight::numeric,
  nullif(m.product_description,''),
  m.product_rating::numeric,
  m.product_reviews,
  to_date(nullif(m.product_release_date,''), 'MM/DD/YYYY'),
  to_date(nullif(m.product_expiry_date,''), 'MM/DD/YYYY'),
  nullif(m.pet_category,''),
  s.supplier_id
from public.mock_data m
left join public.dim_supplier s
  on s.supplier_name = nullif(m.supplier_name,'')
 and s.supplier_email = nullif(m.supplier_email,'')
 and s.supplier_phone = nullif(m.supplier_phone,'')
where m.sale_product_id is not null
on conflict (product_id) do nothing;

-- 7) fact_sales
insert into public.fact_sales (
  date_id, customer_id, seller_id, product_id, store_id,
  sale_quantity, sale_total_price
)
select
  dd.date_id,
  m.sale_customer_id,
  m.sale_seller_id,
  m.sale_product_id,
  ds.store_id,
  m.sale_quantity,
  m.sale_total_price::numeric
from public.mock_data m
join public.dim_date dd
  on dd.sale_date = to_date(nullif(m.sale_date,''), 'MM/DD/YYYY')
join public.dim_store ds
  on ds.store_name = nullif(m.store_name,'')
 and ds.store_location = nullif(m.store_location,'')
 and ds.store_city = nullif(m.store_city,'')
 and ds.store_state is not distinct from nullif(m.store_state,'')
 and ds.store_country = nullif(m.store_country,'');

