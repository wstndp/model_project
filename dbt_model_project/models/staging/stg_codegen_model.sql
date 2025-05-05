with source as (

    select * from {{ source('dbt_wstndp', 'customers') }}

),

renamed as (

    select
        id as customer_id,
        name as customer_name,
        email as customer_email,
        first_order_at,
        number_of_orders,
        total_order_value

    from source

)

select * from renamed