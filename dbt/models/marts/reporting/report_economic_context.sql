with features_extended as (
    select * from {{ ref('fact_features_extended') }}
)

select
    job,
    contact_month,
    
    -- Employment trend analysis
    case 
        when employment_variation_rate < 0 then 'declining'
        when employment_variation_rate = 0 then 'stable'
        else 'growing'
    end as employment_trend,
    
    -- Economic context
    avg(consumer_price_index) as avg_consumer_price_index,
    avg(consumer_confidence_index) as avg_consumer_confidence_index,
    avg(euribor_3_month_rate) as avg_euribor_rate,
    
    -- Campaign metrics
    count(*) as total_contacts,
    sum(case when has_subscribed then 1 else 0 end) as total_subscriptions,
    
    -- Menghitung subscription rate
    case 
        when count(*) > 0 then (sum(case when has_subscribed then 1 else 0 end)::float / count(*)) * 100
        else 0 
    end as subscription_rate_pct

from features_extended
group by 1, 2, 3
order by 1, 2, 3
