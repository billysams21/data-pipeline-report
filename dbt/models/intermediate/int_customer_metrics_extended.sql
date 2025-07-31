-- Intermediate model untuk menghitung metrik kampanye marketing per klien dengan indikator ekonomi
with stg_metadata as (
    select * from {{ ref('stg_metadata') }}
),

client_metrics_extended as (
    select
        -- Demografis klien
        age,
        job,
        marital_status,
        education_level,
        
        -- Profil kredit
        has_credit_in_default,
        has_housing_loan,
        has_personal_loan,
        
        -- Metrik kampanye
        campaign_contacts,
        days_since_last_contact,
        previous_contacts,
        previous_campaign_outcome,
        
        -- Metrik kontak
        contact_type,
        contact_month,
        contact_day_of_week,
        contact_duration_seconds,
        
        -- Indikator ekonomi
        employment_variation_rate,
        consumer_price_index,
        consumer_confidence_index,
        euribor_3_month_rate,
        number_of_employees,
        
        -- Target
        has_subscribed,
        
        -- Calculated metrics
        case 
            when days_since_last_contact = 999 then 'never_contacted'
            when days_since_last_contact <= 30 then 'recent'
            when days_since_last_contact <= 90 then 'medium'
            else 'old'
        end as last_contact_recency,
        
        case 
            when contact_duration_seconds <= 60 then 'very_short'
            when contact_duration_seconds <= 300 then 'short'
            when contact_duration_seconds <= 600 then 'medium'
            else 'long'
        end as contact_duration_category,
        
        case 
            when campaign_contacts = 1 then 'single_contact'
            when campaign_contacts <= 3 then 'few_contacts'
            when campaign_contacts <= 5 then 'multiple_contacts'
            else 'many_contacts'
        end as campaign_intensity,
        
        case 
            when previous_contacts = 0 then 'new_client'
            when previous_contacts <= 2 then 'returning_client'
            else 'frequent_client'
        end as client_type,
        
        -- Economic indicators categories
        case 
            when employment_variation_rate < -1 then 'very_negative'
            when employment_variation_rate < 0 then 'negative'
            when employment_variation_rate = 0 then 'neutral'
            when employment_variation_rate < 1 then 'positive'
            else 'very_positive'
        end as employment_trend,
        
        case 
            when consumer_confidence_index < -40 then 'very_low'
            when consumer_confidence_index < -20 then 'low'
            when consumer_confidence_index < 0 then 'negative'
            when consumer_confidence_index < 20 then 'positive'
            else 'very_positive'
        end as consumer_confidence_level

    from stg_metadata
)

select * from client_metrics_extended
