with features as (
    select * from {{ ref('fact_features') }}
)

select
    job,
    contact_month,
    count(*) as total_contacts,
    sum(case when has_subscribed then 1 else 0 end) as total_subscriptions,
    
    -- Menghitung subscription rate
    case 
        when count(*) > 0 then (sum(case when has_subscribed then 1 else 0 end)::float / count(*)) * 100
        else 0 
    end as subscription_rate_pct

from features
group by 1, 2
order by 1, 2