with source as (
    select * from {{ source('staging', 'metadata') }}
),

renamed as (
    select
        -- Client data
        "age"::int as age,
        trim(job) as job,
        trim(marital) as marital_status,
        trim(education) as education_level,
        trim("default") as has_credit_in_default,
        trim(housing) as has_housing_loan,
        trim(loan) as has_personal_loan,
        
        -- Last contact data
        trim(contact) as contact_type,
        trim("month") as contact_month,
        trim(day_of_week) as contact_day_of_week,
        "duration"::int as contact_duration_seconds,
        
        -- Campaign data
        "campaign"::int as campaign_contacts,
        "pdays"::int as days_since_last_contact,
        "previous"::int as previous_contacts,
        trim(poutcome) as previous_campaign_outcome,
        
        -- Social and economic context attributes
        "emp_var_rate"::decimal(5,3) as employment_variation_rate,
        "cons_price_idx"::decimal(8,3) as consumer_price_index,
        "cons_conf_idx"::decimal(6,3) as consumer_confidence_index,
        "euribor3m"::decimal(6,3) as euribor_3_month_rate,
        "nr_employed"::decimal(8,1) as number_of_employees,

        -- Target variable
        case
            when trim(y) = 'yes' then true
            when trim(y) = 'no' then false
            else null
        end as has_subscribed

    from source
)

select * from renamed