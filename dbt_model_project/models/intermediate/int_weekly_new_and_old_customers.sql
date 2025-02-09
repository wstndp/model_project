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

first_order as (
    select
        customer_id,
        MIN(created_at) AS first_order_date
    from
        orders
    group by
        customer_id
),

weekly_new_and_old_customer_revenue as (
    select
        date_trunc(orders.created_at,week) as week,
  -- Use window function to compare each order date with the first order date
        case when orders.created_at <= first_order.first_order_date then 'new' else 'returning' end AS customer_type,
        sum(product_prices.price /100) as total_sales
    from `analytics-engineers-club.coffee_shop.order_items` order_items 
    left join `analytics-engineers-club.coffee_shop.orders` orders on orders.id = order_items.order_id
    left join first_order on first_order.customer_id = orders.customer_id
    left join `analytics-engineers-club.coffee_shop.products` products on products.id = order_items.product_id
    left join `analytics-engineers-club.coffee_shop.product_prices` product_prices on order_items.product_id = product_prices.product_id and orders.created_at between product_prices.created_at and product_prices.ended_at
    group by
        1,2
    order by
        1,2
)

select * from weekly_new_and_old_customer_revenue