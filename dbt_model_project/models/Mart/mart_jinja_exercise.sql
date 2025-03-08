{%- set category = ['coffee_beans', 'merch', 'brewing supples'] -%}

select
  week as date_week,
  {%- for category in category %}
  sum(case when category = '{{ category }}' then total_sales end) as {{ category|replace(' ', '_') }}_sales
  {%- if not loop.last %}, {% endif -%}
  {% endfor %}
from {{ ref('int_weekly_product_revenue') }}
group by 1s