with source as (
    select * from {{ source('staging', 'main') }}
),

renamed as (
    select
        -- Client data
        "age"::int as age,
        trim(job) as job,
        trim(marital) as marital_status,
        trim(education) as education_level,
        trim("default") as has_credit_in_default,
        "balance"::decimal(10,2) as balance,
        trim(housing) as has_housing_loan,
        trim(loan) as has_personal_loan,
        
        -- Last contact data
        trim(contact) as contact_type,
        "day"::int as contact_day_of_month,
        trim("month") as contact_month,
        "duration"::int as contact_duration_seconds,
        
        -- Campaign data
        "campaign"::int as campaign_contacts,
        "pdays"::int as days_since_last_contact,
        "previous"::int as previous_contacts,
        trim(poutcome) as previous_campaign_outcome,

        -- Target variable
        case
            when trim(y) = 'yes' then true
            when trim(y) = 'no' then false
            else null
        end as has_subscribed

    from source
)

select * from renamed