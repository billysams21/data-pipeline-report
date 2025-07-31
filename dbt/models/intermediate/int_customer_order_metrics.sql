-- Intermediate model untuk menghitung metrik kampanye marketing per klien
with stg_main as (
    select * from {{ ref('stg_main') }}
),

client_metrics as (
    select
        -- Demografis klien
        age,
        job,
        marital_status,
        education_level,
        
        -- Profil kredit dan keuangan
        has_credit_in_default,
        balance,
        has_housing_loan,
        has_personal_loan,
        
        -- Metrik kampanye
        campaign_contacts,
        days_since_last_contact,
        previous_contacts,
        previous_campaign_outcome,
        
        -- Metrik kontak
        contact_type,
        contact_day_of_month,
        contact_month,
        contact_duration_seconds,
        
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
        
        case 
            when balance < 0 then 'negative'
            when balance = 0 then 'zero'
            when balance <= 1000 then 'low'
            when balance <= 5000 then 'medium'
            else 'high'
        end as balance_category

    from stg_main
)

select * from client_metrics