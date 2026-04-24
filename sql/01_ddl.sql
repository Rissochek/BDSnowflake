create table if not exists public.dim_date (
  date_id serial primary key,
  sale_date date not null unique,
  year smallint not null,
  month smallint not null,
  day smallint not null,
  quarter smallint not null
);

create table if not exists public.dim_customer (
  customer_id integer primary key,
  customer_first_name text,
  customer_last_name text,
  customer_age integer,
  customer_email text,
  customer_country text,
  customer_postal_code text,
  customer_pet_type text,
  customer_pet_name text,
  customer_pet_breed text,
  unique (customer_email)
);

create table if not exists public.dim_seller (
  seller_id integer primary key,
  seller_first_name text,
  seller_last_name text,
  seller_email text,
  seller_country text,
  seller_postal_code text,
  unique (seller_email)
);

create table if not exists public.dim_store (
  store_id serial primary key,
  store_name text,
  store_location text,
  store_city text,
  store_state text,
  store_country text,
  store_phone text,
  store_email text,
  unique (store_email),
  unique (store_name, store_location, store_city, store_state, store_country)
);

create table if not exists public.dim_supplier (
  supplier_id serial primary key,
  supplier_name text,
  supplier_contact text,
  supplier_email text,
  supplier_phone text,
  supplier_address text,
  supplier_city text,
  supplier_country text,
  unique (supplier_email),
  unique (supplier_phone),
  unique (supplier_name, supplier_email, supplier_phone)
);

create table if not exists public.dim_product (
  product_id integer primary key,
  product_name text,
  product_category text,
  product_brand text,
  product_material text,
  product_color text,
  product_size text,
  product_weight numeric,
  product_description text,
  product_rating numeric,
  product_reviews integer,
  product_release_date date,
  product_expiry_date date,
  pet_category text,
  supplier_id integer references public.dim_supplier(supplier_id)
);

create table if not exists public.fact_sales (
  sale_id bigserial primary key,
  date_id integer not null references public.dim_date(date_id),
  customer_id integer not null references public.dim_customer(customer_id),
  seller_id integer not null references public.dim_seller(seller_id),
  product_id integer not null references public.dim_product(product_id),
  store_id integer not null references public.dim_store(store_id),
  sale_quantity integer,
  sale_total_price numeric
);
