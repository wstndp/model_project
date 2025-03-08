with order_items as (
    select * from {{ source('dbt_wstndp','order_items' ) }}
),

orders as (
    select * from {{ source ('dbt_wstndp', 'orders')}}
),

products as (
    select * from {{ source ('dbt_wstndp', 'products')}}
),

product_prices as (
    select * from {{ source ('dbt_wstndp', 'product_prices')}}
),


weekly_product_revenue as (
  select
    date_trunc(orders.created_at,week) as week,
    products.category,
    sum(product_prices.price /100) as total_sales
  from order_items 
  left join orders on orders.id = order_items.order_id
  left join products on products.id = order_items.product_id
  left join product_prices on order_items.product_id = product_prices.product_id
  and orders.created_at between product_prices.created_at and product_prices.ended_at
  group by
    1,2
  order by
    1,2
)

select * from weekly_product_revenue

