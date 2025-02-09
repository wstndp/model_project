{{ config(materialized='table') }}

with weekly_product_revenue as (
    select * from {{ ref('int_weekly_product_revenue')}}
),

customer_type as (
    select * from {{ ref('int_weekly_new_and_old_customers')}}
),

final as (
    select 
        weekly_product_revenue.week as start_day_of_week,
        weekly_product_revenue.category as product_category,
        customer_type.customer_type,
        customer_type.total_sales
    from weekly_product_revenue 
    left join customer_type on customer_type.week = weekly_product_revenue.week
    order by
1 
)

select * from final